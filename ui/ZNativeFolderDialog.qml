import QtQuick 2.10
import Qt.labs.platform 1.0

FolderDialog{
    id: objFolderDialogRoot
    visible: true
    options: FolderDialog.ShowDirsOnly
    currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
}
