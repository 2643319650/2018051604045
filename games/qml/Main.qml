import Felgo 3.0
import QtQuick 2.0

GameWindow {
    id: gameWindow

    onSplashScreenFinished: { ballonScene.start() }

    // our scene that contains the game
    BalloonScene {
        id: ballonScene
    }
}
