import Qb 1.0
import Qb.Core 1.0


import QtQuick 2.11
import QtQml.Models 2.1
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

import "./../base"


Item {
    id: objHBoxRoot
    property ObjectModel model: null
    property alias currentIndex: objListView.currentIndex
    property alias currentItem: objListView.currentItem
    property bool focreActiveFocusToFirstItem: true;
    property alias spacing: objListView.spacing
    onActiveFocusChanged: {
        if(activeFocus){
            objHBoxRoot.currentItem.forceActiveFocus();
        }
    }

    ListView{
        id: objListView
        clip: true
        anchors.fill: parent
        model: objHBoxRoot.model
        activeFocusOnTab: true
        orientation: ListView.Horizontal
        highlightFollowsCurrentItem: true
        currentIndex: 0
        onCurrentIndexChanged: objHBoxRoot.currentIndex = objListView.currentIndex;
        Connections{
            target: objListView.currentItem
            onActiveFocusChanged:{
                if(objListView.currentIndex === (objListView.count-1)){
                    if(!objListView.currentItem.activeFocus) objListView.currentIndex = 0;
                }
            }
        }
        ScrollBar.horizontal: ScrollBar {
            id: objScrollBar;
            active: objScrollBar.focus || objListView.focus
            focusReason: Qt.StrongFocus
            Keys.onLeftPressed: {
                objListView.decrementCurrentIndex()
            }
            Keys.onRightPressed: {
                objListView.incrementCurrentIndex();
            }
            Keys.onUpPressed: {
                event.accepted = false;
            }
            Keys.onDownPressed: {
                event.accepted = false;
            }
        }
        Material.accent: ZBLib.appUi.zBaseTheme.accent
        Material.primary: ZBLib.appUi.zBaseTheme.primary
        Material.foreground: ZBLib.appUi.zBaseTheme.foreground
        Material.background: ZBLib.appUi.zBaseTheme.background
        Keys.onUpPressed: {
            event.accepted = false;
        }
        Keys.onDownPressed: {
            event.accepted = false;
        }

        Keys.onLeftPressed: {
            if(objListView.currentIndex === 0){
                event.accepted = false;
                return;
            }

            while(true){
                objListView.decrementCurrentIndex();
                if(objListView.currentIndex === 0){
                    break;
                }
                if(objListView.currentItem.visible === true && objListView.currentItem.enabled === true){
                    break;
                }
            }

        }
        Keys.onRightPressed: {
            if(objListView.currentIndex >= (objListView.count-1)){
                event.accepted = false;
                return;
            }
            while(true){
                objListView.incrementCurrentIndex();
                if(objListView.currentIndex >=(objListView.count-1)){
                    break;
                }
                if(objListView.currentItem.visible === true && objListView.currentItem.enabled === true){
                    break;
                }
            }

        }
    }
}
