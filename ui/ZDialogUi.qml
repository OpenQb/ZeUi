import Qb 1.0
import Qb.Core 1.0


import QtQuick 2.11
import QtQml.Models 2.1
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "./../base"

Rectangle {
    id: objDialogRoot
    color: QbCoreOne.changeTransparency("black",160)
    activeFocusOnTab: false
    visible: false
    focus: false
    property string title: "Dialog"

    property int dialogWidth: parent.width*0.80
    property int dialogHeight: parent.height*0.80

    property Item mainView: null
    property ObjectModel model:null
    property Item dialogView: null
    property int currentIndex:-1

    Connections{
        target: ZBLib.appUi
        onAppClosing:{
            objDialogRoot.close();
        }
    }

    MouseArea{
        anchors.fill: parent
        preventStealing: true
        hoverEnabled: true
        onClicked: {
            //if(objDialogRoot.closeOnOutsideClick){
            //    objDialogRoot.close();
            //}
        }
    }
    Keys.onPressed: {
        event.accepted = true;
        if(event.key === Qt.Key_Escape || event.key === Qt.Key_Back){
            objDialogRoot.close();
        }
    }
    Keys.onReleased: {
        event.accepted = true;
    }

    Component{
        id: compDialog
        Item{
            id: objDialog
            width: objDialogRoot.dialogWidth
            height: objDialogRoot.dialogHeight
            anchors.centerIn: parent

            Rectangle{
                anchors.fill: parent
                color: ZBLib.appUi.zBaseTheme.background
                radius: 5

                Rectangle{
                    id: objTopBar
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 50
                    radius: 5
                    color: ZBLib.appUi.zBaseTheme.primary
                    Rectangle{
                        width: parent.width
                        height: 5
                        color: ZBLib.appUi.zBaseTheme.primary
                        anchors.bottom: parent.bottom
                    }
                    Text{
                        id: objTitle
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: objDialogRoot.title
                        font.family: ZBLib.appUi.zBaseTheme.defaultFontFamily
                        font.pixelSize: ZBLib.appUi.zBaseTheme.defaultFontSize+3
                        color: ZBLib.appUi.zBaseTheme.metaTheme.isDark(ZBLib.appUi.zBaseTheme.primary)?"white":"black"
                    }
                    Item{
                        id: objCloseButton
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: parent.height
                        width: height
                        Rectangle{
                            id: objCloseButtonBG
                            anchors.centerIn: parent
                            height: parent.height*0.60
                            width: parent.width*0.60
                            radius: height/2.0
                            activeFocusOnTab: true
                            property bool isHovered: false
                            color: isHovered?ZBLib.appUi.zBaseTheme.metaTheme.lighter(ZBLib.appUi.zBaseTheme.accent,180):focus?ZBLib.appUi.zBaseTheme.metaTheme.lighter(ZBLib.appUi.zBaseTheme.accent,180):ZBLib.appUi.zBaseTheme.accent
                            Keys.onPressed: {
                                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space){
                                    event.accepted = true;
                                    objDialogRoot.close();
                                }
                            }
                            Keys.onReleased: {
                                event.accepted = true;
                            }

                            Text{
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.family: QbMF3.family
                                text: QbMF3.icon("mf-close")
                                font.pixelSize: parent.height/2
                                color: ZBLib.appUi.zBaseTheme.metaTheme.isDark(ZBLib.appUi.zBaseTheme.accent)?"white":"black"
                            }
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true;
                                onEntered: {
                                    objCloseButtonBG.isHovered = true;
                                }
                                onExited: {
                                    objCloseButtonBG.isHovered = false;
                                }
                                onClicked: {
                                    objDialogRoot.close();
                                }
                            }
                        }
                    }
                }//end of TopBar

                ListView{
                    id: objListView
                    clip: true
                    anchors.left: parent.left
                    //anchors.leftMargin: 5
                    anchors.right: parent.right
                    //anchors.rightMargin: 5
                    anchors.top: objTopBar.bottom
                    //anchors.topMargin: 5
                    anchors.bottom: parent.bottom
                    //anchors.bottomMargin: 5
                    model: objDialogRoot.model
                    activeFocusOnTab: true
                    highlightFollowsCurrentItem: true
                    onCurrentIndexChanged: objDialogRoot.currentIndex = objListView.currentIndex;
                    ScrollBar.vertical: ScrollBar {
                        id: objScrollBar;
                        active: objScrollBar.focus || objListView.focus
                        focusReason: Qt.StrongFocus
                        Keys.onUpPressed: objScrollBar.decrease()
                        Keys.onDownPressed: objScrollBar.increase()
                    }
                    Material.accent: ZBLib.appUi.zBaseTheme.accent
                    Material.primary: ZBLib.appUi.zBaseTheme.primary
                    Material.foreground: ZBLib.appUi.zBaseTheme.foreground
                    Material.background: ZBLib.appUi.zBaseTheme.background
                    Component.onCompleted: {
                        objDialogRoot.dialogView = objListView;
                    }
                    Keys.onUpPressed: {
                        if(objListView.currentIndex === 0){
                            event.accepted = false;
                            return;
                        }

                        while(true){
                            objListView.decrementCurrentIndex();
                            if(objListView.currentIndex === 0){
                                break;
                            }
                            if(objListView.currentItem.visible === true && objListView.currentItem.enabled === true){
                                break;
                            }
                        }
                    }
                    Keys.onDownPressed: {
                        if(objListView.currentIndex >= (objListView.count-1)){
                            event.accepted = false;
                            return;
                        }
                        while(true){
                            objListView.incrementCurrentIndex();
                            if(objListView.currentIndex >=(objListView.count-1)){
                                break;
                            }
                            if(objListView.currentItem.visible === true && objListView.currentItem.enabled === true){
                                break;
                            }
                        }
                    }
                }

                //                Item {
                //                    id: objScrollBar
                //                    width: QbCoreOne.scale(8)
                //                    height: objListView.height
                //                    anchors.right: objListView.right
                //                    anchors.top: objListView.top
                //                    opacity: 1
                //                    clip: true
                //                    visible: objScrollBar.height!=objHandle.height
                //                    property real position: objListView.visibleArea.yPosition
                //                    property real pageSize: objListView.visibleArea.heightRatio

                //                    Rectangle {
                //                        id: objScrollBarBack
                //                        anchors.fill: parent
                //                        color: ZBLib.appUi.zBaseTheme.accent
                //                        opacity: 0.3
                //                    }
                //                    Rectangle {
                //                        id: objHandle
                //                        x: 0
                //                        y: objScrollBar.position * (objScrollBar.height)
                //                        width: (objScrollBar.width)
                //                        height: (objScrollBar.pageSize * (objListView.height))
                //                        //radius: (width/2)
                //                        color: ZBLib.appUi.zBaseTheme.metaTheme.isDark(ZBLib.appUi.zBaseTheme.accent)?"white":"black"
                //                        opacity: 0.7
                //                    }
                //                }//custom ScrollBar

            }
        }
    }

    function close(){
        if(objDialogRoot.mainView){
            try{objDialogRoot.mainView.destroy();}catch(e){}
        }
        objDialogRoot.visible = false;
        objDialogRoot.focus = false;
        objDialogRoot.mainView = null;
    }

    function open(){
        if(objDialogRoot.mainView === null && ZBLib.appUi){
            objDialogRoot.visible = true;
            objDialogRoot.mainView = compDialog.createObject(objDialogRoot,{})
        }
    }

    function toggle(){
        if(objDialogRoot.visible){
            objDialogRoot.close();
        }
        else{
            objDialogRoot.open();
        }
    }


}
