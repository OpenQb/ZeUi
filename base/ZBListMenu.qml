import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "."

Item {
    id: objBaseMenuRoot
    clip: true

    visible: false
    z: -10000000
    focus: false
    width: ZBTheme.menuWindowWidth

    height: Math.min(parent.height,Math.min(objGridView.contentHeight+ZBTheme.menuItemHeight,ZBTheme.menuWindowHeight))

    property Item lastActiveFocusItem: null;

    function openMenu(x,y){
        objBaseMenuRoot.lastActiveFocusItem = QbCoreOne.getActiveFocusItem();
        objBaseMenuRoot.x = x;
        objBaseMenuRoot.y = y;
        objBaseMenuRoot.z = 10000000;
        objBaseMenuRoot.visible = true;
        objBaseMenuRoot.isOpened = true;
        objBaseMenuRoot.forceActiveFocus();
        objBaseMenuRoot.focus = true;
    }

    function closeMenu(){
        objBaseMenuRoot.visible = false;
        objBaseMenuRoot.z = -10000000;
        objBaseMenuRoot.focus = false;
        objBaseMenuRoot.isOpened = false;
        objBaseMenuRoot.lastActiveFocusItem.forceActiveFocus();
        objBaseMenuRoot.lastActiveFocusItem.focus = true;
    }

    signal selectedItem(string title,int index,int x,int y);
    signal selectedByMouse();

    property string title: ""
    property bool isOpened: false
    property int menuItemHeight: ZBTheme.menuItemHeight

    property alias menuItemModel: objGridView.model
    property alias menuItemDelegate: objGridView.delegate
    property alias menuInteractive: objGridView.interactive

    property alias menuItemCurrentIndex: objGridView.currentIndex
    property alias menuItemCurrentItem: objGridView.currentItem

    property alias menuItemSelectedX: objGridView.selectedX
    property alias menuItemSelectedY: objGridView.selectedY

    function emitSelection(index,x,y){
        var obj = objGridView.model.get(index);
        objBaseMenuRoot.selectedItem(obj.title,index,x,y);
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
            objBaseMenuRoot.closeMenu();
        }
        else if(event.key === Qt.Key_Up){
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
        else{
            event.accepted = true;
            objGridView.currentIndex = -1;
            objBaseMenuRoot.closeMenu();
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
        else{
            event.accepted = true;
        }
    }
    Keys.onPressed: keysOnPressed(event);
    Keys.onReleased: keysOnReleased(event);

    Rectangle{
        anchors.fill: parent
        color: ZBTheme.dockBackgroundColor
        Rectangle{
            z: 3
            id: objTitlePlaceHolder
            anchors.top: parent.top
            width: parent.width
            height: objBaseMenuRoot.menuItemHeight
            color: ZBTheme.itemSelectedBackgroundColor
            Text{
                anchors.fill: parent
                anchors.leftMargin: 5
                text: objBaseMenuRoot.title
                color: ZBTheme.itemSelectedColor
                font.family: ZBTheme.itemSelectedFontFamily
                font.bold: ZBTheme.itemSelectedFontBold
                font.pixelSize: ZBTheme.itemSelectedFontSize
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea{
                anchors.fill: parent
                preventStealing: true
                onPressed: {
                    objBaseMenuRoot.closeMenu();
                }
            }
        }

        GridView{
            id: objGridView
            z: 1
            anchors.top: objTitlePlaceHolder.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            cellHeight: objBaseMenuRoot.menuItemHeight
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
                height: objBaseMenuRoot.menuItemHeight

                Rectangle{
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    color: objGridView.currentIndex===index?ZBTheme.itemSelectedBackgroundColor:ZBTheme.itemBackgroundColor

                    Item{
                        id: objIconPlaceHolder
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: objBaseMenuRoot.menuItemHeight
                        visible: model.icon===undefined||model.icon===""?false:true
                        Text{
                            anchors.fill: parent
                            color: objGridView.currentIndex===index?ZBTheme.itemSelectedColor:ZBTheme.itemColor
                            text: QbCoreOne.icon_font_text_code(model.icon)
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.family: QbCoreOne.icon_font_name(model.icon)
                            font.bold: objGridView.currentIndex===index?ZBTheme.itemSelectedIconFontBold:ZBTheme.itemIconFontBold
                            font.pixelSize: objDockItemDelegate.height*0.60
                            visible: QbCoreOne.icon_font_is_text(model.icon)
                        }
                        Image{
                            anchors.fill: parent
                            anchors.centerIn: parent
                            visible: QbCoreOne.icon_font_is_image(model.icon)
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            mipmap: true
                            smooth: true
                            source: visible?model.icon:""
                        }
                    }

                    Item{
                        id: objTextPlaceHolder
                        anchors.left: objIconPlaceHolder.visible?objIconPlaceHolder.right:parent.left
                        anchors.leftMargin: 5

                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: objIconPlaceHolder.visible?parent.width - objBaseMenuRoot.menuItemHeight - 5:parent.width - 5
                        clip: true
                        Text{
                            anchors.fill: parent
                            color: objGridView.currentIndex===index?ZBTheme.itemSelectedColor:ZBTheme.itemColor
                            text: title
                            font.family: objGridView.currentIndex===index?ZBTheme.itemSelectedFontFamily:ZBTheme.itemFontFamily
                            font.bold: objGridView.currentIndex===index?ZBTheme.itemSelectedFontBold:ZBTheme.itemFontBold
                            font.pixelSize: objGridView.currentIndex===index?ZBTheme.itemSelectedFontSize:ZBTheme.itemFontSize
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        preventStealing: true
                        onClicked: {
                            objGridView.currentIndex = index;
                            var gco = objDockItemDelegate.mapToItem(objBaseMenuRoot, 0, 0);
                            objBaseMenuRoot.emitSelection(index,gco.x,gco.y);
                            objBaseMenuRoot.selectedByMouse();
                        }
                    }

                    Connections {
                        target: objGridView
                        onCurrentIndexChanged: {
                            if(objGridView.currentIndex === index){
                                var gco = objDockItemDelegate.mapToItem(objBaseMenuRoot, 0, 0);
                                objGridView.selectedX = gco.x;
                                objGridView.selectedY = gco.y;
                            }
                        }
                    }

                    Rectangle{
                        height: 3
                        color: ZBTheme.ribbonColor
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
