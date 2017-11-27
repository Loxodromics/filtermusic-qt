import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

Rectangle {
    id: root

    color: UI.TABLE_BACKGROUND_COLOR

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        Image {
            id: logo
            fillMode: Image.PreserveAspectFit
            source: "qrc:/resources/images/filtermusic-logo-medium.png"

            Layout.minimumHeight: 10
            Layout.preferredWidth: parent.width
            Layout.minimumWidth: 0

//            Layout.fillHeight: true
        }

        Item {
            id: visitUs

            Layout.fillWidth: true
            height: visitUsText.height

            Text {
                id: visitUsText

                text: qsTr("Visit us at:")
                font.family: "Avenir"
                color: UI.PRIMARY_TEXT_COLOR
                anchors.left: parent.left
                anchors.leftMargin: UI.PADDING_NORMAL
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: visitUsLink

                text: qsTr("filtermusic.net")
                font.family: "Avenir"
                color: UI.PRIMARY_TEXT_COLOR
                anchors.right: parent.right
                anchors.rightMargin: UI.PADDING_NORMAL
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea {
                id: visitUsMouseArea

                anchors.fill: parent

                onClicked: {
                    Qt.openUrlExternally("https://filtermusic.net")
                }
            }
        }

        Item {
            id: contact

            Layout.fillWidth: true
            height: contactText.height

            Text {
                id: contactText

                text: qsTr("Contact:")
                font.family: "Avenir"
                color: UI.PRIMARY_TEXT_COLOR
                anchors.left: parent.left
                anchors.leftMargin: UI.PADDING_NORMAL
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: contactLink

                text: qsTr("info@filtermusic.net")
                font.family: "Avenir"
                color: UI.PRIMARY_TEXT_COLOR
                anchors.right: parent.right
                anchors.rightMargin: UI.PADDING_NORMAL
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id: contactMouseArea

                anchors.fill: parent

                onClicked: {
                    Qt.openUrlExternally("mailto:?to=info@filtermusic.net&subject=Feedback to filtermusic app")
                }
            }
        }

        Text {
            id: aboutText

            text: qsTr("Filtermusic is updated with radio stations that stream in high quality (128Kbps and higher) and play only music; you won't find a radio here where people having lenghty discussions. All streams presented have been filtered especially for electronic & dance music from thousands of stations all over the Internet.")
            font.family: "Avenir"
            color: UI.PRIMARY_TEXT_COLOR
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.margins: UI.PADDING_NORMAL
        }
    }
}
