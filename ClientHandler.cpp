#include "ClientHandler.h"

ClientHandler::ClientHandler(QObject *parent)
    : QObject{parent}
{
    connect(&manager, &QNetworkAccessManager::finished, this, &ClientHandler::onFinished);
    connect(&timerRequest, &QTimer::timeout, this, &ClientHandler::onTimeoutRequest);

    timerRequest.setInterval(10000);
}

void ClientHandler::onFinished(QNetworkReply *reply)
{
    if (reply->error()) {
        emit requestError("Resposta com erro: " + reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray response = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(response);

    if (!doc.isObject()) {
        emit requestError("Resposta não é um json válido.");
        reply->deleteLater();
        return;
    }

    QJsonObject obj = doc.object();

    emit responseData(obj);
}

void ClientHandler::onTimeoutRequest()
{
    getData();
}

bool ClientHandler::getForcedRequest() const
{
    return forcedRequest;
}

void ClientHandler::setForcedRequest(bool newForcedRequest)
{
    forcedRequest = newForcedRequest;
}

void ClientHandler::getData()
{
    QUrl url("http://" + getAccessIP() + "/dados");
    QNetworkRequest request(url);
    manager.get(request);
}

void ClientHandler::sendData(const QJsonObject &obj)
{
    QUrl url("http://" + getAccessIP() + "/json");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonDocument doc(obj);
    manager.post(request, doc.toJson());
}

void ClientHandler::setAccessIP(const QString &newAccessIP)
{
    accessIP = newAccessIP;
}

QString ClientHandler::getAccessIP()
{
    return accessIP;
}

void ClientHandler::setIntervalTimer(const QString interval)
{
    bool ok;
    int intervalo = interval.toInt(&ok);
    if (ok && intervalo > 0) {
        timerRequest.setInterval(intervalo);
    }
}

void ClientHandler::handlerTimerRequest(const bool state)
{
    if (state) {
        timerRequest.start();
    } else {
        timerRequest.stop();
    }
}

