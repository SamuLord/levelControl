#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>
#define NUM_READINGS 10
#define BANDA_MORTA 2.0

const int PINO_TRIG = 4;
const int PINO_ECHO = 5;
const int PINO_BOMBA = 18;
const int PINO_ALARME_ALTO = 21;
const int PINO_ALARME_BAIXO = 19;
const int PINO_BOTAO = 34;
const int PINO_MAN_AUT = 23;
const int PINO_MANUTENCAO = 22;

float minLevel = 20;
float maxLevel = 5;
bool wifiConnected = false;

float maxLevelOperation = 90;
float minLevelOperation = 60;
float maxLevelAlarm = 100;
float minLevelAlarm = 20;
String operationMode = "automatico";

volatile float currentDistance = 0.0;
volatile float currentLevel = 0.0;
volatile bool alarmLowActive = false;
volatile bool alarmHighActive = false;
volatile bool statePump = false;

volatile bool btnFlag = false;
unsigned long pressTime = 0;

const char* ssid = "Samuel_2";
const char* password = "35617004";

WebServer server(80);
portMUX_TYPE mux = portMUX_INITIALIZER_UNLOCKED;

void setup() {
  Serial.begin(9600);
  server.on("/dados", HTTP_GET, handleSendData);
  server.on("/json", HTTP_POST, handleReceiveData);
  connectWifi();
  pinMode(PINO_TRIG, OUTPUT);
  pinMode(PINO_ECHO, INPUT);

  pinMode(PINO_ALARME_ALTO, OUTPUT);
  pinMode(PINO_ALARME_BAIXO, OUTPUT);
  pinMode(PINO_MAN_AUT, OUTPUT);
  pinMode(PINO_MANUTENCAO, OUTPUT);
  pinMode(PINO_BOMBA, OUTPUT);
  pinMode(PINO_BOTAO, INPUT);

  xTaskCreatePinnedToCore(
    taskSensor,
    "taskSensor",
    2048,
    NULL,
    1,
    NULL,
    0
  );

  xTaskCreatePinnedToCore(
    taskOperation,
    "taskOperation",
    2048,
    NULL,
    1,
    NULL,
    1 
  );

  xTaskCreatePinnedToCore(
    taskButton,
    "taskButton",
    4096,
    NULL,
    1,
    NULL,
    1 
  );

  attachInterrupt(digitalPinToInterrupt(PINO_BOTAO), handleButtonInterrupt, FALLING);
}

void loop() {
  checkWifi();
  if (wifiConnected) {
    server.handleClient();
  }
}

void handleButtonInterrupt() {
  btnFlag = true;
}

void taskSensor(void *param) {
  float readings[NUM_READINGS];
  float lastFilteredLevel = -999.0;

  while (true) {
    for (int i = 0; i < NUM_READINGS; i++) {
      readings[i] = measureDistance();
      vTaskDelay(pdMS_TO_TICKS(60));
    }
    float minVal = readings[0];
    float maxVal = readings[0];
    float sum = 0;
    for (int i = 0; i < NUM_READINGS; i++) {
      if (readings[i] < minVal) minVal = readings[i];
      if (readings[i] > maxVal) maxVal = readings[i];
      sum += readings[i];
    }
    sum -= (minVal + maxVal);
    float filteredAverage = sum / (NUM_READINGS - 2);
    float level = calculateTankLevel(filteredAverage, minLevel, maxLevel);

    if (lastFilteredLevel < -998.0 || abs(level - lastFilteredLevel) >= BANDA_MORTA) {
      lastFilteredLevel = level;
      setTanksValues(filteredAverage, level);
    }

    vTaskDelay(pdMS_TO_TICKS(500));
  }
}

