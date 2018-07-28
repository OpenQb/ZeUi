import QtQuick 2.10
import QtQuick.Controls 2.2

import "ui/"

ZAppUi{
    id: objMainAppUi

    ZNativeFileDialog{
        id: objFileDialog
    }

    Button{
        id: objButton
        text: "OPEN DIALOG"
        onClicked: {
            objFileDialog.open();
        }
    }
}
