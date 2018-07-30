import QtQuick 2.10

import "../base"

ZBPage{
    id: objAppPage
    property ListModel contextDock: objContextDock;
    signal selectedContextDockItem(string title,int index,int x,int y);
    title: "Generic Page"
    anchors.fill: parent
    ListModel{
        id: objContextDock
//        ListElement{
//            icon: "image://letter-image/T"
//            title: "Test"
//        }
    }

    //    property color rColor: "black"
    //    Rectangle{
    //        anchors.fill: parent
    //        color: objAppPage.rColor
    //    }
}
