import QtQuick 2.10

import "../base"

ZBPage{
    id: objAppPage
    property ListModel contextDock: objContextDock;
    signal selectedContextDockItem(string title,int index,int x,int y);
    title: "Generic Page"
    anchors.fill: parent

    property color rColor: "black"

    ListModel{
        id: objContextDock
        ListElement{
            icon: "image://letter-image/T"
            title: "Test"
        }
    }
    Rectangle{
        anchors.fill: parent
        color: objAppPage.rColor
    }
}
