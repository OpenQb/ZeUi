import QtQuick 2.10

import "../base"

ZBPage{
    id: objAppPage
    property ListModel contextDock: objContextDock;
    signal selectedContextDockItem(string title,int index,int x,int y);


    ListModel{
        id: objContextDock
    }
}
