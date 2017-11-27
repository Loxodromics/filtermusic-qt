import QtQuick 2.0

Image {
    id: root

    property alias iconSource: root.source

    signal clicked

    fillMode: Image.PreserveAspectFit

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: {
            root.clicked()
        }
    }
}
