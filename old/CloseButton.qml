import QtQuick 2.10

import Qb 1.0
import Qb.Core 1.0

Rectangle{
    id: objButton
    signal clicked();
    property color hoverBackgroundColor;
    property color hoverTextColor;
    property color textColor;
    property color oldColor;
    property color oldTextColor;

    Text{
        anchors.fill: parent
        anchors.centerIn: parent
        text: QbMF3.icon("mf-close")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: QbMF3.family
        color: textColor;
        font.pixelSize: width*0.40
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
        onClicked: {
            objButton.clicked();
        }

        onEntered:{
            objButton.oldColor = objButton.color;
            objButton.color = objButton.hoverBackgroundColor;

            objButton.oldTextColor = objButton.textColor;
            objButton.textColor = objButton.hoverTextColor;
        }

        onExited: {
            objButton.color = objButton.oldColor;
            objButton.textColor = objButton.oldTextColor;
        }
    }
}
