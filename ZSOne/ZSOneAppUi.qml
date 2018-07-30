import QtQuick 2.10

import "../base"
import "../ui"


ZBAppUi{
    id: objAppUi

    property string dockLogo: "image://letter-image/Z"
    signal logoClicked();

    Keys.forwardTo: [objDockView]

    Component.onCompleted: {
        objDockView.open();
        addPage("/ZSOne/ZSOneAppPage.qml",{"rColor":"blue"});
        addPage("/ZSOne/ZSOneAppPage.qml",{"title":"G2","rColor":"red"});
    }

    onPageRemovedIndex: {
        removeRunningPage(index);
    }

    onPageAdded: {
        addRunningPage(title)
    }

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

    function closePage(index){
        ZBLib.removePage(objAppUi,objPageView,index);
    }


    ListModel{
        id: objPageListModel
    }

    ZSideDockSmartView{
        id: objDockView
        anchors.top: parent.top
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
            if(cPage) cPage.selectedContextDockItem(title,index,x,y);
        }
    }


    ZBPageView{
        id: objPageView
        anchors.left: objDockView.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

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
    }
}
