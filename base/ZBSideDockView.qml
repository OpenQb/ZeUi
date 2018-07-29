import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10

import "."

Item {
    id: objBaseSideDockRoot
    clip: false
    focus: true

    signal selectedItem(string title,int index,int x,int y);

    property int dockItemHeight: ZBTheme.dockItemHeight
    property int dockItemWidth: ZBTheme.dockItemWidth
    property int dockItemExpandedWidth: ZBTheme.dockItemExpandedWidth
    property int dockViewMode: ZBTheme.dockViewMode
    property alias dockItemModel: objGridView.model
    property alias dockItemDelegate: objGridView.delegate

    width:objBaseSideDockRoot.dockViewMode === ZBTheme.zMultiColumn?objBaseSideDockRoot.dockItemWidth+objBaseSideDockRoot.dockItemExpandedWidth:objBaseSideDockRoot.dockItemWidth


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
        else if(event.key === Qt.Key_Escape||event.key === Qt.Key_Back){
            event.accepted = true;
            objGridView.currentIndex = -1;
        }
    }

    Keys.onReleased: {
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
            event.accepted = true;
        }
        else if(event.key === Qt.Key_Escape||event.key === Qt.Key_Back){
            event.accepted = true;
        }
    }

    Rectangle{
        anchors.fill: parent
        color: ZBTheme.dockBackgroundColor
        GridView{
            id: objGridView
            anchors.fill: parent
            cellHeight: objBaseSideDockRoot.dockItemHeight
            cellWidth: parent.width
            currentIndex: -1

            property int selectedX: 0
            property int selectedY: 0

            delegate: Item{
                id: objDockItemDelegate
                clip: false

                width: objGridView.width
                height: objBaseSideDockRoot.dockItemHeight

                Rectangle{
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    width: objBaseSideDockRoot.dockViewMode === ZBTheme.zSingleColumnExpand?objGridView.currentIndex===index?objBaseSideDockRoot.dockItemWidth+objBaseSideDockRoot.dockItemExpandedWidth:parent.width:parent.width

                    color: objGridView.currentIndex===index?ZBTheme.dockItemSelectedBackgroundColor:ZBTheme.dockItemBackgroundColor

                    Item{
                        id: objIconPlaceHolder
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: objBaseSideDockRoot.dockItemWidth
                        Text{
                            anchors.fill: parent
                            color: objGridView.currentIndex===index?ZBTheme.dockItemSelectedColor:ZBTheme.dockItemColor
                            text: QbCoreOne.icon_font_text_code(icon)
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.family: QbCoreOne.icon_font_name(icon)
                            font.bold: objGridView.currentIndex===index?ZBTheme.dockItemSelectedIconFontBold:ZBTheme.dockItemIconFontBold
                            font.pixelSize: objDockItemDelegate.height*0.60
                            visible: QbCoreOne.icon_font_is_text(icon)
                        }
                        Image{
                            anchors.fill: parent
                            anchors.centerIn: parent
                            width: objBaseSideDockRoot.dockItemWidth
                            height: objBaseSideDockRoot.dockItemHeight
                            visible: QbCoreOne.icon_font_is_image(icon)
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            mipmap: true
                            smooth: true
                            sourceSize.width: width*2
                            sourceSize.height: height*2
                            source: visible?icon:""
                        }
                    }

                    Item{
                        id: objTextPlaceHolder
                        anchors.left: objIconPlaceHolder.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: objBaseSideDockRoot.dockItemExpandedWidth
                        Text{
                            anchors.fill: parent
                            color: objGridView.currentIndex===index?ZBTheme.dockItemSelectedColor:ZBTheme.dockItemColor
                            text: title
                            font.family: objGridView.currentIndex===index?ZBTheme.dockItemSelectedFont:ZBTheme.dockItemFont
                            font.bold: objGridView.currentIndex===index?ZBTheme.dockItemSelectedFontBold:ZBTheme.dockItemFontBold
                            font.pixelSize: objGridView.currentIndex===index?ZBTheme.dockItemSelectedFontSize:ZBTheme.dockItemFontSize
                            verticalAlignment: Text.AlignVCenter
                            visible: objBaseSideDockRoot.dockViewMode === ZBTheme.zMultiColumn||objBaseSideDockRoot.dockViewMode === ZBTheme.zSingleColumnExpand
                            elide: Text.ElideRight
                        }
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
}
