import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

Rectangle {
    id: root

    color: UI.TABLE_BACKGROUND_COLOR
    anchors.topMargin: root.parent.height

    MouseArea {
        id: catchAllMouseare

        /// to not touch through the PlayerView
        anchors.fill: parent
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        Item {
            id: header

            Layout.preferredHeight: 30
            Layout.minimumHeight: 30
            Layout.fillWidth: true

            IconButton {
                id: minimizeButton
                iconSource: "qrc:/resources/icons/chevron_down.png"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: UI.PADDING_NORMAL
                anchors.bottom: parent.bottom

                onClicked: {
                    console.log("Player.minimizeButton clicked")
                    root.minimize()
                }
            }

            Text {
                id: stationText

                text: RadioStationManager.stationName
                color: UI.PRIMARY_TEXT_COLOR
                font.family: "Avenir"
                textFormat: Text.StyledText

                anchors.centerIn: parent
            }
        } /// header

        Image {
            id: stationImage
            fillMode: Image.PreserveAspectFit

            Layout.minimumHeight: 10
            Layout.preferredWidth: parent.width
            Layout.minimumWidth: 0

            Layout.fillHeight: true
            source: RadioStationManager.logoUrl

            Rectangle {
                color: "transparent" //"#c24c4caa"

                anchors.fill: parent
            }
        }

        Item {
            Layout.preferredHeight: UI.PADDING_NORMAL
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }

        Rectangle {
            id: descriptionContainer

            Layout.leftMargin: UI.PADDING_LARGE
            Layout.rightMargin: UI.PADDING_LARGE
            Layout.fillWidth: true

            property int textHeight: descriptionText.contentHeight + 2 * radius

            Layout.preferredHeight: textHeight
            Layout.minimumHeight: 1
            Layout.fillHeight: true
            color: UI.PRIMARY_TEXT_COLOR

            radius: 5

            Text {
                id: descriptionText
                text: RadioStationManager.longDescription
                font.family: "Avenir"

                anchors.fill: parent
                anchors.margins: UI.PADDING_NORMAL
                wrapMode: Text.WordWrap
                clip: true
                textFormat: Text.StyledText
            }
        } /// descriptionContainer

        Item {
            Layout.preferredHeight: UI.PADDING_NORMAL
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }

        Text {
            id: titlePlayingText
            text: AudioPlayer.title
            font.family: "Avenir"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.NoWrap
            color: UI.PRIMARY_TEXT_COLOR
            textFormat: Text.StyledText

            Layout.fillWidth: true
            Layout.minimumHeight: contentHeight
        }

        Item {
            Layout.preferredHeight: UI.PADDING_NORMAL
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }

        Rectangle {
            id: controlsContainer
            color: "transparent" //"#8040d72b"

            Layout.fillWidth: true
            Layout.preferredHeight: 50
            Layout.minimumHeight: 30

            IconButton {
                id: previousButton
                iconSource: "qrc:/resources/icons/button_prev.png"

                anchors.right: playButton.left
                anchors.rightMargin: UI.PADDING_LARGE
                height: parent.height

                onClicked: {
                    console.log("prevButton clicked")
                    RadioStationManager.previousStation()
                }
            }

            PlayButton {
                id: playButton

                anchors.centerIn: parent
                height: parent.height
            }

            IconButton {
                id: nextButton
                iconSource: "qrc:/resources/icons/button_next.png"

                anchors.left: playButton.right
                anchors.leftMargin: UI.PADDING_LARGE
                height: parent.height

                onClicked: {
                    console.log("nextButton clicked")
                    RadioStationManager.nextStation()
                }
            }

            MouseArea {
                id: favoriteButton

                anchors.left: nextButton.right
                anchors.leftMargin: UI.PADDING_NORMAL
                height: parent.height
                width: height
                Text {
                    anchors.centerIn: parent
                    font.pointSize: UI.FAVORITE_BUTTON_SIZE
                    text: RadioStationManager.liked ? "★" : "☆"
                    color: "white"
                }

                onClicked: {
                    console.log("nextButton clicked")
                    RadioStationManager.toggleLiked()
                }
            }
        }

        Item {
            Layout.preferredHeight: UI.PADDING_NORMAL
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }
    } /// mainLayout

    function maximize() {
        root.anchors.topMargin = 0
    }

    function minimize() {
        root.anchors.topMargin = root.parent.height
    }

    function isMaximized() {
        return (root.anchors.topMargin === 0)
    }
}
