import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

ListView {
    id: root

    model: radioGenreModel
    delegate: categoryDelegate

    Component {
        id: categoryDelegate

        Rectangle {
            id: categoryDelegateRoot
            color: "transparent"
            width: parent.width
            height: layout.height

            /// TODO
//            ListView.onRemove: SequentialAnimation {
//                PropertyAction { target: categoryDelegateRoot; property: "ListView.delayRemove"; value: true }
//                NumberAnimation { target: categoryDelegateRoot; property: "scale"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
//                PropertyAction { target: categoryDelegateRoot; property: "ListView.delayRemove"; value: false }
//            }

            ColumnLayout {
                id: layout
                width: parent.width - x
                height: UI.UNIT_HEIGHT
                x: UI.PADDING_NORMAL

                Text {
                    id: categoryName

                    text: name + " (" + numberOfStations + ")"
                    color: UI.PRIMARY_TEXT_COLOR
                    font.pointSize: UI.TEXT_SIZE_BIG
                    font.family: UI.FONT_NAME
                }

                Rectangle {
                    id: seperator
                    color: UI.TABLE_SEPERATOR_COLOR
                    height: UI.TABLE_SEPERATOR_WIDTH
                    Layout.fillWidth: true
                }
            } /// ColumnLayout

            Image {
                id: rightChevron
                fillMode: Image.PreserveAspectFit
                source: "qrc:/resources/icons/chevron_right.png"
                anchors.right: parent.right
                anchors.margins: UI.PADDING_NORMAL
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: height
            }

            MouseArea {
                id: categoryMouseArea

                anchors.fill: parent

                onClicked: {
                    console.log("onClicked")
                    beatAnimation.restart()
                    RadioStationManager.setCurrentCategory(category)
                    GTracker.sendEvent("UX", "Category", name)
                    stackView.push(stationsListView)
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
