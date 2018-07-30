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
    }

    onPageRemovedIndex: {
        removeRunningPage(index);
    }

    function addRunningPage(title){
        objPageListModel.append({"title":title})
    }

    function removeRunningPage(index){
        if(index>-1&&index<objPageListModel.count){
            objPageListModel.remove(index);
        }
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

        dockItemModel: ListModel{
            ListElement{
                icon: "mf-widgets"
                title: "Test"
            }
        }
        pageItemModel: objPageListModel
        onSelectedPageItem: {
            objPageView.setCurrentIndex(index);
        }
    }


    ZBPageView{
        id: objPageView
        anchors.left: objDockView.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

    }
}
