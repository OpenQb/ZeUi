import QtQuick 2.11

Flickable {
    id: objBasePage
    clip: true
    activeFocusOnTab: false

    property bool isClosable: true
    property bool isSingleInstance: false
    property string appId: ""
    property string title: ""

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
