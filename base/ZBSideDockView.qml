import QtQuick 2.10

Item {
    id: objBaseSideDockRoot
    clip: false

    signal selectedItem(string title,int index,int x,int y);
}
