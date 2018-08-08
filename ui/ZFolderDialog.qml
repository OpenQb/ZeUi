import QtQuick 2.10

import "./../base"

ZBItem {
    id: objFolderDialog
    activeFocusOnTab: false
    visible: false
    signal selectedPath(string path);

    property Item folderView: null;

    Connections{
        target: ZBLib.appUi
        onAppClosing:{
            objFolderDialog.close();
        }
    }

    MouseArea{
        anchors.fill: parent
        preventStealing: true
        hoverEnabled: true
    }
    Keys.onPressed: {
        event.accepted = true;
        if(event.key === Qt.Key_Escape || event.key === Qt.Key_Back){
            objFolderDialog.close();
        }
    }
    Keys.onReleased: {
        event.accepted = true;
    }

    Rectangle{
        id: objDialogParent
        anchors.fill: parent
        color: ZBLib.appUi.mCT("black",160)
    }

    Component{
        id: compFolderView
        ZFolderView{
            id: objFolderView
            width: objFolderDialog.width*0.80
            height: objFolderDialog.height*0.80
            anchors.centerIn: parent
            onSelectedPath:{
                objFolderDialog.selectedPath(path);
                objFolderDialog.close();
            }
            onCloseClicked: {
                objFolderDialog.close();
            }
        }
    }

    function open(){
        if(objFolderDialog.folderView === null){
            objFolderDialog.forceActiveFocus();
            objFolderDialog.focus = false;
            objFolderDialog.visible = true;
            objFolderDialog.folderView = compFolderView.createObject(objDialogParent,{});
        }

    }

    function close(){
        objFolderDialog.visible = false;
        objFolderDialog.focus = false;
        if(objFolderDialog.folderView!==null){
            try{
                folderView.destroy();
            }
            catch(e){}
            objFolderDialog.folderView = null;
        }
    }
}
