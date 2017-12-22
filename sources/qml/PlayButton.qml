import QtQuick 2.7
import Lfd 0.1

Image {
    id: root

    property string playIconSource: "qrc:/resources/icons/button_play.png"
    property string pauseIconSource: "qrc:/resources/icons/button_pause.png"
    property string highlightIconSource: "qrc:/resources/icons/button_play_highlight.png"

    signal clicked

    fillMode: Image.PreserveAspectFit
    source: playIconSource

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: {
            root.clicked()

            console.log("state: " + state)

//            if (state === "" ) {
//                state = "playing"
//            }
//            else if (state === "playing" ) {
//                state = ""
//            }

            AudioPlayer.playing ? AudioPlayer.pause() : AudioPlayer.play()
        }
    }

    Connections {
        target: AudioPlayer

        onPlayingStateChanged: {
            console.log("onPlayingStateChanged: " + playingState)

            if (playingState === LfdAudioPlayer.Playing) {
                root.source = pauseIconSource
                pulseAnimation.stop()
            }
            else if ( (playingState === LfdAudioPlayer.Paused) ||
                      (playingState === LfdAudioPlayer.NotConnected) ||
                      (playingState === LfdAudioPlayer.FailedPlaying)) {
                root.source = playIconSource
                pulseAnimation.stop()
            }
            else if ( (playingState === LfdAudioPlayer.Connecting) ||
                        (playingState === LfdAudioPlayer.Connecting) ) {
                root.source = playIconSource
                pulseAnimation.restart()
            }
        }
    }

    SequentialAnimation {
        id: pulseAnimation
        running: false
        alwaysRunToEnd: true
        loops: Animation.Infinite

        PropertyAnimation {
            target: root
            properties: "opacity"
            from: 1.0
            to: 0.0
            duration: 250
            easing.type: Easing.OutQuad
        }

        PropertyAnimation {
            target: root
            properties: "opacity"
            from: 0.0
            to: 1.0
            duration: 250
            easing.type: Easing.OutQuad
        }
    }

    states: [
        State {
            name: ""
            PropertyChanges {
                target: root
                source: playIconSource
            }
        },
        State {
            name: "playing"
            PropertyChanges {
                target: root
                source: root.pauseIconSource
            }

            PropertyChanges {
                target: root
                visible: false
            }
        }/* TODO,
        State {
            name: "connecting"
            PropertyChanges {
                target: root
                source: highlightIconSource
            }
        }*/
    ]
}
