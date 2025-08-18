import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import "../Components"

Popup {
    id: parametersPopup
    width: 470
    height: 270

    contentItem: Rectangle {
        id: parametersBackground
        anchors.fill: parent
        border.width: 2
        border.color: "#333333"
        color: "#faf8f5"
        radius: 5

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

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
                    text: qsTr("Parâmetros")
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
                        onClicked: parametersPopup.close();
                        onPressed: parent.opacity = 0.8
                        onReleased: parent.opacity = 1
                    }
                }
            }
            Rectangle {
                id: parametersContent
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 5

                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Text {
                            text: "Configurações de operação"
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
                                    text: "Nível máximo: "
                                    font.bold: true
                                    font.pixelSize: 15
                                }
                                Rectangle {
                                    Layout.preferredWidth: 65
                                    Layout.preferredHeight: 45
                                    radius: 8
                                    color: "white"
                                    border.color: "#cccccc"
                                    border.width: 1
                                    TextField {
                                        id: lvlMaxOperation
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        placeholderText: "90"
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
                                    text: "Nível mínimo:  "
                                    font.bold: true
                                    font.pixelSize: 15
                                }
                                Rectangle {
                                    Layout.preferredWidth: 65
                                    Layout.preferredHeight: 45
                                    radius: 8
                                    color: "white"
                                    border.color: "#cccccc"
                                    border.width: 1
                                    TextField {
                                        id: lvlMinOperation
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        placeholderText: "60"
                                        font.family: "Segoe UI"
                                        font.pixelSize: 16
                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter
                                        background: null
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Text {
                            text: "Configurações de alarmes"
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
                                    text: "Nível máximo: "
                                    font.bold: true
                                    font.pixelSize: 15
                                }
                                Rectangle {
                                    Layout.preferredWidth: 65
                                    Layout.preferredHeight: 45
                                    radius: 8
                                    color: "white"
                                    border.color: "#cccccc"
                                    border.width: 1
                                    TextField {
                                        id: lvlMaxAlarm
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        placeholderText: "90"
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
                                    text: "Nível mínimo:  "
                                    font.bold: true
                                    font.pixelSize: 15
                                }
                                Rectangle {
                                    Layout.preferredWidth: 65
                                    Layout.preferredHeight: 45
                                    radius: 8
                                    color: "white"
                                    border.color: "#cccccc"
                                    border.width: 1
                                    TextField {
                                        id: lvlMinAlarm
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        placeholderText: "60"
                                        font.family: "Segoe UI"
                                        font.pixelSize: 16
                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter
                                        background: null
                                    }
                                }
                            }
                        }
                    }
                }
            }

            CustomButton {
                id: confirmButton
                text: "Enviar"
                Layout.fillWidth: true
                Layout.margins: 5
                Layout.preferredHeight: 40

                onClicked: {
                    var json = {
                        tipo: "parametros",
                        maxLevelOperation: lvlMaxOperation.text,
                        minLevelOperation: lvlMinOperation.text,
                        maxLevelAlarm: lvlMaxAlarm.text,
                        minLevelAlarm: lvlMinAlarm.text
                    };
                    ClientHandler.sendData(json);
                }
            }
        }
    }
}
