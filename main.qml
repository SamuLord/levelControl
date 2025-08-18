import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: main
    visibility: "Maximized"
    title: qsTr("Sistema de Supervisão - Controle de Nível")

    Loader {
        id: loadScreen
        anchors.fill: parent
        source: "qrc:/Views/LoginView.qml"

        onLoaded: {
            if (item && item.hasOwnProperty("loader")) {
                item.loader = loadScreen;
            }
        }
    }

    function onLoginSucess() {
        loadScreen.source = "qrc:/Views/OperationView.qml"
    }
}
