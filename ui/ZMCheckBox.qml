import Qb.Core 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "./../base/"

CheckBox{
    id: objMCheckBox
    Material.accent: ZBTheme.accent
    Material.background: ZBTheme.primary
    Material.foreground: QbCoreOne.isBright(Material.background)?"black":"white"
    Material.primary: ZBTheme.primary
    Material.theme: Material.Light

    Rectangle{
        visible: objMCheckBox.activeFocus
        width: parent.width
        height: ZBTheme.ribbonHeight
        anchors.bottom: objMCheckBox.bottom
        focus: false
        color: ZBTheme.ribbonColor
    }
}
