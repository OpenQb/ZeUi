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
    property alias dockItemModel: objGridView.model
    property alias dockItemDelegate: objGridView.delegate


    function emitSelection(index,x,y){
        var obj = objGridView.model.get(index);
        objBaseSideDockRoot.selectedItem(obj.title,index,x,y);
    }

    Keys.forwardTo: [objGridView]
    Keys.onPressed: {
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
            event.accepted = true;
            if(objGridView.currentIndex !==-1){
                emitSelection(objGridView.currentIndex,objGridView.selectedX,objGridView.selectedY);
            }
        }
//        else if(event.key === Qt.Key_Space){
//        }
//        else if(event.key === Qt.Key_Escape||event.key === Qt.Key_Back){
//        }
    }

    Rectangle{
        anchors.fill: parent
        color: ZBTheme.dockBackgroundColor
        GridView{
            id: objGridView
            anchors.fill: parent
            cellHeight: objBaseSideDockRoot.dockItemHeight
            cellWidth: objBaseSideDockRoot.dockItemWidth

            property int selectedX: 0
            property int selectedY: 0

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

                Rectangle{
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 3
                    color: ZBTheme.ribbonColor
                    visible: true
                    opacity: objGridView.currentIndex===index?1:0
                    Behavior on opacity{
                        enabled: ZBTheme.useAnimation
                        NumberAnimation{
                            duration: 500
                        }
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    preventStealing: true
                    onClicked: {
                        objGridView.currentIndex = index;
                        var gco = objDockItemDelegate.mapToItem(objBaseSideDockRoot, 0, 0);
                        objBaseSideDockRoot.emitSelection(index,gco.x,gco.y);
                    }
                    onPressAndHold: {
                        objGridView.currentIndex = index;
                    }
                    onPressed: {
                        objGridView.currentIndex = index;
                    }
                    onReleased: {
                        objGridView.currentIndex = index;
                    }
                }

                Connections {
                      target: objGridView
                      onCurrentIndexChanged: {
                          if(objGridView.currentIndex === index){
                              var gco = objDockItemDelegate.mapToItem(objBaseSideDockRoot, 0, 0);
                              objGridView.selectedX = gco.x;
                              objGridView.selectedY = gco.y;
                          }
                      }
                  }
            }
        }
    }
}