void taskOperation(void *param) {
  while (true) {
    float nivel;
    portENTER_CRITICAL(&mux);
    nivel = currentLevel;
    alarmLowActive = (nivel < minLevelAlarm);
    alarmHighActive = (nivel > maxLevelAlarm);
    portEXIT_CRITICAL(&mux);
    if (operationMode == "automatico") {
      if (nivel <= minLevelOperation) {
        digitalWrite(PINO_BOMBA, HIGH);
        statePump = true;
      } else if (nivel >= maxLevelOperation) {
        digitalWrite(PINO_BOMBA, LOW);
        statePump = false;
      }
    } else if (operationMode == "manutencao") {
      digitalWrite(PINO_BOMBA, LOW);
      statePump = false;
    }

    if (nivel < minLevelAlarm) {
      digitalWrite(PINO_ALARME_BAIXO, HIGH);
    } else {
      digitalWrite(PINO_ALARME_BAIXO, LOW);
    }

    if (nivel > maxLevelAlarm) {
      digitalWrite(PINO_ALARME_ALTO, HIGH);
    } else {
      digitalWrite(PINO_ALARME_ALTO, LOW);
    }
    vTaskDelay(pdMS_TO_TICKS(500));
  }
}

void taskButton(void *param) {
  while (true) {
    if (btnFlag) {
      btnFlag = false;

      if (digitalRead(PINO_BOTAO) == LOW) {
        pressTime = millis();

        while (digitalRead(PINO_BOTAO) == LOW) {
          vTaskDelay(pdMS_TO_TICKS(10));
        }

        unsigned long pressDuration = millis() - pressTime;

        if (pressDuration > 5000) {
          digitalWrite(PINO_MANUTENCAO, HIGH);
          digitalWrite(PINO_MAN_AUT, LOW);
          operationMode = "manutencao";
        } else {
          if (operationMode == "automatico") {
            digitalWrite(PINO_MAN_AUT, HIGH);
            digitalWrite(PINO_MANUTENCAO, LOW);
            operationMode = "manual";
          } else if (operationMode == "manual") {
            digitalWrite(PINO_MAN_AUT, LOW);
            digitalWrite(PINO_MANUTENCAO, LOW);
            operationMode = "automatico";
          } else {
            digitalWrite(PINO_MAN_AUT, HIGH);
            digitalWrite(PINO_MANUTENCAO, LOW);
            operationMode = "manual";
          }
        }
      }
      vTaskDelay(pdMS_TO_TICKS(20));
    }
  }
}

void connectWifi() {
  WiFi.begin(ssid, password);
  Serial.print("Conectando ao WiFi");
}

void checkWifi() {
  if (!wifiConnected && WiFi.status() == WL_CONNECTED) {
    wifiConnected = true;
    Serial.println("Conectado ao WiFi. IP: " + WiFi.localIP().toString());
    server.begin();
  }
}

