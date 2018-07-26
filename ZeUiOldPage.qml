import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

import Qb 1.0
import Qb.Core 1.0

import "old/app.js" as App

Page{
    id: objPage
    property bool isClosable: true
    clip: true

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    signal pageOpened();
    signal pageHidden();
    signal pageClosing();
    signal pageCreated();
    signal pageClosed();

    Component.onCompleted: {
        objPage.pageCreated();
    }

    Component.onDestruction: {
        objPage.pageClosed();
    }

    property string appId: App.objAppUi.appId;
    property var appJS: App

    property Item leftBar: null
    property Item rightBar: null
    property Item topBar:Item{
        Label{
            anchors.fill: parent
            text: objPage.title
            font.bold: true
            verticalAlignment: Label.AlignVCenter
        }
    }

    property Item bottomBar: null
}
