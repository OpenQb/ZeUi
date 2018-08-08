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
    signal closeClicked();

    QbSettings{
        id: objSettings
        name: "ZFolderView"
        property alias browsingSelectedPath: objFolderView.browsingSelectedPath
        property alias oldbrowsingSelectedPath: objFolderView.oldbrowsingSelectedPath
        property alias selectedRoot: objFolderView.selectedRoot
    }

    function refresh(){
        //console.log("REFRESH");
        if(browsingSelectedPath!==""){
            if(objDirObject.isWritable(browsingSelectedPath)){
                objFolderViewScreen.newFolderEnabled = true;
            }
            else{
                objFolderViewScreen.newFolderEnabled = false;
            }

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
        else{
            //console.log("Nothing Found");
            objFolderScreenModel.clear();
        }
    }

    onBrowsingSelectedPathChanged: {
        refresh();
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
        objSettings.setAppId(appUi.appId);
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

            if(objDirObject.exists("/storage/sdcard0")){
                objHomeScreenModel.append({"name":"sdcard0","path":"/storage/sdcard0"})
            }
            if(objDirObject.exists("/storage/sdcard1")){
                objHomeScreenModel.append({"name":"sdcard1","path":"/storage/sdcard1"})
            }
            if(objDirObject.exists("/storage/usbstorage0")){
                objHomeScreenModel.append({"name":"usbstorage0","path":"/storage/usbstorage0"})
            }
            if(objDirObject.exists("/storage/usbdisk0")){
                objHomeScreenModel.append({"name":"usbdisk0","path":"/storage/usbdisk0"})
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

            Rectangle{
                id: objHomeScreenTopToolBar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 50
                color: ZBTheme.primary

                Text{
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: objHomeScreenTopToolBar.left
                    anchors.leftMargin: 5
                    anchors.right: objHomeScreenCloseButton.left
                    verticalAlignment: Text.AlignVCenter
                    //horizontalAlignment: Text.AlignHCenter
                    text: "Select a folder"
                    color: ZBTheme.metaTheme.isDark(ZBTheme.primary)?"white":"black"
                    elide: Text.ElideLeft
                    font.pixelSize: 15
                }

                RoundButton{
                    id: objHomeScreenCloseButton
                    focusReason: Qt.StrongFocus
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    Material.background: ZBTheme.secondary
                    Material.primary: ZBTheme.primary
                    Material.accent: ZBTheme.accent
                    Material.theme: ZBTheme.theme === "dark"?Material.Dark:Material.Light
                    text: QbMF3.icon("mf-close")
                    font.family: QbMF3.family
                    font.pixelSize: parent.height*0.5
                    onPressed: {
                        objFolderView.closeClicked();
                    }
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            objFolderView.closeClicked();

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
                id: objHomeScreenView
                activeFocusOnTab: true
                cellWidth: parent.width
                cellHeight: 50
                anchors.top: objHomeScreenTopToolBar.bottom
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
            property bool newFolderEnabled: false;
            property Item newFolderWindow: null

            Component{
                id: compNewFolderWindow
                Rectangle{
                    id: objNfwRoot
                    anchors.fill: parent
                    color: ZBTheme.mCT("black",160)
                    visible: true
                    activeFocusOnTab: false
                    Component.onCompleted: {
                        objNfwFolderInput.forceActiveFocus();
                        objNfwFolderInput.focus = true;
                    }
                    MouseArea{
                        anchors.fill: parent
                        preventStealing: true
                        hoverEnabled: true
                    }
                    Keys.onPressed: {
                        event.accepted = true;
                    }
                    Keys.onReleased: {
                        event.accepted = true;
                    }

                    Rectangle{
                        id: objNfwWindow
                        width: Math.min(parent.width*0.90,300)
                        height: 150
                        color: ZBTheme.background
                        radius: 5
                        x: (parent.width - width)/2.0
                        y: 50
                        activeFocusOnTab: false
                        property bool isError: false

                        Rectangle{
                            id: objNfwTitle
                            anchors.top: parent.top
                            height: 50
                            anchors.left: parent.left
                            anchors.right: parent.right
                            color: ZBTheme.primary
                            Text{
                                anchors.fill: parent
                                anchors.leftMargin: 5
                                text: "New Folder"
                                font.pixelSize: 15
                                verticalAlignment: Text.AlignVCenter
                                color: ZBTheme.metaTheme.isDark(ZBTheme.primary)?"white":"black"
                            }
                        }

                        Rectangle{
                            visible: !objNfwWindow.isError
                            anchors.top: objNfwTitle.bottom
                            anchors.bottom: objNfwCancelButton.top
                            anchors.right: parent.right
                            anchors.left: parent.left
                            color: ZBTheme.background
                            TextInput{
                                id: objNfwFolderInput
                                anchors.fill: parent
                                anchors.leftMargin: 5
                                anchors.rightMargin: 5
                                activeFocusOnTab: true
                                visible: !objNfwWindow.isError
                                verticalAlignment: TextInput.AlignVCenter
                                font.family: ZBTheme.defaultFontFamily
                                font.pixelSize: 20
                                font.bold: true
                                activeFocusOnPress: true
                                selectionColor: "lightblue"
                                selectedTextColor: "black"
                                color: ZBTheme.metaTheme.isDark(ZBTheme.background)?"white":"black"
                            }
                        }

                        Button{
                            id: objNfwCancelButton
                            visible: !objNfwWindow.isError
                            text: "Cancel"
                            focusPolicy: Qt.StrongFocus
                            anchors.bottom: parent.bottom
                            anchors.right: objNfwOkButton.left
                            anchors.rightMargin: 5
                            Material.background: ZBTheme.secondary
                            Material.primary: ZBTheme.primary
                            Material.accent: ZBTheme.accent
                            Material.theme: ZBTheme.theme === "dark"?Material.Dark:Material.Light
                            onPressed: {
                                objFolderViewScreen.closeNewFolderWindow()
                            }
                            Keys.onPressed: {
                                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                                    event.accepted = true;
                                    objFolderViewScreen.closeNewFolderWindow();
                                }
                            }
                            Keys.onReleased: {
                                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                                    event.accepted = true;
                                }
                            }
                        }

                        Button{
                            Material.background: ZBTheme.secondary
                            Material.primary: ZBTheme.primary
                            Material.accent: ZBTheme.accent
                            Material.theme: ZBTheme.theme === "dark"?Material.Dark:Material.Light
                            visible: !objNfwWindow.isError
                            id: objNfwOkButton
                            text: "Ok"
                            focusPolicy: Qt.StrongFocus
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            onPressed: {
                                objNfwOkButton.createFolder(objNfwFolderInput.text)
                            }

                            function createFolder(name){
                                if(name!==""){
                                    if(objDirObject.exists(name)){
                                        objNfwWindow.isError = true;
                                    }
                                    else{
                                        objDirObject.mkdir(name);
                                        objFolderView.refresh();
                                        objFolderViewScreen.closeNewFolderWindow();
                                    }
                                }
                            }

                            Keys.onPressed: {
                                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                                    event.accepted = true;
                                    objNfwOkButton.createFolder(objNfwFolderInput.text)
                                }
                            }

                            Keys.onReleased: {
                                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                                    event.accepted = true;
                                }
                            }
                        }

                        Text{
                            id: objNfwErrorMsg
                            visible: objNfwWindow.isError
                            text: "Folder already exists."
                            anchors.top: objNfwTitle.bottom
                            anchors.bottom: objNfwCloseButton.top
                            anchors.right: parent.right
                            anchors.left: parent.left
                            font.pixelSize: 15
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: ZBTheme.metaTheme.isDark(ZBTheme.primary)?"white":"black"
                        }

                        Button{
                            id: objNfwCloseButton
                            visible: objNfwWindow.isError
                            text: "Ok"
                            focusPolicy: Qt.StrongFocus
                            anchors.bottom: parent.bottom
                            x: (parent.width - width)/2.0
                            Material.background: ZBTheme.secondary
                            Material.primary: ZBTheme.primary
                            Material.accent: ZBTheme.accent
                            Material.theme: ZBTheme.theme === "dark"?Material.Dark:Material.Light
                            onPressed: {
                                objFolderViewScreen.closeNewFolderWindow()
                            }
                            Keys.onPressed: {
                                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                                    event.accepted = true;
                                    objFolderViewScreen.closeNewFolderWindow()
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

            function openNewFolderWindow(){
                if(objFolderViewScreen.newFolderWindow === null){
                    objFolderViewScreen.enabled = false;
                    objFolderViewScreen.newFolderWindow = compNewFolderWindow.createObject(objFolderView)
                }
                else{
                    closeNewFolderWindow();
                }
            }

            function closeNewFolderWindow(){
                if(objFolderViewScreen.newFolderWindow){
                    try{
                        objFolderViewScreen.newFolderWindow.destroy();
                    }
                    catch(e){
                    }
                    objFolderViewScreen.newFolderWindow = null;
                    objFolderViewScreen.enabled = true;
                }
            }



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
                    visible: objFolderView.selectedRoot !== objFolderView.browsingSelectedPath
                    onPressed: {
                        if(objFolderView.selectedRoot === objFolderView.browsingSelectedPath){
                            objFolderView.goHome();
                        }
                        else{
                            var pf = objDirObject.backPath(objFolderView.browsingSelectedPath);
                            objFolderView.goToPath(pf);
                        }
                    }
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            if(objFolderView.selectedRoot === objFolderView.browsingSelectedPath){
                                objFolderView.goHome();
                            }
                            else{
                                var pf = objDirObject.backPath(objFolderView.browsingSelectedPath);
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

                Text{
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: objFolderViewUpButton.right
                    anchors.right: objFolderViewCloseButton.left
                    verticalAlignment: Text.AlignVCenter
                    //horizontalAlignment: Text.AlignHCenter
                    text: objFolderView.browsingSelectedPath
                    color: ZBTheme.metaTheme.isDark(ZBTheme.primary)?"white":"black"
                    elide: Text.ElideLeft
                    font.pixelSize: 15
                }

                RoundButton{
                    id: objFolderViewCloseButton
                    focusReason: Qt.StrongFocus
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    Material.background: ZBTheme.secondary
                    Material.primary: ZBTheme.primary
                    Material.accent: ZBTheme.accent
                    Material.theme: ZBTheme.theme === "dark"?Material.Dark:Material.Light
                    text: QbMF3.icon("mf-close")
                    font.family: QbMF3.family
                    font.pixelSize: parent.height*0.5
                    onPressed: {
                        objFolderView.closeClicked();
                    }
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            objFolderView.closeClicked();

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
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space){
                            event.accepted = true;
                            if(objFolderView.browsingSelectedPath !== path){
                                objFolderView.oldbrowsingSelectedPath = objFolderView.browsingSelectedPath;
                                objFolderView.browsingSelectedPath = path;
                            }
                        }
                    }
                    Keys.onReleased: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space){
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
                    id: objNewFolderButton
                    enabled: objFolderViewScreen.newFolderEnabled
                    text: "New Folder"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.bottom: parent.bottom
                    focusReason: Qt.TabFocus

                    Material.background: ZBTheme.secondary
                    Material.primary: ZBTheme.primary
                    Material.accent: ZBTheme.accent
                    Material.theme: ZBTheme.theme === "dark"?Material.Dark:Material.Light

                    onClicked: {
                        objFolderViewScreen.openNewFolderWindow();
                    }
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                            objFolderViewScreen.openNewFolderWindow();
                        }
                    }
                    Keys.onReleased: {
                        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                            event.accepted = true;
                        }
                    }
                }

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
        }//folderView
    }//background


}
