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
            console.log("ccc_== accept")
            close.accepted = true;
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

//            focus: true
//            Keys.onReleased: {
//                if (event.key === Qt.Key_Back) {
//                    console.log("Android back")
//                    if ( !stackView.busy &&
//                         (stackView.currentItem !== stackView.initialItem) ) {
//                        stackView.pop()
//                        event.accepted = true
//                    }
//        //            event.accepted = true
//                    //do some action here like close or pop the stack view
//                }
//            }

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
//            gradient: Gradient {
//                GradientStop {
//                    position: 0.00;
//                    color: "#FF000000";
//                }
//                GradientStop {
//                    position: 1.00;
//                    color: "#00000000";
//                }
//            }

            color: UI.TABLE_BACKGROUND_COLOR

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
            text: qsTr("Categories")
            onClicked: {
                if ( !stackView.busy &&
                     (stackView.currentItem !== stackView.initialItem) ) {
                    stackView.pop()
                }
            }
        }
        LfdTabButton {
            text: qsTr("Favorites")
        }
        LfdTabButton {
            text: qsTr("Recent")
        }
        LfdTabButton {
            text: qsTr("About")
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

    background: Rectangle {

        color: UI.TABLE_BACKGROUND_COLOR
//        gradient: Gradient {
//            GradientStop {
//                position: 0.00;
//                color: "#ff00ff";
//            }
//            GradientStop {
//                position: 1.00;
//                color: "#ffff00";
//            }
//        }

    }
}
