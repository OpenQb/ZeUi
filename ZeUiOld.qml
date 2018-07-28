import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

import Qb 1.0
import QbEx 1.0
import Qb.Core 1.0
import Qb.Android 1.0

import "./old"
import "old/app.js" as App

QbApp {
    id: objAppUi
    minimumHeight: 550
    minimumWidth: 500
    property string gridState: "xs"
    property bool isAddingPage: false;
    property int leftSideBarWidth: 0
    property int rightSideBarWidth: 0
    property string appLogo:"";
    property color appLogoHighlightColor: "white";
    property bool leftDockAlwaysVisible: true
    property color dockColor: "black"
    property color dockLogoColor: "black"

    property var appJS: App
    clip:true

    onWidthChanged: {
        appResized();
    }

    onAppClosing: {
    }

    onAppVisible: {
        App.disableAndroidFullScreen();
    }

    Keys.forwardTo: [objShortcut,objContentPlaceHolder]

    Item{
        id: objShortcut
        Shortcut {
            sequence: "Shift+H"
            enabled: true
            onActivated: {
                if(objLeftDock.isOpened){
                    if(!objAppUi.leftDockAlwaysVisible){
                        objLeftDock.close();
                    }
                }
                else{
                    if(!objAppUi.leftDockAlwaysVisible){
                        objLeftDock.open();
                    }
                }
            }
        }
    }

    Connections{
        target: Qt.inputMethod
        onVisibleChanged:{
            if(!Qt.inputMethod.visible){
                //App.hideAndroidStatusBar();
            }
            else{
                //App.showAndroidStatusBar();
            }
        }

        onKeyboardRectangleChanged: {
            if (Qt.inputMethod.visible) {
            }
        }
    }

    Component.onCompleted: {
        if(objAppUi.leftDockAlwaysVisible){
            objLeftDock.open();
        }

        App.objAppTheme = objAppTheme;
        App.objPackageReader = objPackageReader;
        App.objAndroidExtras = objAndroidExtras;

        App.objTopToolBar = objTopToolBar;
        App.appToolBarLoader = objTopToolBar.appToolBar;
        App.appStatusBarLoader = objTopToolBar.appStatusBar;

        App.objMainView = objMainView;

        App.objBottomToolBar = objBottomToolBar;
        App.appBottomBarLoader = objBottomToolBar.appBottomBar;

        App.objLeftSideBar = objLeftSideBar;
        App.objRightSideBar = objRightSideBar;

        App.appLeftSideBarLoader = objLeftSideBar.appSideBar;
        App.appRightSideBarLoader = objRightSideBar.appSideBar;

        App.objLeftDock = objLeftDock;

        App.setup(objAppUi);
        App.disableAndroidFullScreen();
        hideLoadingScreen();
    }

    function showLoadingScreen(){
        objLoadingScreen.visible = true;
    }

    function hideLoadingScreen(){
        objLoadingScreen.visible = false;
    }

    Rectangle{
        id: objLoadingScreen
        color: objAppTheme.changeTransparency("black",200)
        anchors.fill: parent
        visible: true
        z: 99999

        FishSpinner{
            width: QbCoreOne.scale(50)
            height: QbCoreOne.scale(50)
            anchors.centerIn: parent
            useDouble: true
        }

        MouseArea{
            anchors.fill: parent
            preventStealing: true
        }
    }



    QbMetaTheme{
        id: objAppTheme
    }

    QbAppPackageReader{
        id: objPackageReader
    }

    QbAndroidExtras{
        id: objAndroidExtras
    }

    LeftDock{
        id: objLeftDock
    }

    Pane{
        id: objContentPlaceHolder

        topPadding: 0
        bottomPadding: 0
        leftPadding: 0
        rightPadding: 0
        focus: true

        Material.primary: objAppTheme.primary
        Material.accent: objAppTheme.accent
        Material.background: objAppTheme.background
        Material.foreground: objAppTheme.foreground
        Material.theme: objAppTheme.theme === "dark"?Material.Dark:Material.Light

        anchors.left: objAppUi.leftDockAlwaysVisible?objLeftDock.right:parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        clip: true

        TopToolBar{
            id: objTopToolBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            focus: true
            height: QbCoreOne.scale(50)
            appStatusBarHeight: 0
            appLogo: objAppUi.appLogo
            appPrevButtonVisible: objMainView.currentIndex>0
            appNextButtonVisible: objMainView.currentIndex<(objMainView.count-1)
            appCloseButtonVisible: objMainView.currentIndex>0 && objMainView.currentItem.isClosable
            z: 10000

            onLogoClicked: {
                objLeftDock.open();
            }

            onPrevClicked: {
                prevPage();
            }
            onNextClicked: {
                nextPage();
            }
            onCloseClicked: {
                popPage();
            }

            onLeftSideBarClicked: {
                toggleLeftSideBar();
            }
            onRightSideBarClicked: {
                toggleRightSideBar();
            }
        }

        SideBar{
            id: objLeftSideBar
            anchors.top: objTopToolBar.bottom
            anchors.bottom: objBottomToolBar.top
            anchors.left: parent.left
            width: 0
            z: 10000
            onWidthChanged: {
                if(objAppUi.gridState === "md" || objAppUi.gridState === "lg" ||objAppUi.gridState === "xl"){
                    if(objLeftSideBar.width === 0){
                        objMainView.anchors.left = objTopToolBar.left;
                    }
                    else{
                        objMainView.anchors.left = objLeftSideBar.right;
                    }
                }
                else{
                    objMainView.anchors.left = objTopToolBar.left;
                }
            }
            Behavior on width {
                NumberAnimation { duration: 300;easing.type: Easing.OutCubic }
            }
        }

        SideBar{
            id: objRightSideBar
            anchors.top: objTopToolBar.bottom
            anchors.bottom: objBottomToolBar.top
            anchors.right: parent.right
            width: 0
            z: 10000
            onWidthChanged: {
                if(objAppUi.gridState === "lg" ||objAppUi.gridState === "xl"){
                    if(objRightSideBar.width === 0){
                        objMainView.anchors.right = objTopToolBar.right;
                    }
                    else{
                        objMainView.anchors.right = objRightSideBar.left;
                    }
                }
                else{
                    objMainView.anchors.right = objTopToolBar.right;
                }
            }

            Behavior on width {
                NumberAnimation { duration: 300;easing.type: Easing.OutCubic }
            }
        }

        Item{
            id: objMainView

            property int count: 0
            property int oldIndex: -1
            property int currentIndex: -1
            property var itemList: []
            property Item currentItem: null

            anchors.top: objTopToolBar.bottom
            anchors.bottom: objBottomToolBar.top
            anchors.left: parent.left
            anchors.right: parent.right
            clip: true

            function itemAt(index){
                try{
                    return objMainView.itemList[index];
                }
                catch(e){
                }
            }

            function setCurrentIndex(index){
                objMainView.currentItem = objMainView.itemList[index];
                objMainView.currentIndex = index;
            }

            function insertItem(index,item){
                objMainView.itemList.splice(index,0,item);
                objMainView.count = objMainView.itemList.length;
                objMainView.currentItem = item;
            }

            function takeItem(index){
                var i = objMainView.itemList[index];
                objMainView.itemList.splice(index,1);
                objMainView.count = objMainView.itemList.length;
                if(index === currentIndex){
                    var ni = --index;
                    if(ni<0) ni = 0;
                    objMainView.currentItem = objMainView.itemList[ni];
                    objMainView.currentIndex = ni;
                }
                return i;
            }


            onCurrentIndexChanged: {
                if(objMainView.oldIndex!=objMainView.currentIndex && objMainView.oldIndex !=-1){
                    try{
                        var i = objMainView.itemAt(objMainView.oldIndex);
                        i.visible = false;
                        i.pageHidden();
                    }
                    catch(e){
                        console.log("Exception:"+e)
                    }
                }

                try{
                    setupPage2(objMainView.currentItem);

                    objMainView.currentItem.anchors.left = objMainView.left;
                    objMainView.currentItem.anchors.right = objMainView.right;
                    objMainView.currentItem.anchors.top = objMainView.top;
                    objMainView.currentItem.anchors.bottom = objMainView.bottom;

                    objMainView.currentItem.pageOpened();
                }
                catch(e){
                }
            }
        }



        BottomToolBar{
            id: objBottomToolBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: objBottomToolBar.hasBottomBar?QbCoreOne.scale(10):0
            z: 10000
        }
    }


    function appResized(){

        var w = objAppUi.width;
        if(w<576){
            objAppUi.gridState = "xs";
        }
        else if(w>=576 && w<768){
            objAppUi.gridState = "sm";
        }
        else if(w>=768 && w<960){
            objAppUi.gridState = "md";
        }
        else if(w>=960 && w<1200){
            objAppUi.gridState = "lg";
        }
        else{
            objAppUi.gridState = "xl";
        }

        objTopToolBar.appLeftSiderBarVisible = objLeftSideBar.hasSideBar;
        objTopToolBar.appRightSiderBarVisible = objRightSideBar.hasSideBar;

        if(objAppUi.gridState === "xs" || objAppUi.gridState === "sm"){
            if(objLeftSideBar.hasSideBar){
                objAppUi.leftSideBarWidth = QbCoreOne.scale(200);
                if(objLeftSideBar.width!=0){
                    objLeftSideBar.width = objAppUi.leftSideBarWidth;
                }
            }
            else{
                objAppUi.leftSideBarWidth = 0;
                objLeftSideBar.width = 0;
            }

            if(objRightSideBar.hasSideBar){
                objAppUi.rightSideBarWidth = QbCoreOne.scale(200);
                if(objRightSideBar.width!=0){
                    objRightSideBar.width = objAppUi.rightSideBarWidth;
                }
            }
            else{
                objAppUi.rightSideBarWidth = 0;
                objRightSideBar.width = 0;
            }

            objMainView.anchors.left = objTopToolBar.left;
            objMainView.anchors.right = objTopToolBar.right;
        }

        else if(objAppUi.gridState === "md"){
            if(objLeftSideBar.hasSideBar){
                objAppUi.leftSideBarWidth = QbCoreOne.scale(200);
                if(objLeftSideBar.width!=0){
                    objLeftSideBar.width = objAppUi.leftSideBarWidth;
                }
                objMainView.anchors.left = objLeftSideBar.right;
            }
            else{
                objLeftSideBar.width = 0;
                objAppUi.leftSideBarWidth = 0;
                objMainView.anchors.left = objTopToolBar.left;
            }

            if(objRightSideBar.hasSideBar){
                objAppUi.rightSideBarWidth = QbCoreOne.scale(200);
                if(objRightSideBar.width!=0){
                    objRightSideBar.width = objAppUi.rightSideBarWidth;
                }
            }
            else{
                objRightSideBar.width = 0;
                objAppUi.rightSideBarWidth = 0;
            }

            objMainView.anchors.right = objTopToolBar.right;
        }

        else if(objAppUi.gridState === "lg" || objAppUi.gridState === "xl"){
            if(objLeftSideBar.hasSideBar){
                objAppUi.leftSideBarWidth = QbCoreOne.scale(250);
                objMainView.anchors.left = objLeftSideBar.right;
                if(objLeftSideBar.width!=0){
                    objLeftSideBar.width = objAppUi.leftSideBarWidth;
                }
            }
            else{
                objLeftSideBar.width = 0;
                objAppUi.leftSideBarWidth = 0;
                objMainView.anchors.left = objTopToolBar.left;
            }

            if(objRightSideBar.hasSideBar){
                objAppUi.rightSideBarWidth = QbCoreOne.scale(250);
                objMainView.anchors.right = objRightSideBar.left;
                if(objRightSideBar.width!=0){
                    objRightSideBar.width = objAppUi.rightSideBarWidth;
                }
            }
            else{
                objRightSideBar.width = 0;
                objAppUi.rightSideBarWidth = 0;
                objMainView.anchors.right = objTopToolBar.right;
            }
        }
    }

    function pushPage(page,jsobject){
        if(!objAppUi.isAddingPage){
            objAppUi.isAddingPage = true;
            try{
                if(QbCoreOne.isSingleWindowMode() === true || QbCoreOne.isWebglPlatofrm() === true){
                    pushPageDirect(objAppUi.absoluteURL(page),jsobject);
                }
                else{
                    pushPageIncubate(objAppUi.absoluteURL(page),jsobject);
                }
            }
            catch(e){
                pushPageIncubate(page,jsobject);
            }
        }
    }

    function addRemotePage(page,jsobject){
        objAppUi.isAddingPage = true;
        try{
            pushPageIncubate(page,jsobject)
        }
        catch(e){
            console.log(e);
        }
    }

    function pushPageDirect(page,jsobject){
        showLoadingScreen();
        var component = Qt.createComponent(page);
        if(component.status === Component.Ready){
            var nobj;
            if(jsobject !== undefined){
                nobj = component.createObject(objMainView,jsobject);
            }
            else{
                nobj = component.createObject(objMainView);
            }

            if(nobj){
                setupPage(nobj);
            }
        }
        hideLoadingScreen();
    }

    function pushPageIncubate(page,jsobject){
        showLoadingScreen();
        var component = Qt.createComponent(page);
        var incubator = null;
        if(component.status === Component.Ready){
            if(jsobject !== undefined){
                incubator = component.incubateObject(objMainView,jsobject);
            }
            else{
                incubator = component.incubateObject(objMainView);
            }
        }

        if(incubator !== null){
            if (incubator.status !== Component.Ready) {
                incubator.onStatusChanged = function(status) {
                    if (status === Component.Ready) {
                        setupPage(incubator.object);
                    }
                    else if(status === Component.Error){
                        objAppUi.isAddingPage = false;
                        console.log("Error on adding page: "+component.errorString());
                    }
                    hideLoadingScreen();
                }
            }
            else {
                setupPage(incubator.object);
                hideLoadingScreen();
            }
        }
        else{
            objAppUi.isAddingPage = false;
            console.log("Error on adding page: "+component.errorString());
            hideLoadingScreen();
        }
    }

    function popPage(){
        if(objMainView.count>1){
            try{
                objMainView.oldIndex = -1;
                objLeftDock.removeRunningPage(objMainView.currentIndex);
                var item = objMainView.takeItem(objMainView.currentIndex);
                item.visible = false;
                item.pageClosing();
                delete item;
            }
            catch(e){
            }
        }
    }

    function removePage(index){
        if(objMainView.count>1){
            try{
                objMainView.oldIndex = -1;
                objLeftDock.removeRunningPage(index);
                var item = objMainView.takeItem(index);
                item.visible = false;
                item.pageClosing();
                delete item;
            }
            catch(e){
            }
        }
    }

    function prevPage(){
        if(objMainView.currentIndex>0){
            objMainView.oldIndex = objMainView.currentIndex;
            objMainView.setCurrentIndex(objMainView.currentIndex-1);
        }
    }
    function nextPage(){
        if(objMainView.currentIndex<(objMainView.count-1)){
            objMainView.oldIndex = objMainView.currentIndex;
            objMainView.setCurrentIndex(objMainView.currentIndex+1);
        }
    }

    function toggleLeftSideBar(){
        if(objLeftSideBar.width === objAppUi.leftSideBarWidth){
            objLeftSideBar.width = 0;
        }
        else{
            objLeftSideBar.width = objAppUi.leftSideBarWidth;
        }
    }

    function showLeftSideBar(){
        objLeftSideBar.width = objAppUi.leftSideBarWidth;
    }

    function hideLeftSideBar(){
        objLeftSideBar.width = 0;
    }

    function toggleRightSideBar(){
        if(objRightSideBar.width === objAppUi.rightSideBarWidth){
            objRightSideBar.width = 0;
        }
        else{
            objRightSideBar.width = objAppUi.rightSideBarWidth;
        }
    }

    function showRightSideBar(){
        objRightSideBar.width = objAppUi.rightSideBarWidth;
    }

    function hideRightSideBar(){
        objRightSideBar.width = 0;
    }

    function setupPage(objPage){
        objMainView.oldIndex = objMainView.currentIndex;
        var cpage = objPage;
        objLeftDock.addRunningPage(cpage.title);

        objTopToolBar.add(cpage.topBar);
        objBottomToolBar.add(cpage.bottomBar);
        objLeftSideBar.add(cpage.leftBar);
        objRightSideBar.add(cpage.rightBar);

        objMainView.insertItem(objMainView.count,cpage);
        cpage.visible = true;
        objMainView.currentIndex = objMainView.count-1;

        appResized();
        hideLeftSideBar();
        hideRightSideBar();
        objTopToolBar.resetAnimationState();
        objAppUi.isAddingPage = false;
    }

    function setupPage2(objPage){
        var cpage = objPage;
        cpage.visible = true;

        objTopToolBar.add(cpage.topBar);
        objBottomToolBar.add(cpage.bottomBar);
        objLeftSideBar.add(cpage.leftBar);
        objRightSideBar.add(cpage.rightBar);

        appResized();
        hideLeftSideBar();
        hideRightSideBar();
        objTopToolBar.resetAnimationState();
    }

    function  getCurrentPage(){
        return objMainView.currentItem;
    }

    function dpscale(num){
        return QbCoreOne.scale(num);
    }
}
