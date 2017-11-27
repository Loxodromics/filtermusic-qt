import QtQuick 2.7
import "qrc:/sources/javascript/UiConstants.js" as UI

Item {

    NoRecentView {
        id: noRecentView

        anchors.fill: parent
        visible: (recentStationModel.size === 0)

    }

    StationsListView {
        id: stationsListView
        stationModel: recentStationModel
        anchors.fill: parent
        visible: (recentStationModel.size > 0)
    }

}
