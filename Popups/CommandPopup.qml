import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import "../Components"

Popup {
    id: commandPopup
    width: 345
    height: 215

    contentItem: Rectangle {
        id: commandBackground
        anchors.fill: parent
        border.width: 2
        border.color: "#333333"
        color: "#faf8f5"
        radius: 5

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10

            Rectangle {
                id: titleContent
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: "#333333"
                border.width: 2
                border.color: "black"
                Text {
                    id: title
                    anchors.centerIn: parent
                    text: qsTr("Comandos")
                    color: "#faf8f5"
                    font.bold: true
                    font.pixelSize: 18
                }

                Text {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 4
                    text: qsTr("x")
                    color: "#faf8f5"
                    font.bold: true
                    font.pixelSize: 18
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: commandPopup.close();
                        onPressed: parent.opacity = 0.8
                        onReleased: parent.opacity = 1
                    }
                }
            }
            Rectangle {
                id: commandContent
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.margins: 5

                    Text {
                        text: "Modo de operação"
                        font.bold: true
                        font.pixelSize: 15
                        font.underline: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 45

                        RowLayout {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            spacing: 5

                            ComboBox {
                                id: operationCbx
                                Layout.preferredWidth: 165
                                Layout.preferredHeight: 35
                                model: ["Automático", "Manual", "Manutenção"]
                                Component.onCompleted: operationCbx.currentIndex = 0
                            }

                            CustomButton {
                                text: "Enviar"
                                bgColor: "#fcf295"
                                Layout.preferredHeight: 35

                                onClicked: {
                                    var mapa = {
                                            "Automático": "automatico",
                                            "Manual": "manual",
                                            "Manutenção": "manutencao"
                                        };
                                    var modoOriginal = operationCbx.currentText;
                                    var modo = mapa[modoOriginal];
                                    var json = {
                                        tipo: "operacao",
                                        modo: modo
                                    };
                                    ClientHandler.sendData(json);
                                }
                            }
                        }
                    }

                    Text {
                        text: "Acionamento bomba"
                        font.bold: true
                        font.pixelSize: 15
                        font.underline: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 45

                        RowLayout {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            spacing: 25

                            CustomButton {
                                text: "Ligar"
                                Layout.preferredHeight: 35

                                onClicked: {
                                    var json = {
                                        tipo: "comando",
                                        comando: "ligar"
                                    };
                                    ClientHandler.sendData(json);
                                }
                            }

                            CustomButton {
                                text: "Desligar"
                                bgColor: "#ff5a5a"
                                Layout.preferredHeight: 35

                                onClicked: {
                                    var json = {
                                        tipo: "comando",
                                        comando: "desligar"
                                    };
                                    ClientHandler.sendData(json);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
