import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQml.Models 2.1
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "./../base"

Popup {
    id: objPopup

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    property string appId: ""

    property int dialogLeftMargin: 0
    property int dialogRightMargin: 0
    property int dialogTopMargin: 0
    property int dialogBottomMargin: 0
    property int dialogSpacing: 10
    property int dialogTopRadius: 5

    property bool dialogInteractive: true;

    property string title: "Dialog"

    property bool enableStatusBar: false;
    property int dialogWidth: parent.width
    property int dialogHeight: parent.height
    property int availableDialogHeight: enableStatusBar?dialogHeight - 50*2:dialogHeight - 50*1


    property string statusBarButtonText: "OK";
    property string statusBarMessage: "";
    property color statusBarMessageColor: "white";

    signal buttonClicked();

    property Item mainView: null
    property ObjectModel model:null
    property Component modelComponent: null

    property Item dialogView: null
    property int currentIndex:-1

    onStatusBarMessageChanged: {
        if(statusBarMessage !== ""){
            if(objStatusBarClearTimer.running) objStatusBarClearTimer.stop();
            objStatusBarClearTimer.start();
        }
    }

    contentItem: Rectangle{
        id: objDialogRoot

        Connections{
            target: ZBLib.appUi
            onAppClosing:{
                objPopup.close();
            }
        }

        Timer{
            id: objStatusBarClearTimer
            interval: 5000
            onTriggered: {
                objPopup.statusBarMessage = ""
                objStatusBarClearTimer.stop();
            }
        }



        Component{
            id: compDialog
            Item{
                id: objDialog
                x: 0
                y: 0
                width: objPopup.dialogWidth
                height: objPopup.dialogHeight

                Rectangle{
                    anchors.fill: parent
                    color: QbUtil.getAppObject(objPopup.appId,"ZBTheme").background

                    Rectangle{
                        id: objTopBar
                        x: 0
                        y: 0
                        width: parent.width
                        height: 50
                        color: QbUtil.getAppObject(objPopup.appId,"ZBTheme").primary
                        Rectangle{
                            width: parent.width
                            height: 5
                            color: QbUtil.getAppObject(objPopup.appId,"ZBTheme").primary
                            anchors.bottom: parent.bottom
                        }
                        Text{
                            id: objTitle
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: objPopup.title
                            font.family: QbUtil.getAppObject(objPopup.appId,"ZBTheme").defaultFontFamily
                            font.pixelSize: QbUtil.getAppObject(objPopup.appId,"ZBTheme").defaultFontSize+3
                            color: QbUtil.getAppObject(objPopup.appId,"ZBTheme").metaTheme.isDark(QbUtil.getAppObject(objPopup.appId,"ZBTheme").primary)?"white":"black"
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
                                color: isHovered?QbUtil.getAppObject(objPopup.appId,"ZBTheme").metaTheme.lighter(QbUtil.getAppObject(objPopup.appId,"ZBTheme").accent,180):focus?QbUtil.getAppObject(objPopup.appId,"ZBTheme").metaTheme.lighter(QbUtil.getAppObject(objPopup.appId,"ZBTheme").accent,180):QbUtil.getAppObject(objPopup.appId,"ZBTheme").accent
                                Keys.onPressed: {
                                    if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space){
                                        event.accepted = true;
                                        objPopup.close();
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
                                    color: QbUtil.getAppObject(objPopup.appId,"ZBTheme").metaTheme.isDark(QbUtil.getAppObject(objPopup.appId,"ZBTheme").accent)?"white":"black"
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
                                        objPopup.closeDialog();
                                    }
                                }
                            }
                        }
                    }//end of TopBar

                    ListView{
                        id: objListView
                        clip: true

                        anchors.left: parent.left
                        anchors.leftMargin: objPopup.dialogLeftMargin
                        anchors.right: parent.right
                        anchors.rightMargin: objPopup.dialogRightMargin
                        anchors.top: objTopBar.bottom
                        anchors.topMargin: objPopup.dialogTopMargin
                        anchors.bottom: objStatusBar.top
                        anchors.bottomMargin: objPopup.dialogBottomMargin
                        interactive: objPopup.dialogInteractive
                        model: objPopup.model
                        activeFocusOnTab: true
                        highlightFollowsCurrentItem: true
                        currentIndex: 0
                        //onCurrentIndexChanged: objDialogRoot.currentIndex = objListView.currentIndex;
                        ScrollBar.vertical: ScrollBar {
                            id: objScrollBar;
                            active: objScrollBar.focus || objListView.focus
                            focusReason: Qt.StrongFocus
                            Keys.onUpPressed: objScrollBar.decrease()
                            Keys.onDownPressed: objScrollBar.increase()
                        }
                        Material.accent: QbUtil.getAppObject(objPopup.appId,"ZBTheme").accent
                        Material.primary: QbUtil.getAppObject(objPopup.appId,"ZBTheme").primary
                        Material.foreground: QbUtil.getAppObject(objPopup.appId,"ZBTheme").foreground
                        Material.background: QbUtil.getAppObject(objPopup.appId,"ZBTheme").background
                        Component.onCompleted: {
                            objPopup.dialogView = objListView;
                        }

                        function actionUpPressed(event){
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

                        function actionDownPressed(event){
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
                        Keys.onUpPressed: actionUpPressed(event)
                        Keys.onDownPressed: actionDownPressed(event)
                    }//End of ListView

                    //StatusBar
                    Rectangle{
                        id: objStatusBar
                        anchors.bottom: parent.bottom
                        visible: objPopup.enableStatusBar
                        width: parent.width
                        height: objPopup.enableStatusBar?QbCoreOne.scale(50):0
                        color: ZBTheme.primary
                        Label{
                            anchors.left: parent.left
                            anchors.leftMargin: QbCoreOne.scale(5)
                            anchors.right: objOKButton.left
                            anchors.rightMargin: QbCoreOne.scale(5)
                            anchors.bottom: parent.bottom
                            anchors.top: parent.top
                            text: objPopup.statusBarMessage
                            color: objPopup.statusBarMessageColor
                            elide: Label.ElideMiddle
                            verticalAlignment: Label.AlignVCenter
                            //horizontalAlignment: Label.AlignHCenter
                        }
                        Button{
                            id: objOKButton
                            Material.background: ZBTheme.secondary
                            Material.theme: Material.Light
                            text: objPopup.statusBarButtonText
                            anchors.right: parent.right
                            anchors.rightMargin: QbCoreOne.scale(5)
                            onClicked: {
                                objPopup.buttonClicked();
                            }
                            Rectangle{
                                visible: objOKButton.activeFocus
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: QbCoreOne.scale(2)
                                color: ZBTheme.accent
                            }
                        }
                    }
                }
            }
        }//Component




    }//contentItem


    function closeDialog(){
        if(objPopup .mainView){
            try{objPopup.mainView.destroy();}catch(e){}
        }
        if(objPopup.model){
            try{objPopup.model.destroy();}catch(e){}
        }
        objPopup.mainView = null;
        objPopup.close();
    }

    function openDialog(){
        if(objPopup.mainView === null && QbUtil.getAppObject(objPopup.appId,"appUi") && objPopup.model === null)
        {
            console.log("Opening dialog.");
            objPopup.model = objPopup.modelComponent.createObject(objDialogRoot,{});
            objPopup.mainView = compDialog.createObject(objDialogRoot,{});
            objPopup.open();
        }
    }
}
