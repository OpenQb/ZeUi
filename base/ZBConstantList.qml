pragma Singleton


import QtQuick 2.11

Item {
    id: objBaseConstantList

    property alias dockViewMode: objDockViewMode
    QtObject{
        id: objDockViewMode
        property int zSingleColumn: 0;
        property int zSingleColumnExpand: 1;
        property int zMultiColumn: 2;
    }

}
