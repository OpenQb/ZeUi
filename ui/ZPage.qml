import QtQuick 2.10
import QtQml.Models 2.10

import "./../base"

ZBPage {
    property ListModel contextDock: null;
    signal selectedContextDockItem(string title,int index,int x,int y);
    signal selectedByMouse();
}
