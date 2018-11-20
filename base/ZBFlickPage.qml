import QtQuick 2.11

Flickable {
    id: objBasePage

    clip: true
    activeFocusOnTab: true
    focus: true

    property bool isClosable: true
    property bool isSingleInstance: false
    property string appId: ""
    property string title: ""

    signal pageOpened();
    signal pageHidden();
    signal pageClosing();
    signal pageCreated();
    signal pageClosed();
    signal focusXY(int x,int y);

    Component.onCompleted: {
        objBasePage.pageCreated();
    }

    Component.onDestruction: {
        objBasePage.pageClosing();
    }
}
