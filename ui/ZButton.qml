import Qb.Core 1.0
import QtQuick 2.11

Item {
    id: objButton
    property color textColor: "white"
    property color backgroundColor: "black"
    property color borderColor: "white"

    property int radious: 5
    property int border: 0
    property string text: "Button"
    property string fontFamily: "Ubuntu"
    property int fontPixelSize: 15
    property bool fontBold: false
    activeFocusOnTab: true
    width: 100
    height: 50

    signal buttonPressed();

    property bool isHovered: false

    Keys.onPressed: {
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
            event.accept = true;
            objButton.buttonPressed();
        }
    }

    Keys.onReleased: {
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Escape){
            event.accept = true;
        }
    }

    Rectangle{
        anchors.fill: parent
        color: objButton.isHovered?QbCoreOne.lighter(objButton.backgroundColor,180):objButton.activeFocus?QbCoreOne.lighter(objButton.backgroundColor,180):objButton.backgroundColor

        radius: objButton.radious
        border.color: objButton.borderColor
        border.width: objButton.border

        Text {
            text: objButton.text
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: objButton.fontFamily
            font.pixelSize: objButton.fontPixelSize
            font.bold: objButton.fontBold
            color: objButton.textColor
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                objButton.buttonPressed()
            }
            onEntered: {
                //console.log("onEntered on button")
                objButton.isHovered = true;
            }
            onExited: {
                //console.log("onExited from button")
                objButton.isHovered = false;
            }
        }
    }
}
