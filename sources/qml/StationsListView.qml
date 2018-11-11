import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

Item {
    id: root
    property alias stationModel: listView.model
    property bool showCategory: false

    ListView {
        id: listView

        anchors.fill: parent

        delegate: radioStationsDelegate

        header: Rectangle {
            id: categoryHeader

            height: showCategory ? UI.UNIT_HEIGHT : 0
            width: listView.width
            visible: showCategory
            color: UI.BACKGROUND_COLOR_ALTERNATIVE

            Text {
                id: categoryHeaderText

                color: UI.PRIMARY_TEXT_COLOR
                font.pointSize: UI.TEXT_SIZE_BIG
                font.family: UI.FONT_NAME
                text: RadioStationManager.categoryName
                anchors.left: parent.left
                anchors.leftMargin: UI.PADDING_NORMAL
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id: categoryHeaderMouseArea

                anchors.fill: parent

                onClicked: {
                    stackView.pop()
                }
            }
        }


        Component {
            id: radioStationsDelegate

            Rectangle {
                id: categoryDelegateRoot
                color: UI.TABLE_CELL_BACKGROUND_COLOR
                width: parent.width
                height: UI.UNIT_HEIGHT //Math.max(layout.height + seperator.height + UI.PADDING_SMALL, stationIcon.height + UI.PADDING_NORMAL)

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
                        font.pointSize: UI.TEXT_SIZE_BIG
                        font.family: UI.FONT_NAME
                    }
/*
                    Text {
                        id: stationDescription

                        text: longDescription
                        color: UI.SUB_TEXT_COLOR
                        font.pointSize: UI.SUB_TEXT_SIZE
                        font.family: UI.FONT_NAME
                        wrapMode: Text.WordWrap
                        Layout.maximumWidth: layout.width
                    }*/
                } /// ColumnLayout

                Image {
                    id: infoButton
                    source: "qrc:/resources/icons/info.png"

                    width: height
                    anchors.right: parent.right
                    anchors.margins: UI.PADDING_INFO_ICON
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    opacity: 0.14
                }

                MouseArea {
                    id: infoMouseArea

                    width: height
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    onClicked: {
                        RadioStationManager.setStation(uid)
                        player.maximize()
                    }
                }

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

                    anchors.left: parent.left
                    anchors.right: infoMouseArea.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
//                    enabled: reachable /// I'm undecided about this

                    onClicked: {
                        beatAnimation.restart()
                        AudioPlayer.pause()
                        RadioStationManager.setStation(uid)
                        AudioPlayer.play()
                    }
                }

                Rectangle {
                    id: overlayRect

                    color: "#66000000"
                    anchors.fill: parent
                    visible: !reachable
                }

                Image {
                    id: offlineIndicator
                    width: UI.STATION_ICON_WIDTH
                    height: UI.STATION_ICON_HEIGHT
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: UI.PADDING_NORMAL
                    source: "qrc:/resources/icons/disconnected.png"
                    visible: !reachable
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
