import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

Item {

    Text {
        id: noFavorites
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

        text: PersistanceManager.getString("noFavorites", "NoFavoritesView", "No favorites yet.

Use the ☆ button in the player to add stations here.")
    }
}
