import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10

import "."

Item {
    id: objBaseSideDockRoot
    clip: false
    focus: true

    signal selectedItem(string title,int index,int x,int y);

    property int dockItemHeight: 50
    property int dockItemWidth: 50
    property alias dockItemDelegate: objGridView.delegate

    function emitSelection(index,x,y){
        var obj = objGridView.model.get(index);
        objBaseSideDockRoot.selectedItem(obj.title,index,x,y);
    }

    Keys.forwardTo: [objGridView]

    Rectangle{
        anchors.fill: parent
        color: ZBTheme.dockBackgroundColor
        GridView{
            id: objGridView
            anchors.fill: parent
            cellHeight: objBaseSideDockRoot.dockItemHeight
            cellWidth: objBaseSideDockRoot.dockItemWidth

            delegate: Item{
                id: objDockItemDelegate
                property bool showToolTip: false
                width: objBaseSideDockRoot.dockItemWidth
                height: objBaseSideDockRoot.dockItemHeight

                Text{
                    anchors.fill: parent
                    color: "white"
                    text: QbCoreOne.icon_font_text_code(icon)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: QbCoreOne.icon_font_name(icon)
                    font.bold: false
                    font.pixelSize: objDockItemDelegate.height*0.60
                    visible: QbCoreOne.icon_font_is_text(icon)
                }

                Image{
                    width: parent.width*0.70
                    height: parent.height*0.70
                    anchors.centerIn: parent
                    visible: QbCoreOne.icon_font_is_image(icon)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    mipmap: true
                    smooth: true
                    sourceSize.width: parent.width*2
                    sourceSize.height: parent.height*2
                    source: visible?icon:""
                }

                MouseArea{
                    anchors.fill: parent
                    preventStealing: true
                    onClicked: {
                        var gco = objDockItemDelegate.mapToItem(objBaseSideDockRoot, 0, 0);
                        objBaseSideDockRoot.emitSelection(index,gco.x,gco.y);
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                    }
                }
            }
        }
    }
}
