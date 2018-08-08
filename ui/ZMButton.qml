import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "./../base/"

Button{
    id: objMButton
    Material.accent: ZBTheme.accent
    Material.background: ZBTheme.background
    Material.foreground: ZBTheme.foreground
    Material.primary: ZBTheme.primary

    Rectangle{
        visible: objMButton.activeFocus
        anchors.fill: parent
        focus: false
        color: "transparent"
        border.width: 1
        border.color: ZBTheme.ribbonColor
    }
}
