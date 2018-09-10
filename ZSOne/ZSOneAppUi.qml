import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import Qb.Android 1.0

import "./../base"
import "./../ui"


ZBAppUi{
    id: objAppUi

    property string dockLogo: ""
    signal logoClicked();

    property alias dockView: objDockView
    property alias pageView: objPageView

    Keys.forwardTo: [objDockView,objPageView]

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
            objPageListModel.remove(index);
        }
    }

    function addPage(page,jsobject){
        ZBLib.addPage(objAppUi,objPageView,objAppUi.absoluteURL(page),jsobject);
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
        onSelectedItem: {
            var cPage = objPageView.getPage(objPageView.currentIndex);
            if(cPage) cPage.selectedContextDockItem(title,index,x+objDockView.width,y+objDockView.dockLogoHeight+objDockView.dockItemHeight);
        }


        //KeyNavigation.tab: objPageView
        //KeyNavigation.priority: KeyNavigation.BeforeItem
    }


    ZBPageView{
        id: objPageView
        anchors.top: objTopBlock.bottom
        anchors.left: objDockView.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        //KeyNavigation.tab: objDockView
        //KeyNavigation.priority: KeyNavigation.BeforeItem

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
        MouseArea{
            anchors.fill: parent
            preventStealing: true
            onPressed: {
                objDockView.closePageMenu();
            }
        }
    }
}
