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
    property Item appUi: null

    property int dialogWidth: parent.width*0.80
    property int dialogHeight: parent.height*0.80

    property Item mainView: null
    property ObjectModel model:null

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
                color: "white"
                radius: 5
            }
        }
    }

    function close(){
        objDialogRoot.visible = false;
        objDialogRoot.focus = false;
        if(objDialogRoot.mainView){
            try{objDialogRoot.mainView.destroy();}catch(e){}
        }
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
