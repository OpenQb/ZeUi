import QtQuick 2.10
import QtQuick.Controls 2.2

import "ui/"

ZAppUi{
    id: objMainAppUi

    Keys.forwardTo: [objDockView]

    ZSideDockView{
        id: objDockView
        anchors.top: parent.top
        //dockItemHeight: 30
        //dockItemWidth: 30
        //dockItemExpandedWidth: 50

        height: 100
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

    Component.onCompleted: {
        objDockView.open();
    }

}
