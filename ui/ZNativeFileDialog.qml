import QtQuick 2.10
import QtQuick.Controls 2.2
import Qt.labs.platform 1.0


FileDialog {
      id: objFileDialog
      visible: true
      folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
}
