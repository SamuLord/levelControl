import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Popup {
    id: historyPopup
    width: 600
    height: 400

    modal: true
    focus: true

    Component.onCompleted: {
        historicModel.loadData()
    }

    contentItem: Rectangle {
        anchors.fill: parent
        border.width: 2
        border.color: "#333333"
        color: "#faf8f5"
        radius: 5

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            // Barra de título
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: "#333333"
                border.width: 2
                border.color: "black"

                Text {
                    anchors.centerIn: parent
                    text: qsTr("Histórico de Registros")
                    color: "#faf8f5"
                    font.bold: true
                    font.pixelSize: 18
                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10
                    text: qsTr("x")
                    color: "#faf8f5"
                    font.bold: true
                    font.pixelSize: 18

                    MouseArea {
                        anchors.fill: parent
                        onClicked: historyPopup.close()
                        onPressed: parent.opacity = 0.8
                        onReleased: parent.opacity = 1
                    }
                }
            }

            // Área de conteúdo
            Rectangle {
                id: historyContent
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "white"
                radius: 5
                border.color: "#cccccc"
                border.width: 1

                ListView {
                    id: historyList
                    anchors.fill: parent
                    anchors.margins: 5
                    clip: true
                    model: historicModel   // <-- model exposto do C++
                    delegate: Rectangle {
                        width: parent.width
                        height: 35
                        border.color: "#dddddd"
                        border.width: 1
                        color: index % 2 === 0 ? "#f9f9f9" : "#ffffff"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 10

                            Text { text: model.nome_equipamento; Layout.preferredWidth: 100 }
                            Text { text: model.data_hora; Layout.preferredWidth: 150 }
                            Text { text: model.valor; Layout.preferredWidth: 100 }
                            Text { text: model.percentual + "%"; Layout.preferredWidth: 100 }
                        }
                    }
                }
            }
        }
    }
}
