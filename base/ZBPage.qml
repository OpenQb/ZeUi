import QtQuick 2.11

ZBItem {
    id: objBasePage
    clip: true

    property bool isClosable: true
    property bool isSingleInstance: false
    property string appId: ""
    property string title: ""
    property var appUi: null

    signal pageOpened();
    signal pageHidden();
    signal pageClosing();
    signal pageCreated();
    signal pageClosed();

    Component.onCompleted: {
        objBasePage.pageCreated();
    }
    Component.onDestruction: {
        objBasePage.pageClosing();
    }

    MouseArea{
        anchors.fill: parent
        preventStealing: true
    }
}
