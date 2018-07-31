import QtQuick 2.10

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

    function closeCurrentPage(){
            ZBLib.removePage(objAppUi,objPageView,objPageView.currentIndex);
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
            if(cPage) cPage.selectedContextDockItem(title,index,x+objDockView.width,y+objDockView.dockLogoHeight+objDockView.dockItemHeight);
        }

        KeyNavigation.tab: objPageView
        KeyNavigation.priority: KeyNavigation.BeforeItem
    }


    ZBPageView{
        id: objPageView
        anchors.left: objDockView.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        KeyNavigation.tab: objDockView
        KeyNavigation.priority: KeyNavigation.BeforeItem

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
