import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

Item {
    id: root
    property alias stationModel: listView.model

    ListView {
        id: listView

        anchors.fill: parent

//        model: radioStationModel
        delegate: radioStationsDelegate

        Component {
            id: radioStationsDelegate

            Rectangle {
                id: categoryDelegateRoot
                color: /*index % 2 ? "red" : "green"*/ UI.TABLE_CELL_BACKGROUND_COLOR
                width: parent.width
                height: Math.max(layout.height + seperator.height, stationIcon.height + UI.PADDING_NORMAL)

                Rectangle {
                    id: flashRectangle
                    color: UI.TABLE_CELL_FLASH_COLOR_TO

                    anchors.top: parent.top
                    anchors.topMargin: UI.FLASH_RECTANGLE_TOP_MARGIN
                    anchors.left: stationIcon.left
                    anchors.right: layout.right
                    anchors.bottom: seperator.top
                }

                Image {
                    id: stationIcon
                    source: logoUrl
                    width: UI.STATION_ICON_WIDTH
                    height: UI.STATION_ICON_HEIGHT
                    fillMode: Image.PreserveAspectCrop
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: UI.PADDING_NORMAL
                }

                ColumnLayout {
                    id: layout
                    width: parent.width - x - UI.PADDING_TINY
//                    x: stationIcon.width  + stationIcon.anchors.leftMargin + UI.PADDING_NORMAL
                    anchors.left: stationIcon.right
                    anchors.leftMargin: UI.PADDING_NORMAL
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 0

                    Text {
                        id: stationName

                        text: name
                        color: UI.PRIMARY_TEXT_COLOR
                        font.pointSize: UI.TABLE_TEXT_SIZE
                        textFormat: Text.StyledText
                    }

                    Text {
                        id: stationDescription

                        text: longDescription
                        color: UI.SUB_TEXT_COLOR
                        font.pointSize: UI.SUB_TEXT_SIZE
                        wrapMode: Text.WordWrap
                        textFormat: Text.StyledText
                        Layout.maximumWidth: layout.width
                    }
                } /// ColumnLayout

                Rectangle {
                    id: seperator
                    color: UI.TABLE_SEPERATOR_COLOR
                    height: UI.TABLE_SEPERATOR_WIDTH
//                    anchors.top: layout.bottom
//                    anchors.topMargin: UI.PADDING_TINY
                    anchors.left: parent.left
                    anchors.leftMargin: UI.PADDING_NORMAL
                    anchors.right: parent.right
                    anchors.rightMargin: UI.PADDING_TINY
                    anchors.bottom: parent.bottom
                }

                MouseArea {
                    id: categoryMouseArea

                    anchors.fill: parent

                    onClicked: {
                        console.log("onClicked")
                        beatAnimation.restart()
                        AudioPlayer.pause()
                        RadioStationManager.setStation(uid)
                        AudioPlayer.play()
                    }
                }

                PropertyAnimation {
                    id: beatAnimation
                    target: categoryDelegateRoot
                    properties: "color"
                    from: UI.TABLE_CELL_FLASH_COLOR_FROM
                    to: UI.TABLE_CELL_FLASH_COLOR_TO
                    duration: UI.TABLE_CELL_FLASH_TIME
                    easing.type: Easing.OutQuad
                    running: false
                }
            }
        }
    }
}
