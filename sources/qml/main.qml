import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "qrc:/sources/javascript/UiConstants.js" as UI

ApplicationWindow {
    id: root
    visible: true
    width: 380
    height: 640
    title: qsTr("filtermusic")

    property bool showDeactivatedView: true

    onClosing: {
        /// handle the Android back button
        if ( isAndroid ) {
            if ( player.isMaximized() ) {
                player.minimize()
                close.accepted = false;
            }
            else if (aboutView.licensesViewShowing) {
                aboutView.hideLicenses()
                close.accepted = false;
            }
            else if (tabBar.currentIndex !== 0) {
                tabBar.currentIndex = 0
                close.accepted = false;
            }
            else if ( stackView.depth > 1 ) {
                stackView.pop()
                RadioStationManager.setCurrentCategory(0)
                close.accepted = false;
            }
            else {
                close.accepted = true;
            }
        }
    }

//    FontLoader { id: nunitoLight_; source: "qrc:/resources/fonts/Nunito-Light.ttf" }
//    FontLoader { id: helveticaNormal; source: "qrc:/resources/fonts/Helvetica-Normal.ttf" }
    FontLoader { id: helr45w; source: "qrc:/resources/fonts/HELR45W.ttf"; name: "helr45w"}

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        background: Item {} /// clear background, but why?!

        Page {
            id: categoriesListPage
            background: Item {} /// clear background

            StackView {
                id: stackView

                initialItem: categoriesListView
                anchors.fill: parent

                Component {
                    id: categoriesListView

                    CategoriesListView {}
                }

                Component {
                    id: stationsListView

                    StationsListView {
                        stationModel: radioStationModel
                        showCategory: true
                    }
                }
            }

            Component.onCompleted: {
                GTracker.sendScreenView("CategoriesListPage")
//                console.log("CategoriesListPage")
            }
        }

        Page {
            background: Item {} /// clear background
            FavoritesView {
                id: favoritesView
                anchors.fill: parent
            }
        }

        Page {
            background: Item {} /// clear background
            RecentView {
                id: recentView
                anchors.fill: parent
            }
        }

        Page {
            background: Item {} /// clear background
            AboutView {
                id: aboutView
                anchors.fill: parent
                parentWidth: root.width
            }
        }

        onCurrentIndexChanged: {
//            console.log("swipe view index: " + currentIndex)
            if (currentIndex === 0) {
                GTracker.sendScreenView("CategoriesListPage")
//                console.log("CategoriesListPage")
            }
            else if (currentIndex === 1) {
                GTracker.sendScreenView("FavoritesView")
//                console.log("FavoritesView")
            }
            else if (currentIndex === 2) {
                GTracker.sendScreenView("RecentView")
//                console.log("RecentView")
            }
            else if (currentIndex === 3) {
                GTracker.sendScreenView("AboutView")
//                console.log("AboutView")
            }

        }
    }

    PlayerView {
        id: player
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        parent: root.overlay

        visible: !PersistanceManager.isDeactivated
    }

    DeactivatedView {
        id: deactivatedView

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        parent: root.overlay
    }

    header: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        background: Rectangle {
            color: UI.BACKGROUND_COLOR_ALTERNATIVE
        }

        onCurrentIndexChanged: {
            player.minimize()
        }

        LfdTabButton {
            id: categoriesButton
            text: PersistanceManager.getString("categoriesButton", "main", "Categories")
            font.family: UI.FONT_NAME
            font.pointSize: UI.TEXT_SIZE_NORMAL
            font.capitalization: Font.AllUppercase
            onClicked: {
                if ( !stackView.busy &&
                        (stackView.currentItem !== stackView.initialItem) ) {
                    stackView.pop()
                    RadioStationManager.setCurrentCategory(0)
                }
            }
        }

        LfdTabButton {
            id: favoritesButton
            text: PersistanceManager.getString("favoritesButton", "main", "Favorites")
            font.family: UI.FONT_NAME
            font.pointSize: UI.TEXT_SIZE_NORMAL
            font.capitalization: Font.AllUppercase
        }

        LfdTabButton {
            id: recentButton
            text: PersistanceManager.getString("recentButton", "main", "Recent" )
            font.family: UI.FONT_NAME
            font.pointSize: UI.TEXT_SIZE_NORMAL
            font.capitalization: Font.AllUppercase
        }

        LfdTabButton {
            id: aboutButton
            text: PersistanceManager.getString("aboutButton", "main", "About" )
            font.family: UI.FONT_NAME
            font.pointSize: UI.TEXT_SIZE_NORMAL
            font.capitalization: Font.AllUppercase
        }
    }

    footer: Rectangle {

        height: UI.UNIT_HEIGHT

        color: UI.BACKGROUND_COLOR_ALTERNATIVE

        MiniPlayerView {
            id: miniPlayer

            anchors.fill: parent

            onMaximize: {
                player.maximize()
            }
        }
    }

    background: Rectangle {
        id: backgroundColor

        color: UI.BACKGROUND_COLOR
    }

}
