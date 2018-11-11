import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/sources/javascript/UiConstants.js" as UI

Rectangle {
    id: root

    signal maximize

    color: UI.BACKGROUND_COLOR_ALTERNATIVE

    /* not in use
    Image {
        id: stationImage

        anchors.fill: parent
        source: RadioStationManager.logoUrl
    }

    GaussianBlur {
        id: blur

        anchors.fill: parent
        radius: 32
        samples: 32
        cached: true

        source: ShaderEffectSource {
            sourceItem: stationImage
            sourceRect: Qt.rect(0, 0, blur.width, blur.height)
        }
    }

    Rectangle {
        id: darkShade

        color: "black"
        opacity: 0.3

        anchors.fill: parent

    } */

    PlayButton {
        id: playButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: UI.PADDING_SMALL
    }

    MouseArea {
        id: mouseArea

        anchors.left: playButton.right
        /// make the button not directly adjacent to the play button, so it's not so easy to maximise the player accidentally
        anchors.leftMargin: UI.PADDING_LARGE
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        onClicked: {
            if (RadioStationManager.streamUrl !== "") {
                root.maximize()
            }
        }
    }

    Text {
        id: stationText

        text: RadioStationManager.stationName
        font.pointSize: UI.TEXT_SIZE_BIG
        color: UI.PRIMARY_TEXT_COLOR
        font.family: UI.FONT_NAME

        anchors.left: playButton.right
        anchors.leftMargin: UI.PADDING_NORMAL
        anchors.verticalCenter: parent.verticalCenter

    }

    Image {
        id: maximizeButton
        source: "qrc:/resources/icons/chevron_up.png"
        fillMode: Image.PreserveAspectFit

        height: UI.ICON_HEIGHT
        width: height

        anchors.right: parent.right
        anchors.rightMargin: UI.PADDING_NORMAL
        anchors.verticalCenter: parent.verticalCenter
    }

}
