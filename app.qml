import QtQuick 2.10

import "ZSOne/"


ZSOneAppUi{
    id: objMainAppUi
    dockLogo: "image://qbcore/Z"
    Component.onCompleted: {
        objMainAppUi.addPage("/ZSOne/ZSOneAppPage.qml",{"rColor":"blue"});
        objMainAppUi.addPage("/ZSOne/ZSOneAppPage.qml",{"title":"G2","rColor":"red"});
    }
}
