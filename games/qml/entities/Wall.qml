import QtQuick 2.0
import Felgo 3.0

EntityBase {
    entityType: "wall"
    // default width and height
    width: 1
    height: 1

    // 只有碰撞器，因为我们想要墙是隐形的
    BoxCollider {
        anchors.fill: parent
        bodyType: Body.Static // the body shouldn't move
    }
}
