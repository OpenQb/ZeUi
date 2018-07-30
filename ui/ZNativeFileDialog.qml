import QtQuick 2.10
import Qt.labs.platform 1.0

FileDialog {
      id: objFileDialog
      visible: true
      folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
}
