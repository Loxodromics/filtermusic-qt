import QtQuick 2.7
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

Rectangle {
    id: root

    color: "black"

    visible: PersistanceManager.isDeactived
    enabled: visible

    onVisibleChanged: {
        if (visible) {
            GTracker.sendScreenView("DeactivedView")
        }
    }

    MouseArea {
        id: catchAllClicksMouseArea

        anchors.fill: parent
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: UI.PADDING_NORMAL

        Image {
            id: logo
            fillMode: Image.PreserveAspectFit
            source: "qrc:/resources/images/filtermusic-logo-medium.png"

            Layout.minimumHeight: 10
            Layout.preferredWidth: parent.width
            Layout.minimumWidth: 0

        }

        Text {
            id: deactivatedText

            text: PersistanceManager.getString("deactivatedText", "DeactivatedView", "This version of filtermusic is no longer supported. Please check your store or our website for a newer version.")
            font.family: UI.FONT_NAME
            font.pointSize: UI.TEXT_SIZE_NORMAL
            color: UI.PRIMARY_TEXT_COLOR
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.margins: UI.PADDING_NORMAL
        }
    }
}
