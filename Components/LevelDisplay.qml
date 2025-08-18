import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Rectangle {
    id: levelDisplay
    width: 180
    height: 120
    border.width: 2
    border.color: "#333333"
    color: "#faf8f5"
    radius: 5

    property real nivelCm: 0.0
    property real nivelPercent: 0.0

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
                text: qsTr("Reservatório")
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
                    text: "Nível: " + nivelCm + " cm"
                    font.pixelSize: 16
                    color: "black"
                }

                Text {
                    text: "Nível: " + nivelPercent + " %"
                    font.pixelSize: 16
                    color: "black"
                }
            }
        }
    }
}
