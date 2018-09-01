import QtQuick 2.10
import QtQuick.Window 2.11
import Qt.labs.platform 1.0

Window{
    visible: false
    property alias folderDialog: objFolderDialogRoot

    FolderDialog{
        id: objFolderDialogRoot
        options: FolderDialog.ShowDirsOnly
        currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    }
}
