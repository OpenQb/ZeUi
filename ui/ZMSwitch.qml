import Qb.Core 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "./../base/"

Switch{
    id: objMSwitch
    Material.accent: ZBTheme.accent
    Material.background: "transparent"
    Material.foreground: ZBTheme.accent
    Material.primary: ZBTheme.primary
    Material.theme: Material.Light

    Rectangle{
        visible: objMSwitch.activeFocus
        width: parent.width
        height: ZBTheme.ribbonHeight
        anchors.bottom: objMSwitch.bottom
        focus: false
        color: ZBTheme.ribbonColor
    }
}
