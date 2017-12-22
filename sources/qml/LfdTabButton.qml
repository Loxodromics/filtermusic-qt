import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/sources/javascript/UiConstants.js" as UI

TabButton {
    id: control

    contentItem: Text {
        text: control.text
        font: control.font
        elide: Text.ElideRight
        opacity: enabled ? 1 : 0.3
        color: !control.checked ? UI.TABBAR_BUTTON_TEXT_COLOR_NORMAL : control.down ? UI.TABBAR_BUTTON_TEXT_COLOR_DOWN : UI.TABBAR_BUTTON_TEXT_COLOR_CHECKED
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        id: backgroundRectangle
        implicitHeight: 40

        color: control.down ? UI.TABBAR_BUTTON_BACKGROUND_DOWN : "transparent"

        Rectangle {
            id: selectedLine

            implicitHeight: 2

            opacity: control.checked ? 0.9 : 0.0
            color: UI.FILTERMUSIC_BLUE

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
}
