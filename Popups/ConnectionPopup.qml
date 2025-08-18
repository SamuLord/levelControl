import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import "../Components"

Popup {
    id: configPopup
    width: 550
    height: 280

    contentItem: Rectangle {
        id: configBackground
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
                    text: qsTr("Conexão")
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
                        onClicked: configPopup.close();
                        onPressed: parent.opacity = 0.8
                        onReleased: parent.opacity = 1
                    }
                }
            }
            Rectangle {
                id: configContent
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.margins: 5
                    Text {
                        text: "Comunicação"
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

                            Text {
                                text: "IP de conexão: "
                                font.bold: true
                                font.pixelSize: 15
                            }
                            Rectangle {
                                Layout.preferredWidth: 250
                                Layout.preferredHeight: 45
                                radius: 8
                                color: "white"
                                border.color: "#cccccc"
                                border.width: 1
                                TextField {
                                    id: ipAdress
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    placeholderText: "192.168.1.1"
                                    font.family: "Segoe UI"
                                    font.pixelSize: 16
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                    background: null
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 45

                        RowLayout {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            spacing: 5

                            Text {
                                text: "Tempo de Requisição (ms): "
                                font.bold: true
                                font.pixelSize: 15
                            }
                            Rectangle {
                                Layout.preferredWidth: 250
                                Layout.preferredHeight: 45
                                radius: 8
                                color: "white"
                                border.color: "#cccccc"
                                border.width: 1
                                TextField {
                                    id: timeRequest
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    placeholderText: "10000"
                                    font.family: "Segoe UI"
                                    font.pixelSize: 16
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                    background: null
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 45

                        RowLayout {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            CheckBox {
                                id: requestAutCbx
                                Layout.fillHeight: true
                                Layout.preferredWidth: 200

                                text: "Requisição automática"
                                font.bold: true
                                font.pixelSize: 15
                            }

                            CheckBox {
                                id: forcedRequestCbx
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                text: "Permitir requisição forçada"
                                font.bold: true
                                font.pixelSize: 15
                            }
                        }
                    }

                    CustomButton {
                        id: confirmButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40

                        onClicked: {
                            ClientHandler.setAccessIP(ipAdress.text);
                            ClientHandler.setIntervalTimer(timeRequest.text);
                            ClientHandler.setForcedRequest(forcedRequestCbx.checked);
                            ClientHandler.handlerTimerRequest(requestAutCbx.checked);
                        }
                    }
                }
            }
        }
    }
}
