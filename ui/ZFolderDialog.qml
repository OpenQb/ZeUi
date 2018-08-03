import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../base"

ZBItem {
    id: objFolderDialog

    states: [
        State {
            name: "Home"
            PropertyChanges {
            }
        },
        State {
            name: "FolderView"
            PropertyChanges {
            }
        }
    ]

    QbDir{
        id: objDirObject
        Component.onCompleted: {
            objDirObject.setSorting(QbDir.DirsFirst|QbDir.Name);
        }
    }

    QbPaths{
        id: objPathsObject
    }

}
