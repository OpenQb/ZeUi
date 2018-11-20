import QtQuick 2.10
import "ZSS/"

ZSSAppUi{
    id: objMainAppUi
    Component.onCompleted: {
        objMainAppUi.addPage("/ZSS/ZSSFlickPage.qml");
    }
}
