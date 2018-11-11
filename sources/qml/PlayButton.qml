import QtQuick 2.7
import Lfd 0.1

Item {
    id: root

    property string playIconSource: "qrc:/resources/icons/button_play.png"
    property string pauseIconSource: "qrc:/resources/icons/button_pause.png"
    property string highlightIconSource: "qrc:/resources/icons/button_play_highlight.png"

    signal clicked

    width: height

    Image {
        id: playImage

        fillMode: Image.PreserveAspectFit
        source: playIconSource
        anchors.fill: parent
        visible: !connectingAnimation.running
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: {
            root.clicked()

//            console.log("state: " + state)

//            if (state === "" ) {
//                state = "playing"
//            }
//            else if (state === "playing" ) {
//                state = ""
//            }

            AudioPlayer.playing ? AudioPlayer.pause() : AudioPlayer.play()
        }
    }

    Image {
        id: connectingIndicator
        source: "qrc:/resources/icons/loading.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        visible: connectingAnimation.running
    }

    Connections {
        target: AudioPlayer

        onPlayingStateChanged: {
//            console.log("onPlayingStateChanged: " + playingState)

            if (playingState === LfdAudioPlayer.Playing) {
                playImage.source = pauseIconSource
                connectingAnimation.stop()
                GTracker.sendEvent("Playing", "pause")
            }
            else if ( (playingState === LfdAudioPlayer.Paused) ||
                      (playingState === LfdAudioPlayer.NotConnected) ||
                      (playingState === LfdAudioPlayer.FailedPlaying)) {
                playImage.source = playIconSource
                connectingAnimation.stop()
                GTracker.sendEvent("Playing", "play")
                GTracker.sendEvent("Station", RadioStationManager.stationName)
            }
            else if ( (playingState === LfdAudioPlayer.Connecting) ||
                        (playingState === LfdAudioPlayer.Connecting) ) {
                playImage.source = playIconSource
                connectingAnimation.restart()
            }
        }
    }

    SequentialAnimation {
        id: pulseAnimation
        running: false
        alwaysRunToEnd: true
        loops: Animation.Infinite

        PropertyAnimation {
            target: playImage
            properties: "opacity"
            from: 1.0
            to: 0.0
            duration: 250
            easing.type: Easing.OutQuad
        }

        PropertyAnimation {
            target: playImage
            properties: "opacity"
            from: 0.0
            to: 1.0
            duration: 250
            easing.type: Easing.OutQuad
        }
    }

    RotationAnimator {
        id: connectingAnimation
        target: connectingIndicator
        from: 360
        to: 0
        duration: 600
        running: false
        loops: Animation.Infinite
    }

    states: [
        State {
            name: ""
            PropertyChanges {
                target: playImage
                source: playIconSource
            }
        },
        State {
            name: "playing"
            PropertyChanges {
                target: playImage
                source: playImage.pauseIconSource
            }

            PropertyChanges {
                target: playImage
                visible: false
            }

        }/* TODO,
        State {
            name: "connecting"
            PropertyChanges {
                target: playImage
                source: highlightIconSource
            }
        }*/
    ]
}
