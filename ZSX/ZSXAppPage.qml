import QtQuick 2.10

import "./../base"

ZBPage{
    id: objAppPage
    property ListModel contextDock: objContextDock;
    signal selectedContextDockItem(string title,int index,int x,int y);
    signal selectedByMouse();
    title: "ZSX Page"
    //anchors.fill: parent
    ListModel{
        id: objContextDock
    }
}
