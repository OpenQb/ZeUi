import Qb 1.0
import QtQuick 2.11

Item {
    id: objSpinner
    width: 25
    height: 50
    property color spinnerColor: "black"
    property bool showSpinner: true
    property int spinnerSize: 18
    Text{
        anchors.fill: parent
        text: QbFA.icon("fa-spinner")
        color: objSpinner.spinnerColor
        font.pixelSize: objSpinner.spinnerSize
        font.family: QbFA.family
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        visible: objSpinner.showSpinner
        RotationAnimation on rotation {
            loops: Animation.Infinite
            from: 0
            to: 360
            direction: RotationAnimation.Clockwise
            duration: 1000
        }
    }
}
