import Qb 1.0
import Qb.Core 1.0
import Qb.Android 1.0

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "./../base"
import "./../ui"


ZBAppUi{
    id: objAppUi

    property string dockLogo: ""
    signal logoClicked();

    property alias dockView: objDockView
    property alias pageView: objPageView

    Keys.forwardTo: [objDockView,objPageView]
    Keys.priority: Keys.BeforeItem

    Keys.onPressed: {
        //console.log("Pressed event");
    }
    Keys.onReleased: {
        //console.log("Released event");
    }

    Component.onCompleted: {
        objDockView.open();
        if(objAppUi.androidFullScreen){
            enableAndroidFullScreen();
        }
        else{
            disableAndroidFullScreen();
        }
    }

    onAppVisible: {
        if(objAppUi.androidFullScreen){
            enableAndroidFullScreen();
        }
        else{
            disableAndroidFullScreen();
        }
    }

    Connections{
        target: Qt.inputMethod
        onVisibleChanged:{
            if(!Qt.inputMethod.visible){
                if(objAppUi.androidFullScreen){
                    enableAndroidFullScreen();
                }
                else{
                    disableAndroidFullScreen();
                }
            }
            else{
                disableAndroidFullScreen();
            }
        }

        onKeyboardRectangleChanged: {
            if (Qt.inputMethod.visible) {
            }
        }
    }


    onPageRemovedIndex: {
        removeRunningPage(index);
    }

    onPageAdded: {
        addRunningPage(title)
    }

    QbAndroidExtras{
        id: objAndroidExtras
    }

    function dpscale(num){
        return QbCoreOne.scale(num);
    }

    /** Android related things **/
    function showAndroidStatusBar(){
        if(Qt.platform.os !== "android") return;
        objTopBlock.height = objAppUi.dpscale(25);
        objAndroidExtras.showSystemUi();
    }

    function hideAndroidStatusBar(){
        if(Qt.platform.os !== "android") return;
        objAndroidExtras.hideSystemUi();
        objTopBlock.height = 0;
    }

    function enableAndroidFullScreen(){
        if(Qt.platform.os !== "android") return;
        objAndroidExtras.enableFullScreen();
        objTopBlock.height = 0;
    }

    function disableAndroidFullScreen(){
        if(Qt.platform.os !== "android") return;
        objAndroidExtras.disableFullScreen();
        objTopBlock.height = objAppUi.dpscale(25);
    }

    function resetAndroidFullScreenState(){
        if(objAppUi.androidFullScreen){
            objAppUi.enableAndroidFullScreen();
        }
        else{
            objAppUi.disableAndroidFullScreen();
        }
    }
    /**/

    function addRunningPage(title){
        objPageListModel.append({"title":title})
    }

    function removeRunningPage(index){
        if(index>-1&&index<objPageListModel.count){
            var title = objPageListModel.get(index).title;
            objPageListModel.remove(index);
            objAppUi.pageRemovedInfo(index,title);
        }
    }

    function addPage(page,jsobject){
        ZBLib.addPage(objAppUi,objPageView,objAppUi.absoluteURL(page),jsobject);
    }
    function addDPage(page,jsobject){
        ZBLib.directAdd(objAppUi,objPageView,objAppUi.absoluteURL(page),jsobject);
    }

    function addComponent(comp,jsobject){
        ZBLib.addComponent(objAppUi,objPageView,comp,jsobject);
    }

    function closePage(index){
        ZBLib.removePage(objAppUi,objPageView,index);
    }

    function closeCurrentPage(){
        ZBLib.removePage(objAppUi,objPageView,objPageView.currentIndex);
    }

    function getPage(index){
        return objPageView.getPage(index);
    }

    function changePage(index){
        objPageView.setCurrentIndex(index);
    }

    function getCurrentPageIndex(){
        return objPageView.currentIndex;
    }

    ListModel{
        id: objPageListModel
    }

    Rectangle{
        id: objTopBlock
        height: 0
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: objAppUi.mCT("black",200)
    }

    ZSideDockSmartView{
        id: objDockView
        anchors.top: objTopBlock.bottom
        height: parent.height
        dockLogo: objAppUi.dockLogo
        onLogoClicked: {
            objAppUi.logoClicked();
        }
        onExitClicked: {
            objAppUi.close();
        }

        dockItemModel: null
        pageItemModel: objPageListModel
        onSelectedPageItem: {
            objPageView.setCurrentIndex(index);
        }
        onSelectedByMouse: {
            var cPage = objPageView.getPage(objPageView.currentIndex);
            if(cPage) cPage.selectedByMouse();
        }
        onSelectedItem: {
            var cPage = objPageView.getPage(objPageView.currentIndex);
            if(cPage) cPage.selectedContextDockItem(title,index,x+objDockView.width,y+objDockView.dockLogoHeight+objDockView.dockItemHeight);
        }


        //KeyNavigation.tab: objPageView
        //KeyNavigation.priority: KeyNavigation.BeforeItem
    }


    SwipeView{
        id: objPageView
        anchors.top: objTopBlock.bottom
        anchors.left: objDockView.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        //KeyNavigation.tab: objDockView
        //KeyNavigation.priority: KeyNavigation.BeforeItem
        interactive: false
        focus:false
        activeFocusOnTab: false
        property int nextIndex: -1;

        Timer{
            id: objTimer
            interval: 500
            repeat: false
            onTriggered: {
                objTimer.stop();
                objPageView.setCurrentPage(objPageView.nextIndex);
            }
        }

        function getPage(index){
            return objPageView.itemAt(index);
        }

        function insertPage(index,item){
            objPageView.currentIndex = -1;
            objPageView.insertItem(index,item);
            objPageView.nextIndex = index;
            objTimer.start();
        }

        function setCurrentPage(index){
            objPageView.setCurrentIndex(index)
        }

        function takePage(index){
            return objPageView.takeItem(index);
        }

        function removePage(index){
            if(objPageView.count>0){
                try{
                    var item = objPageView.takePage(index);
                    item.visible = false;
                    item.focus = false;
                    item.pageClosing();
                    delete item;
                    return true;
                }
                catch(e){
                    return false;
                }
            }
            return false;
        }

        onFocusChanged: {
            if(objPageView.currentItem){
                if(focus){
                    objPageView.currentItem.forceActiveFocus();
                    objPageView.currentItem.focus = true;
                }
                else{
                    objPageView.currentItem.focus = false;
                }
            }
        }

        onCurrentIndexChanged: {
            if(currentIndex !==-1){
                var cPage = objPageView.getPage(objPageView.currentIndex);
                if(cPage) {
                    //cPage.anchors.fill=objPageView;
                    if(cPage.contextDock){
                        objDockView.dockItemModel = cPage.contextDock
                        objDockView.dockItemCurrentIndex = -1;
                    }
                    else{
                        objDockView.dockItemModel = null;
                        objDockView.dockItemCurrentIndex = -1;
                    }
                }
            }
        }
    }
}
