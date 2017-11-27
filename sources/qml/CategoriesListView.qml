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
//            color: UI.TABLE_CELL_BACKGROUND_COLOR
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
                x: UI.PADDING_NORMAL
                Text {
                    id: categoryName

                    text: name
                    color: UI.PRIMARY_TEXT_COLOR
                    font.pointSize: UI.TABLE_TEXT_SIZE
                }

                Text {
                    id: categorySubtext

                    text: numberOfStations + qsTr(" Stations")
                    color: UI.SUB_TEXT_COLOR
                    font.pointSize: UI.SUB_TEXT_SIZE
                }

                Rectangle {
                    id: seperator
                    color: UI.TABLE_SEPERATOR_COLOR
                    height: UI.TABLE_SEPERATOR_WIDTH
                    Layout.fillWidth: true
                }
            } /// ColumnLayout

            Text {
                id: rightChevron
                text: "›"
                color: UI.PRIMARY_TEXT_COLOR
                font.pointSize: UI.TEXT_SIZE_CHEVRON
                anchors.right: parent.right
                anchors.rightMargin: UI.PADDING_NORMAL
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id: categoryMouseArea

                anchors.fill: parent

                onClicked: {
                    console.log("onClicked")
                    beatAnimation.restart()
                    RadioStationManager.setCurrentCategory(category)
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
