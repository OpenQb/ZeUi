import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "."

ZBItem {
    id: objBaseSideDockRoot
    clip: false

    x: -objBaseSideDockRoot.width
    visible: false
    z: -10000000
    focus: false

    signal selectedItem(string title,int index,int x,int y);
    signal selectedByMouse();

    property bool isOpened: false
    property int dockItemHeight: ZBTheme.dockItemHeight
    property int dockItemWidth: ZBTheme.dockItemWidth
    property int dockItemExpandedWidth: ZBTheme.dockItemExpandedWidth
    property int dockViewMode: ZBTheme.dockViewMode

    property alias dockItemModel: objGridView.model
    property alias dockItemDelegate: objGridView.delegate
    property alias dockInteractive: objGridView.interactive

    property alias dockItemCurrentIndex: objGridView.currentIndex
    property alias dockItemCurrentItem: objGridView.currentItem

    property alias dockItemSelectedX: objGridView.selectedX
    property alias dockItemSelectedY: objGridView.selectedY

    property bool isFocused: false;

    width:objBaseSideDockRoot.dockViewMode === ZBTheme.zMultiColumn?objBaseSideDockRoot.dockItemWidth+objBaseSideDockRoot.dockItemExpandedWidth:objBaseSideDockRoot.dockItemWidth

    Behavior on x{
        enabled: ZBTheme.useAnimation
        NumberAnimation{
            duration: 500
            easing.type: Easing.InOutQuad
            onRunningChanged: {
                if(objBaseSideDockRoot.x !== 0){
                    if(!running){
                        objBaseSideDockRoot.z = -10000000;
                        objBaseSideDockRoot.visible = false;
                    }
                }
            }
        }
    }

    function open(){
        objBaseSideDockRoot.visible = true;
        objBaseSideDockRoot.z = 10000000;
        objBaseSideDockRoot.isOpened = true;
        objBaseSideDockRoot.x = 0
    }

    function close(){
        objBaseSideDockRoot.isOpened = false;
        objBaseSideDockRoot.x = -objBaseSideDockRoot.width;
    }

    function emitSelection(index,x,y){
        var obj = objGridView.model.get(index);
        objBaseSideDockRoot.selectedItem(obj.title,index,x,y);
    }


    function canAcceptEnterKey(){
        if(objGridView.currentIndex>-1 && objGridView.currentIndex<objGridView.count){
            return true;
        }
        else{
            return false;
        }
    }

    function canAcceptUpKey(){
        if(objGridView.count === 0) return false;

        if(objGridView.currentIndex === 0){
            return false;
        }
        else{
            return true;
        }
    }

    function canAcceptDownKey(){
        if(objGridView.count === 0) return false;
        var len;
        try{
            len = objGridView.count;
        }
        catch(e){
            len = objGridView.model.length;
        }
        if(objGridView.currentIndex === len-1){
            return false;
        }
        else{
            return true;
        }
    }

    function clearSelection(){
        objGridView.currentIndex = -1;
    }

    function keysOnPressed(event){
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
            event.accepted = true;
            if(objGridView.currentIndex !==-1){
                emitSelection(objGridView.currentIndex,objGridView.selectedX,objGridView.selectedY);
            }
        }
        else if(event.key === Qt.Key_Escape||event.key === Qt.Key_Back){
            event.accepted = true;
            objGridView.currentIndex = -1;
        }
        else if(event.key === Qt.Key_Up){
            //objBaseSideDockRoot.forceActiveFocus();
            var len;
            try{
                len = objGridView.count;
            }
            catch(e){
                len = objGridView.model.length;
            }
            if(len>0){
                if(objGridView.currentIndex === -1 || objGridView.currentIndex === len){
                    event.accepted = true;
                    objGridView.currentIndex = len-1;
                }
                else if(objGridView.currentIndex>-1){
                    event.accepted = true;
                    objGridView.currentIndex = objGridView.currentIndex - 1;
                }
                else if(objGridView.currentIndex === 0){
                    event.accepted = true;
                    objGridView.currentIndex = -1;
                }
            }

        }
        else if(event.key === Qt.Key_Down){
            //objBaseSideDockRoot.forceActiveFocus();
            var len;
            var cIndex = objGridView.currentIndex;
            try{
                len = objGridView.count;
            }
            catch(e){
                len = objGridView.model.length;
            }

            if(len>0){
                if(cIndex === len){
                    cIndex = 0;
                }
                else if(cIndex === -1){
                    cIndex = 0;
                }
                else if(cIndex <len){
                    cIndex = cIndex + 1;
                }
                if(cIndex === -1 || cIndex === len){
                    event.accepted = true;
                    objGridView.currentIndex = cIndex;
                }
                else{
                    event.accepted = true;
                    objGridView.currentIndex = cIndex;
                }
            }
        }
    }

    function keysOnReleased(event){
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
            event.accepted = true;
        }
        else if(event.key === Qt.Key_Escape||event.key === Qt.Key_Back){
            event.accepted = true;
        }
        else if(event.key === Qt.Key_Up){
            event.accepted = true;
        }
        else if(event.key === Qt.Key_Down){
            event.accepted = true;
        }
    }
    Keys.onPressed: keysOnPressed(event);
    Keys.onReleased: keysOnReleased(event);

    Rectangle{
        anchors.fill: parent
        color: ZBTheme.dockBackgroundColor
        GridView{
            id: objGridView
            anchors.fill: parent
            cellHeight: objBaseSideDockRoot.dockItemHeight
            cellWidth: parent.width
            currentIndex: -1
            ScrollIndicator.vertical: ScrollIndicator {z: 3}

            property int selectedX: 0
            property int selectedY: 0

            delegate: Item{
                id: objDockItemDelegate
                clip: false
                z: 1

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
                            rotation: model.icon_rotation?icon_rotation:0
                        }
                        Image{
                            //anchors.fill: parent
                            width: parent.width*0.90
                            height: parent.height*0.90
                            anchors.centerIn: parent
                            visible: QbCoreOne.icon_font_is_image(icon)
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            mipmap: true
                            smooth: true
                            sourceSize.width: width*2
                            sourceSize.height: height*2
                            source: visible?icon:""
                            rotation: model.icon_rotation?icon_rotation:0
                        }
                    }

                    Item{
                        id: objTextPlaceHolder
                        anchors.left: objIconPlaceHolder.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: objBaseSideDockRoot.dockItemExpandedWidth
                        clip: true
                        Text{
                            anchors.fill: parent
                            color: objGridView.currentIndex===index?ZBTheme.dockItemSelectedColor:ZBTheme.dockItemColor
                            text: title
                            font.family: objGridView.currentIndex===index?ZBTheme.dockItemSelectedFontFamily:ZBTheme.dockItemFontFamily
                            font.bold: objGridView.currentIndex===index?ZBTheme.dockItemSelectedFontBold:ZBTheme.dockItemFontBold
                            font.pixelSize: objGridView.currentIndex===index?ZBTheme.dockItemSelectedFontSize:ZBTheme.dockItemFontSize
                            verticalAlignment: Text.AlignVCenter
                            visible: objBaseSideDockRoot.dockViewMode === ZBTheme.zMultiColumn||objBaseSideDockRoot.dockViewMode === ZBTheme.zSingleColumnExpand
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        preventStealing: true
                        onClicked: {
                            objGridView.currentIndex = index;
                            var gco = objDockItemDelegate.mapToItem(objBaseSideDockRoot, 0, 0);
                            objBaseSideDockRoot.selectedByMouse();
                            objBaseSideDockRoot.emitSelection(index,gco.x,gco.y);
                            objGridView.selectedX = gco.x;
                            objGridView.selectedY = gco.y;
                            //objBaseSideDockRoot.forceActiveFocus();
                            //console.log("X:",gco.x);
                            //console.log("Y:",gco.y);
                        }
                        //                        onPressAndHold: {
                        //                            objGridView.currentIndex = index;
                        //                        }
                        //                        onPressed: {
                        //                            objGridView.currentIndex = index;
                        //                        }
                        //                        onReleased: {
                        //                            objGridView.currentIndex = index;
                        //                        }
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

                    Rectangle{
                        height: 3
                        color: objBaseSideDockRoot.isFocused?ZBTheme.ribbonColor:ZBTheme.ribbonColorNonFocus
                        opacity: objGridView.currentIndex===index?1:0
                        width: objGridView.currentIndex===index?parent.width:0
                        anchors.bottom: parent.bottom
                        Behavior on opacity{
                            enabled: ZBTheme.useAnimation
                            NumberAnimation{
                                duration: 500
                            }
                        }
                        Behavior on width {
                            enabled: ZBTheme.useAnimation
                            SpringAnimation {
                                spring: 3
                                damping: 0.3
                                duration: 500
                            }
                        }

                    }//highlighter

                }//Rectangle for delegate background
            }//Item delegate


        }//GridView
    }//Rectangle for background
}//Item main
