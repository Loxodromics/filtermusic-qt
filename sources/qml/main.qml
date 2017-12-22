import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/sources/javascript/UiConstants.js" as UI

ApplicationWindow {
    id: root
    visible: true
    width: 480
    height: 640
    title: qsTr("filtermusic")

    onClosing: {
        /// handle the Android back button
        if ( isAndroid ) {
            if ( player.isMaximized() ) {
                player.minimize()
                close.accepted = false;
            }
            else if (tabBar.currentIndex !== 0) {
                tabBar.currentIndex = 0
                close.accepted = false;
            }
            else if ( stackView.depth > 1 ) {
                stackView.pop()
                close.accepted = false;
            }
            else {
                close.accepted = true;
            }
        }
    }

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
                    }
                }
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
    }

    header: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        background: Rectangle {
            gradient: Gradient {
                GradientStop {
                    position: 0.50;
                    color: UI.HEADER_DARK_BLUE
                }
                GradientStop {
                    position: 1.00;
                    color: "#00000000";
                }
            }

            FastBlur {
                id: fastBlur

                anchors.fill: parent
                radius: 32
//                samples: 16
//                opacity: 0.55

                source: ShaderEffectSource {
                    sourceItem: swipeView
                    sourceRect: Qt.rect(0, -fastBlur.height, fastBlur.width, fastBlur.height)
                }
            }
        }

        LfdTabButton {
            id: categoriesButton
            text: PersistanceManager.getString("categoriesButton", "main", "Categories")
            onClicked: {
                if ( !stackView.busy &&
                     (stackView.currentItem !== stackView.initialItem) ) {
                    stackView.pop()
                }
            }
        }
        LfdTabButton {
            id: favoritesButton
            text: PersistanceManager.getString("favoritesButton", "main", "Favorites")
        }
        LfdTabButton {
            id: recentButton
            text: PersistanceManager.getString("recentButton", "main", "Recent" );
        }
        LfdTabButton {
            id: aboutButton
            text: PersistanceManager.getString("aboutButton", "main", "About" );
        }
    }

    footer:
        Rectangle {

        height: 40

        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#00000000";
            }
            GradientStop {
                position: 1.00;
                color: "#FF000000";
            }
        }

        MiniPlayerView {
            id: miniPlayer

            anchors.fill: parent

            onMaximize: {
                player.maximize()
            }

        }
    }

    background: Image {
        id: backgroundImage
        source: "qrc:/resources/images/background.jpg"

        Rectangle {
            id: backgroundImageOverlay

            color: "black"
            opacity: 0.2

            anchors.fill: parent
        }
    }

}
