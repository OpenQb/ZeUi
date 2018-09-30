import Qb.Core 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.4

import "./../base/"

Item{
    id: objMButtonRoot
    width: 50
    height: 50
    property alias text: objMButton.text
    property alias font: objMButton.font
    signal clicked();
    signal pressed();
    signal pressAndHold();

    RectangularGlow {
        anchors.fill: objMButton
        anchors.centerIn: objMButton
        anchors.verticalCenterOffset: 0
        glowRadius: objMButton.activeFocus?1:2
        opacity: objMButton.activeFocus?1:0.1
        spread: objMButton.activeFocus?0.5:0.1
        color: objMButton.activeFocus?ZBTheme.accent:"black"
        cornerRadius: height/2
    }

    RoundButton{
        id: objMButton
        Material.accent: ZBTheme.accent
        Material.background: ZBTheme.primary
        Material.foreground: QbCoreOne.isBright(Material.background)?"black":"white"
        Material.primary: ZBTheme.primary
        Material.theme: Material.Light
        anchors.fill: parent
        anchors.centerIn: parent
        onClicked: {
            objMButtonRoot.clicked();
        }
        onPressed: {
            objMButtonRoot.pressed();
        }
        onPressAndHold: {
            objMButtonRoot.pressAndHold();
        }
    }
}
