
import QtQuick 2.10
import QtQml.Models 2.1
import QtQuick.Controls 2.4

import "./../base"

Popup {
    id: objPopup

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    property string title: "Dialog"
    property int dialogWidth: parent.width
    property int dialogHeight: parent.height
    property int availableHeight: enableStatusBar?dialogHeight - 50*2:dialogHeight - 50*1

    property bool enableStatusBar: false;
    property string statusBarButtonText: "OK";
    property string statusBarMessage: "";
    property string statusBarMessageColor: "white";
    signal buttonClicked();

    property Item mainView: null
    property ObjectModel model:null
    property Component modelComponent: null

    property Item dialogView: null
    property int currentIndex:-1

//    onStatusBarMessageChanged: {
//        if(statusBarMessage !== ""){
//            if(objStatusBarClearTimer.running) objStatusBarClearTimer.stop();
//            objStatusBarClearTimer.start();
//        }
//    }

    contentItem: Rectangle{

//        Connections{
//            target: ZBLib.appUi
//            onAppClosing:{
//                objPopup.close();
//            }
//        }

//        Timer{
//            id: objStatusBarClearTimer
//            interval: 5000
//            onTriggered: {
//                objDialogRoot.statusBarMessage = ""
//                objStatusBarClearTimer.stop();
//            }
//        }

        Text{
            anchors.fill: parent
            text: "What"
        }
    }
}