float measureDistance() {
  digitalWrite(PINO_TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(PINO_TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(PINO_TRIG, LOW);
  
  long duration = pulseIn(PINO_ECHO, HIGH);
  float distance = (duration * 0.0343) / 2;
  
  return distance;
}

float calculateTankLevel(float distance, float minLevel, float maxLevel) {
  float level;

  if (minLevel > maxLevel) {
    level = ((minLevel - distance) / (minLevel - maxLevel)) * 100.0;
  } else {
    level = ((distance - minLevel) / (maxLevel - minLevel)) * 100.0;
  }
  
  return level;
}

void setTanksValues(float distance, float level) {
  portENTER_CRITICAL(&mux);
  if (currentDistance != distance) {
    currentDistance = distance;
  }
  if (currentLevel != level) {
    currentLevel = level;
  }
  portEXIT_CRITICAL(&mux);
}

void handleSendData() {
  float distancia, nivel;
  bool alarmeBaixo, alarmeAlto, estadoBomba;

  portENTER_CRITICAL(&mux);
  distancia = currentDistance;
  nivel = currentLevel;
  alarmeBaixo = alarmLowActive;
  alarmeAlto = alarmHighActive;
  estadoBomba = statePump;
  portEXIT_CRITICAL(&mux);

  StaticJsonDocument<128> doc;
  doc["status"] = "ok";
  doc["tipo"] = "server";
  doc["distance"] = distancia;
  doc["level"] = nivel;
  doc["alarmLow"] = alarmeBaixo;
  doc["alarmHigh"] = alarmeAlto;
  doc["statePump"] = estadoBomba;

  String resposta;
  serializeJson(doc, resposta);
  server.send(200, "application/json", resposta);
}

void handleReceiveData() {
  if (server.hasArg("plain")) {
    String corpo = server.arg("plain");

    StaticJsonDocument<256> doc;
    DeserializationError erro = deserializeJson(doc, corpo);

    if (erro) {
      server.send(400, "text/plain", "JSON inválido");
      return;
    }

    JsonObject obj = doc.as<JsonObject>();
    String tipo = obj["tipo"] | "";

    StaticJsonDocument<128> resposta;

    if (tipo == "comando") {
      if (operationMode == "manual") {
        processCommand(obj);
        resposta["mensagem"] = "Comando executado";
      } else {
        resposta["mensagem"] = "Passe para o modo manual";
      }
      resposta["status"] = "ok";
      resposta["tipo"] = "comando";
    } else if (tipo == "parametros") {
      processParameters(obj);
      resposta["status"] = "ok";
      resposta["tipo"] = "parametros";
      resposta["mensagem"] = "Parâmetros atualizados";
    } else if (tipo == "operacao") { 
      processOperation(obj);
      resposta["status"] = "ok";
      resposta["tipo"] = "operacao";
      resposta["mensagem"] = "Mode de operação atualizado";
    }else {
      resposta["status"] = "erro";
      resposta["tipo"] = "desconhecido";
      resposta["mensagem"] = "Tipo desconhecido";
      String respostaStr;
      serializeJson(resposta, respostaStr);
      server.send(400, "application/json", respostaStr);
      return;
    }

    String respostaStr;
    serializeJson(resposta, respostaStr);
    server.send(200, "application/json", respostaStr);

  } else {
    server.send(400, "application/json", "{\"erro\":\"Corpo ausente\"}");
  }
}

void processCommand(JsonObject obj) {
  String comando = obj["comando"] | "";

  if (comando == "ligar") {
    digitalWrite(PINO_BOMBA, HIGH);
    statePump = true;
    Serial.println("Bomba ligada");
  } else if (comando == "desligar") {
    statePump = false;
    digitalWrite(PINO_BOMBA, LOW);
    Serial.println("Bomba desligada");
  } else {
    Serial.println("Comando desconhecido: " + comando);
  }
}

void processParameters(JsonObject obj) {
  String lvlMaxOperation = obj["maxLevelOperation"] | "";
  String lvlMinOperation = obj["minLevelOperation"] | "";
  String lvlMaxAlarm = obj["maxLevelAlarm"] | "";
  String lvlMinAlarm = obj["minLevelAlarm"] | "";

  if (lvlMaxOperation != "") {
      maxLevelOperation = lvlMaxOperation.toFloat();
      Serial.println("Novo maxLevelOperation: " + String(maxLevelOperation));
  }

  if (lvlMinOperation != "") {
      minLevelOperation = lvlMinOperation.toFloat();
      Serial.println("Novo minLevelOperation: " + String(minLevelOperation));
  }

  if (lvlMaxAlarm != "") {
      maxLevelAlarm = lvlMaxAlarm.toFloat();
      Serial.println("Novo maxLevelAlarm: " + String(maxLevelAlarm));
  }

  if (lvlMinAlarm != "") {
      minLevelAlarm = lvlMinAlarm.toFloat();
      Serial.println("Novo minLevelAlarm: " + String(minLevelAlarm));
  }
}

void processOperation(JsonObject obj) {
  String modo = obj["modo"] | "";

  if (modo == "automatico" || modo == "manual" || modo == "manutencao") {
    operationMode = modo;

    if (operationMode == "automatico") {
      digitalWrite(PINO_MAN_AUT, LOW);
      digitalWrite(PINO_MANUTENCAO, LOW);
    } else if (operationMode == "manual") {
      digitalWrite(PINO_MAN_AUT, HIGH);
      digitalWrite(PINO_MANUTENCAO, LOW);
    } else if (operationMode == "manutencao") {
      digitalWrite(PINO_MAN_AUT, LOW);
      digitalWrite(PINO_MANUTENCAO, HIGH);
    } 

    Serial.println("Modo de operação atualizado para: " + operationMode);
  } else {
    Serial.println("Modo de operação inválido recebido: " + modo);
  }
}

