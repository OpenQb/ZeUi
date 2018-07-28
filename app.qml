import QtQuick 2.10
import QtQuick.Controls 2.2

import "ui/"

ZAppUi{
    id: objMainAppUi

    Keys.forwardTo: [objDockView]

    ZSideDockView{
        id: objDockView
        x: 0
        y: 0
        width: 50
        height: parent.height
        dockItemModel: ListModel{
            ListElement{
                title: "Exit"
                icon: "mf-power_settings_new"
            }
            ListElement{
                title: "Exit2"
                icon: "mf-power_settings_new"
            }
        }

        onSelectedItem: {
            console.log(title);
            console.log(x);
            console.log(y);
        }
    }
}
