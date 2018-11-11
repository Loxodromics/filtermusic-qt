import QtQuick 2.7
import "qrc:/sources/javascript/UiConstants.js" as UI

Component {
    id: categoryDelegate

    Rectangle {
        id: categoryDelegateRoot
        width: categoryText.width
        height: categoryText.height

        Text {
            id: categoryText

            text: name
            font.family: UI.FONT_NAME
            font.pointSize: UI.TEXT_SIZE_NORMAL
        }

        MouseArea {
            id: categoryMouseArea

            anchors.fill: parent

            onClicked: {
                RadioStationManager.setCurrentCategory(category)
                stackView.push(stationsView)
            }
        }
    }
}
