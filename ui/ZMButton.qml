import Qb.Core 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "./../base/"

Button{
    id: objMButton
    Material.accent: ZBTheme.accent
    Material.background: ZBTheme.background
    Material.foreground: QbCoreOne.isBright(Material.background)?"black":"white"
    Material.primary: ZBTheme.primary
    Material.theme: Material.Light

    Rectangle{
        visible: objMButton.activeFocus
        anchors.fill: parent
        focus: false
        color: "transparent"
        border.width: 1
        border.color: ZBTheme.ribbonColor
        radius: 5
    }
}
