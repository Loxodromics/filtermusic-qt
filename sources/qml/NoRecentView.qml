import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

Item {

    Text {
        id: noRecents
        color: UI.PRIMARY_TEXT_COLOR
        font.family: "Avenir"
        font.pointSize: UI.TEXT_SIZE_BIG
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        anchors.left: parent.left
        anchors.leftMargin: UI.PADDING_LARGE
        anchors.right: parent.right
        anchors.rightMargin: UI.PADDING_LARGE
        anchors.verticalCenter: parent.verticalCenter

        text: qsTr("No recent stations yet.

Listen to some stations and they will appear here.")
    }
}
