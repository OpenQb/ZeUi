import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../base"

ZBItem {
    id: objFolderView
    clip: true
    state: "Home"

    property string choosenPath: ""
    property string browsingSelectedPath: ""
    property string oldbrowsingSelectedPath: ""
    property string selectedRoot: ""

    signal selectedPath(string path);

    onChoosenPathChanged: {
        console.log("CHOOSEN PATH:",choosenPath);
    }



    onBrowsingSelectedPathChanged: {
        if(browsingSelectedPath!==""){
            objFolderView.state = "FolderView";
            objFolderScreenModel.clear();
            objDirObject.setPath(browsingSelectedPath);
            objDirObject.setFilter(QbDir.Dirs|QbDir.NoDotAndDotDot);
            var mv = objDirObject.entryInfoList();
            if(mv.length === 0){
                if( objDirObject.isWritable(objFolderView.browsingSelectedPath)){
                    objFolderViewScreen.selectFolderEnabled = true;
                }
                else{
                    objFolderViewScreen.selectFolderEnabled = false;
                }

                objFolderViewScreenView.currentIndex = -1;
            }
            else{
                objFolderViewScreenView.currentIndex = 0;
            }
            for(var i=0;i<mv.length;++i){
                if(objDirObject.isReadable(mv[i].absoluteFilePath)){
                    objFolderScreenModel.append({"name":mv[i].fileName,"path":mv[i].absoluteFilePath})
                    if(i===0){
                        var t = objDirObject.isWritable(mv[i].absoluteFilePath);
                        if(t){
                            objFolderViewScreen.selectFolderEnabled = true;
                        }
                        else{
                            objFolderViewScreen.selectFolderEnabled = false;
                        }
                    }
                }
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

    function goHome(){
        objFolderView.state = "Home";
        objFolderView.browsingSelectedPath = "";
        objFolderView.oldbrowsingSelectedPath = "";
        objFolderView.selectedRoot = "";
    }

    function goToPath(path){
        if(objFolderView.browsingSelectedPath !== path){
            objFolderViewScreenView.currentIndex = -1;
            objFolderView.oldbrowsingSelectedPath = objFolderView.browsingSelectedPath;
            objFolderView.browsingSelectedPath = path;
        }
    }

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
                    color: objHomeScreenView.currentIndex === index?ZBTheme.itemSelectedBackgroundColor:ZBTheme.itemBackgroundColor
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
                        onDoubleClicked: {
                            objHomeScreenView.focus = true;
                            objHomeScreenView.currentIndex = index;
                            objFolderView.selectedRoot = path;
                            objFolderView.goToPath(path);
                        }
                        onClicked: {
                            objHomeScreenView.focus = true;
                            objHomeScreenView.currentIndex = index;
                        }
                    }

                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            objFolderView.selectedRoot = path;
                            objFolderView.goToPath(path);
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

            property bool selectFolderEnabled: false;

            Rectangle{
                id: objFolderViewScreenTopToolBar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 50
                color: ZBTheme.primary

                RoundButton{
                    id: objFolderViewScreenHomeButton
                    focusReason: Qt.StrongFocus
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    Material.background: ZBTheme.secondary
                    Material.primary: ZBTheme.primary
                    Material.accent: ZBTheme.accent
                    Material.theme: ZBTheme.theme === "dark"?Material.Dark:Material.Light
                    text: QbMF3.icon("mf-home")
                    font.family: QbMF3.family
                    font.pixelSize: parent.height*0.5
                    onPressed: {
                        objFolderView.goHome();
                    }
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            objFolderView.goHome();
                        }
                    }
                    Keys.onReleased: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                        }
                    }
                }
                RoundButton{
                    id: objFolderViewUpButton
                    focusReason: Qt.StrongFocus
                    anchors.left: objFolderViewScreenHomeButton.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    Material.background: ZBTheme.secondary
                    Material.primary: ZBTheme.primary
                    Material.accent: ZBTheme.accent
                    Material.theme: ZBTheme.theme === "dark"?Material.Dark:Material.Light
                    text: QbMF3.icon("mf-keyboard_arrow_up")
                    font.family: QbMF3.family
                    font.pixelSize: parent.height*0.5
                    onPressed: {
                        var pf = objDirObject.backPath(objFolderView.browsingSelectedPath);
                        if(objFolderView.selectedRoot === objFolderView.browsingSelectedPath){
                            objFolderView.goHome();
                        }
                        else{
                            objFolderView.goToPath(pf);
                        }
                    }
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            var pf = objDirObject.backPath(objFolderView.browsingSelectedPath);
                            if(objFolderView.selectedRoot === objFolderView.browsingSelectedPath){
                                objFolderView.goHome();
                            }
                            else{
                                objFolderView.goToPath(pf);
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

            GridView{
                id: objFolderViewScreenView
                activeFocusOnTab: true
                cellWidth: parent.width
                cellHeight: 50
                clip: true
                anchors.top: objFolderViewScreenTopToolBar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: objFolderViewScreenBottomToolBar.top
                model: objFolderScreenModel
                currentIndex: 0
                onCurrentIndexChanged: {
                    if(currentIndex===-1) return;
                    var p = objFolderScreenModel.get(currentIndex);
                    if(p){
                        var t = objDirObject.isWritable(p.path);
                        if(t){
                            objFolderViewScreen.selectFolderEnabled = true;
                        }
                        else{
                            objFolderViewScreen.selectFolderEnabled = false;
                        }
                    }
                }
                delegate: Rectangle{
                    width: objFolderViewScreenView.cellWidth
                    height: objFolderViewScreenView.cellHeight
                    color: objFolderViewScreenView.currentIndex === index?ZBTheme.itemSelectedBackgroundColor:ZBTheme.itemBackgroundColor
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

                            if(objDirObject.isWritable(path)){
                                objFolderViewScreen.selectFolderEnabled = true;
                            }
                            else{
                                objFolderViewScreen.selectFolderEnabled = false;
                            }
                        }
                        onDoubleClicked: {
                            objFolderViewScreenView.focus = true;
                            objFolderViewScreenView.currentIndex = index;
                            objFolderView.goToPath(path);
                        }
                    }

                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            if(objFolderView.browsingSelectedPath !== path){
                                objFolderView.oldbrowsingSelectedPath = objFolderView.browsingSelectedPath;
                                objFolderView.browsingSelectedPath = path;
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

            Rectangle{
                id: objFolderViewScreenBottomToolBar
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 50
                color: ZBTheme.primary;

                Button{
                    id: objSelectButton
                    text: "SELECT"
                    enabled: objFolderViewScreen.selectFolderEnabled
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.bottom: parent.bottom
                    focusReason: Qt.TabFocus

                    Material.background: ZBTheme.secondary
                    Material.primary: ZBTheme.primary
                    Material.accent: ZBTheme.accent
                    Material.theme: ZBTheme.theme === "dark"?Material.Dark:Material.Light

                    onClicked: {
                        if(objFolderViewScreenView.currentIndex !== -1){
                            objFolderView.choosenPath = objFolderScreenModel.get(objFolderViewScreenView.currentIndex).path;
                            objFolderView.selectedPath(objFolderView.choosenPath);
                        }
                        else{
                            objFolderView.choosenPath = objFolderView.browsingSelectedPath;
                            objFolderView.selectedPath(objFolderView.choosenPath);
                        }

                    }
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            if(objFolderViewScreenView.currentIndex !== -1){
                                objFolderView.choosenPath = objFolderScreenModel.get(objFolderViewScreenView.currentIndex).path;
                                objFolderView.selectedPath(objFolderView.choosenPath);
                            }
                            else{
                                objFolderView.choosenPath = objFolderView.browsingSelectedPath;
                                objFolderView.selectedPath(objFolderView.choosenPath);
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
