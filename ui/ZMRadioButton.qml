import Qb.Core 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "./../base/"

RadioButton{
    id: objMButton
    Material.accent: ZBTheme.accent
    Material.background: "transparent"
    Material.foreground: ZBTheme.accent
    Material.primary: ZBTheme.primary
    Material.theme: Material.Light

    Rectangle{
        visible: objMButton.activeFocus
        width: parent.width
        height: ZBTheme.ribbonHeight
        anchors.bottom: objMButton.bottom
        focus: false
        color: ZBTheme.ribbonColor
    }
}
