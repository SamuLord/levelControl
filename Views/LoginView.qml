import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Rectangle {
    id: loginView
    anchors.fill: parent
    color: "#faf8f5"
    signal loginSuccess()

    property var loader

    function login(user, senha) {
        loader.source = "qrc:/Views/OperationView.qml";
    }

    ColumnLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: 20

        Image {
            id: logo
            source: "qrc:/Images/logoIFMG.png"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: 176
            Layout.preferredHeight: 156
            antialiasing: true
            mipmap: true
        }

        Rectangle {
            width: 250
            height: 40
            radius: 8
            color: "white"
            border.color: "#cccccc"
            border.width: 1
            TextField {
                id: usernameField
                anchors.fill: parent
                anchors.margins: 8
                placeholderText: "Usuário"
                font.family: "Segoe UI"
                font.pixelSize: 16
                background: null
            }
        }

        Rectangle {
            width: 250
            height: 40
            radius: 8
            color: "white"
            border.color: "#cccccc"
            border.width: 1
            TextField {
                id: passwordField
                anchors.fill: parent
                anchors.margins: 8
                placeholderText: "Senha"
                echoMode: TextInput.Password
                font.family: "Segoe UI"
                font.pixelSize: 16
                background: null

                Keys.onReturnPressed: {
                    login(passwordField.text, usernameField.text);
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 250
            Layout.preferredHeight: 40
            radius: 8
            color: "#2e7d32"

            Text {
                anchors.centerIn: parent
                text: "Entrar"
                color: "#ffffff"
                font.pixelSize: 16
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed: parent.opacity = 0.8
                onReleased: parent.opacity = 1
                onClicked: {
                    login(passwordField.text, usernameField.text);
                }
            }
        }
    }
}
