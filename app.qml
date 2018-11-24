import QtQuick 2.10
import "ZSS/"
import "ui/"

ZSSAppUi{
    id: objMainAppUi

    ZFolderDialog{
        id: objFolderDialog
        anchors.fill: parent
    }

    Component.onCompleted: {
        objFolderDialog.open();
    }
}
