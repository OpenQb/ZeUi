import QtQuick 2.10
import QtQuick.Window 2.11
import Qt.labs.platform 1.0


Window{
    visible: false
    property alias fileDialog: objFileDialog
    FileDialog {
        id: objFileDialog
        currentFile: ""
        currentFiles: []
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    }
}
