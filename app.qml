//import QtQuick 2.10


//import "ZSOne/"
//ZSOneAppUi{
//    id: objMainAppUi
//    dockLogo: "image://qbcore/Z"
//    Component.onCompleted: {
//        //objMainAppUi.addPage("/ZSOne/ZSOneAppPage.qml",{"rColor":"blue"});
//        //objMainAppUi.addPage("/ZSOne/ZSOneAppPage.qml",{"title":"G2","rColor":"red"});
//    }

//}
import Qb 1.0
import "base/"
import "ui/"
import QtQuick 2.11
import QtQuick.Window 2.11
ZBAppUi{
    id: objMainAppUi

    ZNativeFolderDialog{
        id: fd
    }

    //    ZFolderDialog{
    //        id: fd
    //        anchors.fill: parent
    //        onSelectedPath: {
    //            console.log(path)
    //        }
    //    }

    Rectangle{
        anchors.fill: parent
        color: "transparent"
        ZMActionButton{
            anchors.centerIn: parent
            text: QbMF3.icon("mf-dashboard")
            font.family: QbMF3.family
        }
        ZMActionButton{
            anchors.bottom: parent.bottom
            text: "2"
        }
    }
}




//import QtQuick 2.11
//import QtQuick.Window 2.11
//import Qt.labs.platform 1.0
//import QtQuick.Controls 2.4

//ZBAppUi{

//    //Window{
//    //visible: false
//        FileDialog {
//         id: fileDialog
//         currentFile: ""
//         folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
//     }
//    //}

//    Button {
//        text: "Ok"
//        onClicked: {
//            fileDialog.open();
//        }
//    }
//}
