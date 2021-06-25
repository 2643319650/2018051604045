import Felgo 3.0
import QtQuick 2.0
import "entities"

Scene {
    id: balloonScene
    // provide the pop sound public for the balloons
    property alias popSound: popSound
    // number of balloons currently on the scene
    property int balloons: 0
    // maximum number of balloons
    property int balloonsMax : 20000
    // duration of the game in seconds
    property int time : 20

    // score
    property int score: 0
    // 判定游戏是否结束
    property bool gameRunning: false
    property bool timeRunning: false

    // position the scene on the top edge
    sceneAlignmentY: "top"

    // 在游戏开始时产生气球
    EntityManager {
        id: entityManager
        entityContainer: balloonScene
    }

    // 利用低重力让气球轻轻地浮起来
    PhysicsWorld { gravity.y: -1; debugDrawVisible: false }

    // 背景图片
    Image {source:"../assets/img/clouds.png"; anchors.fill:gameWindowAnchorItem}

    // 背景音乐
    BackgroundMusic {source:"../assets/snd/music.mp3"}

    // 点中气球消失的音效
    // make it available to them with the id popSound
    SoundEffect {id:popSound; source:"../assets/snd/balloonPop.wav"}

    // left wall
    Wall {height:gameWindowAnchorItem.height+50; anchors.right:gameWindowAnchorItem.left}
    // right wall
    Wall {height:gameWindowAnchorItem.height+50; anchors.left:gameWindowAnchorItem.right}
    // ceiling
    //    Wall {width:gameWindowAnchorItem.width; anchors { bottom:gameWindowAnchorItem.top; left: gameWindowAnchorItem.left} }


    Text {
        id: scoreText
        text:"score: "+score
        anchors.left: balloonScene.gameWindowAnchorItem.left
        anchors.leftMargin: 10
        anchors.top:balloonScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: 20
    }
    Text {
        id: score1Text
        text:"red:1 purple:2 orange:5"
        anchors.right: balloonScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top:balloonScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: 10
    }


    Row {
        // position the HUD at the bottom of the game window
        anchors.left: balloonScene.gameWindowAnchorItem.left
        anchors.leftMargin: 250
        anchors.top:balloonScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        // make sure the HUD is always on top
        z: 2

        // display remaining time
        Text {id:timeText; height:40; font.pixelSize: 20 ;text:"Time: "+balloonScene.time}
    }

    // 开始游戏
    function start() {
        spawnBaloons.start()
        gameRunning = true

    }

    // clear all baloons and reset properties to start values
    function reset() {
        entityManager.removeEntitiesByFilter(["balloon"])
        score=0
        balloons = 0
        time = 20
        show.opacity = 0

    }

    // create balloons with short intervals in between, creating a nice animation at the start
    Timer {
        id: spawnBaloons
        interval: 100 // milliseconds
        repeat: true
        onTriggered: {
            // 每100ms产生一个气球
            entityManager.createEntityFromUrl(Qt.resolvedUrl("entities/Balloon.qml"));
            // gameRunning = true
            balloons++
        }
    }

    // game timer, default interval of Timer is 1 second
    Timer {
        id: gameTimer
        running: gameRunning
        repeat: true
        onTriggered: {
            if(time == 0) {
                gameRunning = false
                show.opacity = 1
                timeRunning = true
                restartAfterDelay.start()
            }else{
                time--
            }
        }
    }

    Column{
        id:show
        anchors.centerIn: parent
        width: 150
        height: 150
        spacing: 2
        z:10000
        opacity: 0

        Rectangle{
            id:form
            color: "black"
            anchors.fill: parent
            radius: 10
            opacity: 0.5

        }

        Text {
            id: finsh
            font.pointSize: 10
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -40
            color: "white"
            opacity: 1
            text: qsTr("Game Over!")
        }

        Text {
            id: gotScore
            font.pointSize: 5
            anchors.centerIn: parent
            color: "white"
            opacity: 1
            font.pixelSize: 15
            text: qsTr("You get " + score + " scores")
        }

        AppButton{
            id:startAgain
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 30
            radius: 5
            text: qsTr("Start Again")
            onClicked:
            {
                timeRunning = false
                balloonScene.reset()
                balloonScene.start()
            }
        }
    }

}
