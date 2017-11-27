import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

Rectangle {
    id: root

    signal maximize

    color: "#AA000000"

    Image {
        id: stationImage
        fillMode: Image.PreserveAspectFit

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        source: RadioStationManager.logoUrl
    }

    Text {
        id: stationText

        text: RadioStationManager.stationName
        color: UI.PRIMARY_TEXT_COLOR
        font.family: "Avenir"

        anchors.centerIn: parent
    }

    PlayButton {
        id: playButton

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: UI.PADDING_SMALL
    }

    MouseArea {
        id: mouseArea

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: playButton.left
        anchors.bottom: parent.bottom

        onClicked: {
            if (RadioStationManager.streamUrl !== "") {
                root.maximize()
            }
        }
    }

}
