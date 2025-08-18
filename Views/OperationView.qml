import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtMultimedia 5.15
import "../Components"

Rectangle {
    id: operationView
    width: 1360
    height: 697
    color: "black"
    property real persistDistance: -1

    Connections {
        target: ClientHandler

        function onResponseData(json) {
            if (json.tipo === "server") {
                level01.nivelCm = json.distance.toFixed(2);
                level01.nivelPercent = json.level.toFixed(2);
                pump01.status = json.statePump;
                highLevelAlarm.visible = json.alarmHigh;
                lowLevelAlarm.visible = json.alarmLow;

                if (persistDistance !== json.distance) {
                    let now = new Date();
                    let datetime = Qt.formatDateTime(now, "yyyy-MM-dd HH:mm:ss");
                    dbHandler.insertData("Reservatório", datetime, json.distance.toFixed(2), json.level.toFixed(2));

                    persistDistance = json.distance;
                }
            } else {
                console.log(JSON.stringify(json));
            }
        }
    }

    Image {
        id: background
        anchors.fill: parent
        source: "../Images/background.jpeg"
        mirror: true
        fillMode: Image.Stretch

        Image {
            id: highLevelAlarm
            x: 1254
            y: 102
            width: 90
            height: 66
            source: "../Images/aviso.png"
            fillMode: Image.PreserveAspectFit
            visible: false

            onVisibleChanged: {
                if (visible)
                    alarmPlayer.startAlarm()
                else
                    alarmPlayer.stopAlarm()
            }
        }

        Image {
            id: lowLevelAlarm
            x: 1254
            y: 427
            width: 90
            height: 66
            source: "../Images/aviso.png"
            fillMode: Image.PreserveAspectFit
            visible: false

            onVisibleChanged: {
                if (visible)
                    alarmPlayer.startAlarm()
                else
                    alarmPlayer.stopAlarm()
            }
        }
    }

    Loader {
        id: popupLoader
        anchors.centerIn: parent
        z: 999
        onLoaded: {
            if (item) {
                item.open();

                item.x -= (item.width / 2);
                item.y -= (item.height / 2);

                item.visibleChanged.connect(function () {
                    if (!item.visible) {
                        popupLoader.source = "";
                    }
                })
            }
        }
    }

    Rectangle {
        id: topMenu
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 5
        height: 35
        color: "transparent"

        RowLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            spacing: 5

            CustomButton {
                id: btnConnect
                text: "Conexão"
                Layout.preferredWidth: 135
                Layout.fillHeight: true
                bgColor: "#faf8f5"

                onClicked: {
                    popupLoader.source = "qrc:/Popups/ConnectionPopup.qml"
                }
            }

            CustomButton {
                id: btnHistorian
                text: "Histórico"
                Layout.preferredWidth: 135
                Layout.fillHeight: true
                bgColor: "#faf8f5"

                onClicked: {
                    popupLoader.source = "qrc:/Popups/HistorianPopup.qml"
                }
            }
        }

        Image {
            source: "../Images/refresh.png"
            fillMode: Image.PreserveAspectFit
            height: 35
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.rightMargin: 15

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (ClientHandler.getForcedRequest()) {
                        ClientHandler.getData();
                    }
                }
            }
        }

        LevelDisplay {
            x: 913
            y: 435
            id: level01
        }

        PumpDisplay {
            x: 53
            y: 435
            id: pump01
        }
    }

    CustomButton {
        id: btnCommands
        x: 77
        y: 569
        text: "Comandos"
        bgColor: "#faf8f5"
        Layout.preferredWidth: 135
        Layout.fillHeight: true
        border.width: 2
        border.color: "#333333"

        onClicked: {
            popupLoader.source = "qrc:/Popups/CommandPopup.qml"
        }
    }

    CustomButton {
        id: btnParam
        x: 942
        y: 569
        text: "Parâmetros"
        border.color: "#333333"
        border.width: 2
        bgColor: "#faf8f5"
        Layout.preferredWidth: 135
        Layout.fillHeight: true

        onClicked: {
            popupLoader.source = "qrc:/Popups/ParametersPopup.qml"
        }
    }

}
