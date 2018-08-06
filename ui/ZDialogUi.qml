import Qb 1.0
import Qb.Core 1.0


import QtQuick 2.11
import QtQml.Models 2.1
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4


Rectangle {
    id: objDialogRoot
    color: QbCoreOne.changeTransparency("black",160)
    activeFocusOnTab: false
    visible: false
    focus: false
    property string title: "Dialog"
    property Item appUi: null

    property int dialogWidth: parent.width*0.80
    property int dialogHeight: parent.height*0.80

    property Item mainView: null
    property ObjectModel model:null

    Connections{
        target: appUi
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
                color: objDialogRoot.appUi.zBaseTheme.background
                radius: 5

                Rectangle{
                    id: objTopBar
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 50
                    radius: 5
                    color: objDialogRoot.appUi.zBaseTheme.primary
                    Rectangle{
                        width: parent.width
                        height: 5
                        color: objDialogRoot.appUi.zBaseTheme.primary
                        anchors.bottom: parent.bottom
                    }
                    Text{
                        id: objTitle
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.right: objCloseButton.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: objDialogRoot.title
                        font.family: objDialogRoot.appUi.zBaseTheme.defaultFontFamily
                        font.pixelSize: objDialogRoot.appUi.zBaseTheme.defaultFontSize+3
                        color: objDialogRoot.appUi.zBaseTheme.metaTheme.isDark(objDialogRoot.appUi.zBaseTheme.primary)?"white":"black"
                    }
                    RoundButton{
                        id: objCloseButton
                        anchors.right: parent.right
                        anchors.top: parent.top
                        text: QbMF3.icon("mf-close")
                        font.family: QbMF3.family
                        font.pixelSize: height*0.50
                        focusReason: Qt.StrongFocus
                        onClicked: objDialogRoot.close()
                        Material.background: objDialogRoot.appUi.zBaseTheme.primary
                    }
                }//end of TopBar



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
        if(objDialogRoot.mainView === null && objDialogRoot.appUi){
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
