import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

Rectangle {
    id: root

    color: UI.BACKGROUND_COLOR
    anchors.topMargin: root.parent.height

    Behavior on anchors.topMargin {
        PropertyAnimation {
            easing.type: Easing.InOutQuad
            duration: 250
        }
    }

//    Image {
//        id: backgroundImage
//        source: "qrc:/resources/images/background.jpg"
//        anchors.fill: parent
//    }

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

            Layout.preferredHeight: UI.UNIT_HEIGHT
            Layout.minimumHeight: UI.ICON_HEIGHT
            Layout.fillWidth: true

            Text {
                id: stationText

                text: RadioStationManager.stationName
                color: UI.PRIMARY_TEXT_COLOR
                font.family: UI.FONT_NAME
                font.pointSize: UI.TEXT_SIZE_BIG
                font.capitalization: Font.AllUppercase
                anchors.left: parent.left
                anchors.leftMargin: UI.PADDING_NORMAL
                anchors.right: minimizeButton.left
                anchors.verticalCenter: parent.verticalCenter
            }

            IconButton {
                id: minimizeButton
                iconSource: "qrc:/resources/icons/chevron_down.png"

                height: UI.ICON_HEIGHT
                width: height

                anchors.right: parent.right
                anchors.rightMargin: UI.PADDING_NORMAL
                anchors.verticalCenter: parent.verticalCenter

                onClicked: {
                    root.minimize()
                }
            }
        } /// header

        Item {
            Layout.preferredHeight: UI.PADDING_LARGE
//            Layout.maximumHeight: UI.PADDING_NORMAL
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }

        Image {
            id: stationImagePlaceholder
            fillMode: Image.PreserveAspectFit

            Layout.minimumHeight: 10
            Layout.preferredWidth: parent.width
            Layout.minimumWidth: 0
            Layout.preferredHeight: width * 0.56

//            Layout.fillHeight: true
            source: "qrc:/resources/icons/StationPlaceholder.png"

            Image {
                id: stationImage
                source: RadioStationManager.logoUrl
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

            Rectangle {
                /// what is this for?
                color: "transparent"
                anchors.fill: parent
            }
        }

        Item {
            Layout.preferredHeight: UI.PADDING_NORMAL
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }

        Text {
            id: nowPlayingText

            Layout.fillWidth: true
            Layout.minimumHeight: nowPlayingText.contentHeight
            Layout.preferredHeight: nowPlayingText.contentHeight
            Layout.leftMargin: UI.PADDING_NORMAL

            text: "Now Playing"
            font.family: UI.FONT_NAME
            font.pointSize: UI.TEXT_SIZE_NORMAL
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.NoWrap
            color: UI.PRIMARY_TEXT_COLOR
        }

        Item {
            Layout.preferredHeight: UI.PADDING_NORMAL
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }

        Item {
            id: titlePlayingTextContainter

            property int widthDifference: titlePlayingText.width - titlePlayingTextContainter.width

            Layout.fillWidth: true
            Layout.minimumHeight: titlePlayingText.contentHeight
            Layout.leftMargin: UI.PADDING_NORMAL

            implicitHeight: titlePlayingText.contentHeight

            Text {
                id: titlePlayingText

                property int offset: 0
                anchors.left: parent.left
//                anchors.leftMargin: UI.PADDING_NORMAL
                anchors.verticalCenter: parent.verticalCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.horizontalCenterOffset: offset

                text: AudioPlayer.title
                font.family: UI.FONT_NAME
                font.pointSize: UI.TEXT_SIZE_NORMAL
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.NoWrap
                color: UI.PRIMARY_TEXT_COLOR


                /// Marquee Animation for titles too long to display
                SequentialAnimation {
                    running: titlePlayingTextContainter.widthDifference > 0
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: titlePlayingText
                        property: 'offset'
                        duration: titlePlayingTextContainter.widthDifference * UI.MARQUEE_DURATION_FACTOR
                        from: -titlePlayingTextContainter.widthDifference / 2
                        to: titlePlayingTextContainter.widthDifference / 2
                    }

                    NumberAnimation {
                        target: titlePlayingText
                        property: 'offset'
                        duration: titlePlayingTextContainter.widthDifference * UI.MARQUEE_DURATION_FACTOR
                        from: titlePlayingTextContainter.widthDifference / 2
                        to: -titlePlayingTextContainter.widthDifference / 2
                    }
                }
            }
        }

        Item {
            Layout.preferredHeight: UI.PADDING_LARGE
//            Layout.maximumHeight: UI.PADDING_NORMAL
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }

        Rectangle {
            id: descriptionContainer

            Layout.leftMargin: UI.PADDING_NORMAL
            Layout.rightMargin: UI.PADDING_NORMAL
            Layout.fillWidth: true

            property int textHeight: descriptionText.contentHeight + 2 * radius

            Layout.preferredHeight: textHeight + 2 * UI.PADDING_NORMAL
            Layout.minimumHeight: 1
//            Layout.fillHeight: true
            color: "transparent"

            radius: 0

            Text {
                id: descriptionText
                text: RadioStationManager.longDescription
                font.family: UI.FONT_NAME
                font.pointSize: UI.TEXT_SIZE_NORMAL
//                horizontalAlignment: (lineCount === 1 ) ? Text.AlignHCenter : Text.AlignJustify
                horizontalAlignment: Text.AlignLeft

                anchors.fill: parent
//                anchors.margins: UI.PADDING_NORMAL
                wrapMode: Text.WordWrap
                clip: true
                color: UI.PRIMARY_TEXT_COLOR
            }
        } /// descriptionContainer

        Item {
            Layout.preferredHeight: UI.PADDING_LARGE
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }

        Rectangle {
            id: controlsContainer
            color: "transparent"

            Layout.fillWidth: true
            Layout.preferredHeight: 80
            Layout.minimumHeight: 30

            MouseArea {
                id: favoriteButton

                anchors.right: previousButton.left
                anchors.rightMargin: 0 //UI.PADDING_NORMAL
                height: parent.height
                width: height

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: UI.FAVORITE_BUTTON_SIZE
                    text: RadioStationManager.liked ? "★" : "☆"

                    color: "white"
                    horizontalAlignment: Text.AlignRight
                }

                onClicked: {
//                    console.log("nextButton clicked")
                    RadioStationManager.toggleLiked()
                }
            }

            IconButton {
                id: previousButton
                iconSource: "qrc:/resources/icons/button_prev.png"

                anchors.right: playButton.left
//                anchors.rightMargin: UI.PADDING_NORMAL
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
//                anchors.leftMargin: UI.PADDING_NORMAL
                height: parent.height

                onClicked: {
                    console.log("nextButton clicked")
                    RadioStationManager.nextStation()
                }
            }
        }

        Item {
            Layout.preferredHeight: UI.PADDING_LARGE
            Layout.minimumHeight: 0
            Layout.fillHeight: true
        }
    } /// mainLayout

    function maximize() {
        root.anchors.topMargin = UI.UNIT_HEIGHT
        GTracker.sendScreenView("PlayerView")
    }

    function minimize() {
        root.anchors.topMargin = root.parent.height
    }

    function isMaximized() {
        return (root.anchors.topMargin === 0)
    }
}
