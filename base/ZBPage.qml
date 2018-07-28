import QtQuick 2.10

Item {
    id: objBasePage
    clip: true

    property bool isClosable: true
    property bool isSingleInstance: false
    property string appId: ""

    signal pageOpened();
    signal pageHidden();
    signal pageClosing();
    signal pageCreated();
    signal pageClosed();

    Component.onCompleted: {
        objBasePage.pageCreated();
    }
    Component.onDestruction: {
        objBasePage.pageClosed();
    }

}
