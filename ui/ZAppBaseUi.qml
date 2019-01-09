import Qb 1.0
import QbEx 1.0
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

    property alias pageView: objPageView
    property alias topBlock: objTopBlock
    property alias pageList: objPageListModel

    Component.onCompleted: {
        if(objAppUi.androidFullScreen)
        {
            enableAndroidFullScreen();
        }
        else
        {
            disableAndroidFullScreen();
        }
    }

    onAppVisible: {
        if(objAppUi.androidFullScreen)
        {
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

    Item{
        id: objPageView

        property int nextIndex: -1;
        property int currentIndex: -1;
        property int count: 0

        QbOneOneMap{
            id: objMap
        }

        function setCurrentIndex(index)
        {
            currentIndex = index;
        }

        function getPage(index){
            return objMap.get(index);
        }

        function insertPage(index,item){
            //            try
            //            {
            //                item.visible = false;
            //            }
            //            catch(e)
            //            {

            //            }

            objPageView.currentIndex = -1;
            objMap.insert(index,index,item);
            objPageView.count = objMap.count();
            objPageView.nextIndex = index-1;
            objPageView.currentIndex = index-1;
        }

        function setCurrentPage(index)
        {
            objPageView.setCurrentIndex(index)
        }

        function takePage(index)
        {
           var p = objMap.take(index);
            objPageView.count = objMap.count();
            return p;
        }

        function removePage(index)
        {
            if(objMap.count>0){
                try{
                    var item = objPageView.takePage(index);
                    item.visible = false;
                    item.focus = false;
                    item.pageClosing();
                    try
                    {
                        item.destroy();
                    }
                    catch(e){
                    }
                    try{
                        delete item;
                    }
                    catch(e){
                    }

                    return true;
                }
                catch(e){
                    return false;
                }
            }
            return false;
        }
    }
}
