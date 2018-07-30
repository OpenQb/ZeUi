import QtQuick 2.10
import QtQuick.Controls 2.4

import "ui/"

ZAppUi{
    id: objMainAppUi

    Keys.forwardTo: [objDockView]

    ZSideDockSmartView{
        id: objDockView
        anchors.top: parent.top
        height: parent.height
        dockLogo: "image://letter-image/Z"
        onLogoClicked: {
            console.log("logo clicked");
        }
        onExitClicked: {
            //objMainAppUi.close();
        }

        dockItemModel: ListModel{
            ListElement{
                icon: "mf-widgets"
                title: "Test"
            }
        }
        Component.onCompleted: {
            objDockView.open();
        }
    }
}
