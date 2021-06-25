import QtQuick 2.0
import Felgo 3.0

EntityBase {
    entityType: "balloon"
    width: sprite.width
    height: sprite.height

    property int color: 0
    property int xforce: 0

    MultiResolutionImage {
        id: sprite
    }

    CircleCollider {
        id: collider
        radius: sprite.width/2
        // restitution is bounciness, balloons are quite bouncy
        fixture.restitution: 0.5
    }

    MouseArea {
        anchors.fill: sprite
        onPressed: {
            // 如果你触摸一个气球并且游戏正在运行，它就会爆炸
            if(balloonScene.gameRunning) {
                balloonScene.balloons--
                if( color == 1)		//red
                    score++
                else if(color == 2)	//purple
                    score += 2
                else
                    score += 5		//orange
                popSound.play()
                removeEntity()
            }
        }
    }

    // 在创建时赋予气球一个随机的位置
    Component.onCompleted: {
        x = utils.generateRandomValueBetween(0,balloonScene.width-sprite.width)
        y = balloonScene.height
        create_ball()
    }

    function create_ball(){
        color =  utils.generateRandomValueBetween(1,4);
        xforce = utils.generateRandomValueBetween(-40,40);
        if(color == 1){
            sprite.source = "../../assets/img/balloon.png"; //red
            collider.force = Qt.point(xforce,-1)
        }else if(color == 2){
            sprite.source = "../../assets/img/balloon1.png"; //purple
            collider.force = Qt.point(xforce,-30)
        }
        else{
            sprite.source ="../../assets/img/balloon2.png"; //orange
            collider.force = Qt.point(xforce,-80)
        }
    }
}
