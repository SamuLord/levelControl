import QtQuick 2.15

Rectangle {
    id: customBtn
    width: 135
    height: 45
    radius: 5
    color: bgColor

    property string text: "Conexão"
    property color bgColor: "#95fcc2"
    signal clicked()

    Text {
        anchors.centerIn: parent
        text: customBtn.text
        color: "#333333"
        font.pixelSize: 16
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: customBtn.clicked();
        onPressed: parent.opacity = 0.8
        onReleased: parent.opacity = 1
    }
}
