import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI
import "qrc:/resources/text/licenceText.js" as License

ScrollView {
    id: root

    property int parentWidth: 300
    flickableItem.flickableDirection: Flickable.VerticalFlick

    Item {
        width: parentWidth - 2 * UI.PADDING_NORMAL
        height: licenses.height + mainLayout.height

        ColumnLayout {
            id: mainLayout
            anchors.margins: UI.PADDING_NORMAL
            width: parentWidth - 2 * UI.PADDING_NORMAL
            spacing: UI.PADDING_LARGE

            Item {
                height: UI.PADDING_LARGE
            }

            Image {
                id: logo
                fillMode: Image.PreserveAspectFit
                source: "qrc:/resources/images/filtermusic-logo-medium.png"

                Layout.minimumHeight: 10
                Layout.preferredWidth: parent.width
                Layout.minimumWidth: 0

            }

            Item {
                height: UI.PADDING_LARGE
            }

            Item {
                id: visitUs

                Layout.fillWidth: true
                height: visitUsText.height

                Text {
                    id: visitUsText

                    text: PersistanceManager.getString("visitUsText", "AboutView", "Visit us at:")
                    font.family: UI.FONT_NAME
                    font.pointSize: UI.TEXT_SIZE_SMALL
                    font.capitalization: Font.SmallCaps
                    color: UI.PRIMARY_TEXT_COLOR
                    anchors.left: parent.left
                    anchors.leftMargin: UI.PADDING_NORMAL
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: visitUsLink

                    text: PersistanceManager.getString("visitUsLink", "AboutView", "filtermusic.net")
                    font.family: UI.FONT_NAME
                    font.pointSize: UI.TEXT_SIZE_TINY
                    font.capitalization: Font.AllUppercase
                    color: UI.PRIMARY_TEXT_COLOR
                    anchors.right: parent.right
                    anchors.rightMargin: UI.PADDING_NORMAL
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    id: visitUsMouseArea

                    anchors.fill: parent

                    onClicked: {
                        Qt.openUrlExternally( PersistanceManager.getString("visitUsLinkUrl", "AboutView", "https://filtermusic.net") )
                    }
                }
            }

            Item {
                id: contact

                Layout.fillWidth: true
                height: contactText.height

                Text {
                    id: contactText

                    text: PersistanceManager.getString("contactText", "AboutView", "Contact:")
                    font.family: UI.FONT_NAME
                    font.pointSize: UI.TEXT_SIZE_SMALL
                    font.capitalization: Font.SmallCaps
                    color: UI.PRIMARY_TEXT_COLOR
                    anchors.left: parent.left
                    anchors.leftMargin: UI.PADDING_NORMAL
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: contactLink

                    text: PersistanceManager.getString("contactLink", "AboutView", "info@filtermusic.net")
                    font.family: UI.FONT_NAME
                    font.pointSize: UI.TEXT_SIZE_TINY
                    font.capitalization: Font.AllUppercase
                    color: UI.PRIMARY_TEXT_COLOR
                    anchors.right: parent.right
                    anchors.rightMargin: UI.PADDING_NORMAL
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    id: contactMouseArea

                    anchors.fill: parent

                    onClicked: {
                        Qt.openUrlExternally( PersistanceManager.getString("contactLinkUrl", "AboutView", "mailto:?to=info@filtermusic.net&subject=Feedback to filtermusic app") )
                    }
                }
            }

            Item {
                height: UI.PADDING_LARGE
            }

            Text {
                id: aboutText

                text: PersistanceManager.getString("aboutText", "AboutView", "Filtermusic is updated with radio stations that stream in high quality (128Kbps and higher) and play only music; you won't find a radio here where people having lenghty discussions. All streams presented have been filtered especially for electronic & dance music from thousands of stations all over the Internet.")
                font.family: UI.FONT_NAME
                font.pointSize: UI.TEXT_SIZE_TINY
                font.capitalization: Font.AllUppercase
                color: UI.PRIMARY_TEXT_COLOR
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.margins: UI.PADDING_NORMAL
            }

            Item {
                id: licensesHeader

                Layout.fillWidth: true
                height: licensesHeaderText.height

                Text {
                    id: licensesHeaderText

                    font.family: UI.FONT_NAME
                    font.pointSize: UI.TEXT_SIZE_BIG
                    font.capitalization: Font.SmallCaps
                    color: UI.PRIMARY_TEXT_COLOR
                    wrapMode: Text.WordWrap
                    anchors.left: parent.left
                    anchors.leftMargin: UI.PADDING_NORMAL
                    anchors.right: parent.right
                    anchors.rightMargin: UI.PADDING_NORMAL
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Licenses:"
                }
            }
        }

        Item {
            id: licenses

            anchors.left: parent.left
            anchors.top: mainLayout.bottom

            height: licensesText.height + UI.PADDING_NORMAL
            width: parentWidth - 2 * UI.PADDING_NORMAL

            Text {
                id: licensesText

                font.family: UI.FONT_NAME
                font.pointSize: UI.TEXT_SIZE_SMALL
                font.capitalization: Font.SmallCaps
                color: UI.PRIMARY_TEXT_COLOR
                wrapMode: Text.WordWrap
                anchors.left: parent.left
                anchors.leftMargin: UI.PADDING_NORMAL
                anchors.right: parent.right
                anchors.rightMargin: UI.PADDING_NORMAL
                anchors.bottom: parent.bottom
                text: License.licenseText
            }
        }
    }
}
