import QtQuick 2.10
import "ZSX/"

ZSXAppUi{
    id: objMainAppUi
    dockLogo: "image://qbcore/Z"
    Component.onCompleted: {
        //objMainAppUi.addPage("/ZSOne/ZSOneAppPage.qml",{"rColor":"blue"});
        objMainAppUi.addPage("/ZSX/ZSXAppPage.qml",{"title":"G2"});
    }
}
