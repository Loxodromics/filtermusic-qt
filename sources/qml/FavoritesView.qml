import QtQuick 2.7
import "qrc:/sources/javascript/UiConstants.js" as UI

Item {

    NoFavoritesView {
        id: noFavoritesView

        anchors.fill: parent
        visible: (favoritesStationModel.size === 0)
    }

    StationsListView {
        id: stationsListView
        stationModel: favoritesStationModel
        anchors.fill: parent
        visible: (favoritesStationModel.size > 0)
    }
}
