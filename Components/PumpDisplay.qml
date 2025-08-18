import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Rectangle {
    id: pumpDisplay
    width: 180
    height: 120
    border.width: 2
    border.color: "#333333"
    color: "#faf8f5"
    radius: 5

    property bool status: false

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
                text: qsTr("Bomba")
                color: "#faf8f5"
                font.bold: true
                font.pixelSize: 18
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            Column {
                spacing: 5
                anchors.centerIn: parent

                Text {
                    text: "Estado: " + (status ? "Ligado" : "Desligado")
                    font.pixelSize: 16
                    color: {
                        if (status) {
                            return "#FF0000"
                        } else {
                            return "#00FF00"
                        }
                    }
                }
            }
        }
    }
}
