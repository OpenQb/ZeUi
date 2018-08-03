import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../base"

ZBItem {
    id: objFolderDialog
    clip: true
    state: "Home"

    property string selectedPath: ""
    property string oldSelectedPath: ""

    onSelectedPathChanged: {
        console.log(selectedPath);

        objFolderDialog.state = "FolderView";
        objFolderScreenModel.clear();
        objDirObject.setPath(selectedPath);
        objDirObject.setFilter(QbDir.Dirs|QbDir.NoDotAndDotDot);
        var mv = objDirObject.entryInfoList();
        for(var i=0;i<mv.length;++i){
            if(objDirObject.isReadable(mv[i].absoluteFilePath)){
                objFolderScreenModel.append({"name":mv[i].fileName,"path":mv[i].absoluteFilePath})
            }
        }
    }

    states: [
        State {
            name: "Home"
            PropertyChanges {
                target: objHomeScreen
                visible: true;
            }
            PropertyChanges {
                target: objFolderViewScreen
                visible: false;
            }
            PropertyChanges {
                target: objHomeScreenView
                focus: true;
            }
            PropertyChanges {
                target: objFolderViewScreenView
                focus: false;
            }
        },
        State {
            name: "FolderView"
            PropertyChanges {
                target: objHomeScreen
                visible: false;
            }
            PropertyChanges {
                target: objFolderViewScreen
                visible: true;
            }
            PropertyChanges {
                target: objHomeScreenView
                focus: false;
            }
            PropertyChanges {
                target: objFolderViewScreenView
                focus: true;
            }
        }
    ]

    Component.onCompleted: {

        if(objDirObject.exists(objPathsObject.documents())){
            objHomeScreenModel.append({"name":"Documents","path":objPathsObject.documents()})
        }
        if(objDirObject.exists(objPathsObject.downloads())){
            objHomeScreenModel.append({"name":"Downloads","path":objPathsObject.downloads()})
        }

        //objHomeScreenModel.append({"name":"Qb Documents","path":objPathsObject.qbdocuments()})
        //objHomeScreenModel.append({"name":"Qb Downloads","path":objPathsObject.qbdownloads()})

        if(Qt.platform.os === "android"){
            if(objDirObject.exists("/sdcard")){
                objHomeScreenModel.append({"name":"sdcard","path":"/sdcard"})
            }
            if(objDirObject.exists("/storage")){
                objHomeScreenModel.append({"name":"storage","path":"/storage"})
            }
        }

        var mv = objDirObject.mountedVolumes();
        for(var i=0;i<mv.length;++i){
            if(objDirObject.isReadable(mv[i].rootPath)){
                objHomeScreenModel.append({"name":mv[i].name,"path":mv[i].rootPath})
            }
        }

    }

    QbDir{
        id: objDirObject
        Component.onCompleted: {
            objDirObject.setSorting(QbDir.DirsFirst|QbDir.Name);
        }
    }

    QbPaths{
        id: objPathsObject
    }

    ListModel{
        id: objHomeScreenModel
    }
    ListModel{
        id: objFolderScreenModel
    }

    Rectangle{
        anchors.fill: parent
        color: ZBTheme.background


        Item{
            id: objHomeScreen
            anchors.fill: parent
            GridView{
                id: objHomeScreenView
                activeFocusOnTab: true
                cellWidth: parent.width
                cellHeight: 50
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                model: objHomeScreenModel
                currentIndex: 0
                delegate: Rectangle{
                    width: objHomeScreenView.cellWidth
                    height: objHomeScreenView.cellHeight
                    color: objHomeScreenView.focus?objHomeScreenView.currentIndex === index?ZBTheme.itemSelectedBackgroundColor:ZBTheme.itemBackgroundColor:ZBTheme.itemBackgroundColor
                    Text{
                        id: objDelIcon
                        anchors.top: parent.top
                        anchors.left: parent.left
                        width: parent.height
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: QbFA.icon("fa-hdd-o")
                        color: objHomeScreenView.focus?objHomeScreenView.currentIndex === index?ZBTheme.itemSelectedColor:ZBTheme.itemColor:ZBTheme.itemColor
                        font.family: QbFA.family
                        font.pixelSize: objHomeScreenView.focus?objHomeScreenView.currentIndex === index?ZBTheme.itemSelectedFontSize:ZBTheme.itemFontSize:ZBTheme.itemFontSize
                        font.bold: objHomeScreenView.focus?objHomeScreenView.currentIndex === index?ZBTheme.itemSelectedFontBold:ZBTheme.itemFontBold:ZBTheme.itemFontBold
                    }

                    Text{
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: objDelIcon.right
                        anchors.leftMargin: 5
                        anchors.right: parent.right
                        verticalAlignment: Text.AlignVCenter
                        text: name
                        color: objHomeScreenView.focus?objHomeScreenView.currentIndex === index?ZBTheme.itemSelectedColor:ZBTheme.itemColor:ZBTheme.itemColor
                        font.family: objHomeScreenView.focus?objHomeScreenView.currentIndex === index?ZBTheme.itemSelectedFontFamily:ZBTheme.itemFontFamily:ZBTheme.itemFontFamily
                        font.pixelSize: objHomeScreenView.focus?objHomeScreenView.currentIndex === index?ZBTheme.itemSelectedFontSize:ZBTheme.itemFontSize:ZBTheme.itemFontSize
                        font.bold: objHomeScreenView.focus?objHomeScreenView.currentIndex === index?ZBTheme.itemSelectedFontBold:ZBTheme.itemFontBold:ZBTheme.itemFontBold
                    }

                    Rectangle{
                        width: parent.width
                        height: ZBTheme.ribbonHeight
                        anchors.bottom: parent.bottom
                        color: objHomeScreenView.focus?objHomeScreenView.currentIndex === index?ZBTheme.ribbonColor:ZBTheme.ribbonColorNonFocus:ZBTheme.ribbonColorNonFocus
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            objHomeScreenView.focus = true;
                            objHomeScreenView.currentIndex = index;
                            if(objFolderDialog.selectedPath !== path){
                                objFolderDialog.oldSelectedPath = objFolderDialog.selectedPath;
                                objFolderDialog.selectedPath = path;
                            }
                        }
                    }

                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            if(objFolderDialog.selectedPath !== path){
                                objFolderDialog.oldSelectedPath = objFolderDialog.selectedPath;
                                objFolderDialog.selectedPath = path;
                            }
                        }
                    }
                    Keys.onReleased: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                        }
                    }
                }
            }
        }//HomeScreen


        Item{
            id: objFolderViewScreen
            anchors.fill: parent

            Rectangle{
                id: objFolderViewScreenTopToolBar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 50
            }

            GridView{
                id: objFolderViewScreenView
                activeFocusOnTab: true
                cellWidth: parent.width
                cellHeight: 50
                clip: true
                anchors.top: objFolderViewScreenTopToolBar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                model: objFolderScreenModel
                currentIndex: 0
                delegate: Rectangle{
                    width: objFolderViewScreenView.cellWidth
                    height: objFolderViewScreenView.cellHeight
                    color: objFolderViewScreenView.focus?objFolderViewScreenView.currentIndex === index?ZBTheme.itemSelectedBackgroundColor:ZBTheme.itemBackgroundColor:ZBTheme.itemBackgroundColor
                    Text{
                        id: objFolderViewScreenViewDelIcon
                        anchors.top: parent.top
                        anchors.left: parent.left
                        width: parent.height
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: QbFA.icon("fa-folder-o")
                        color: objFolderViewScreenView.focus?objFolderViewScreenView.currentIndex === index?ZBTheme.itemSelectedColor:ZBTheme.itemColor:ZBTheme.itemColor
                        font.family: QbFA.family
                        font.pixelSize: objFolderViewScreenView.focus?objFolderViewScreenView.currentIndex === index?ZBTheme.itemSelectedFontSize:ZBTheme.itemFontSize:ZBTheme.itemFontSize
                        font.bold: objFolderViewScreenView.focus?objFolderViewScreenView.currentIndex === index?ZBTheme.itemSelectedFontBold:ZBTheme.itemFontBold:ZBTheme.itemFontBold
                    }

                    Text{
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: objFolderViewScreenViewDelIcon.right
                        anchors.leftMargin: 5
                        anchors.right: parent.right
                        verticalAlignment: Text.AlignVCenter
                        text: name
                        color: objFolderViewScreenView.focus?objFolderViewScreenView.currentIndex === index?ZBTheme.itemSelectedColor:ZBTheme.itemColor:ZBTheme.itemColor
                        font.family: objFolderViewScreenView.focus?objFolderViewScreenView.currentIndex === index?ZBTheme.itemSelectedFontFamily:ZBTheme.itemFontFamily:ZBTheme.itemFontFamily
                        font.pixelSize: objFolderViewScreenView.focus?objFolderViewScreenView.currentIndex === index?ZBTheme.itemSelectedFontSize:ZBTheme.itemFontSize:ZBTheme.itemFontSize
                        font.bold: objFolderViewScreenView.focus?objFolderViewScreenView.currentIndex === index?ZBTheme.itemSelectedFontBold:ZBTheme.itemFontBold:ZBTheme.itemFontBold
                    }

                    Rectangle{
                        width: parent.width
                        height: ZBTheme.ribbonHeight
                        anchors.bottom: parent.bottom
                        color: objFolderViewScreenView.focus?objFolderViewScreenView.currentIndex === index?ZBTheme.ribbonColor:ZBTheme.ribbonColorNonFocus:ZBTheme.ribbonColorNonFocus
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            objFolderViewScreenView.focus = true;
                            objFolderViewScreenView.currentIndex = index;
                            if(objFolderDialog.selectedPath !== path){
                                objFolderDialog.oldSelectedPath = objFolderDialog.selectedPath;
                                objFolderDialog.selectedPath = path;
                            }
                        }
                    }

                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            if(objFolderDialog.selectedPath !== path){
                                objFolderDialog.oldSelectedPath = objFolderDialog.selectedPath;
                                objFolderDialog.selectedPath = path;
                            }
                        }
                    }
                    Keys.onReleased: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                        }
                    }
                }
            }
        }
    }
}
