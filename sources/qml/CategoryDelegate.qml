import QtQuick 2.7

Component {
    id: categoryDelegate

    Rectangle {
        id: categoryDelegateRoot
        width: categoryText.width
        height: categoryText.height

        Text {
            id: categoryText

            text: name
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
