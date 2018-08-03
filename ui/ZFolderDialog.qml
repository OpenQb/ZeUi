import QtQuick 2.10

import "./../base"

ZBItem {
    id: objFolderDialog
    activeFocusOnTab: false
    signal selectedPath(string path);

    property Item folderView: null;

    Component{
        id: compFolderView
        ZFolderView{
            id: objFolderView
            anchors.fill: parent
            onSelectedPath:{
                objFolderDialog.selectedPath(path);
                objFolderDialog.close();
            }
        }
    }

    function open(){
        if(objFolderDialog.folderView === null){
            objFolderDialog.folderView = compFolderView.createObject(objFolderDialog,{"appUi":objFolderDialog.appUi});
        }

    }

    function close(){
        if(objFolderDialog.folderView!==null){
            try{
                folderView.destroy();
            }
            catch(e){}
            objFolderDialog.folderView = null;
        }
    }
}
