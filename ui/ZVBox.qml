import Qb 1.0
import Qb.Core 1.0


import QtQuick 2.11
import QtQml.Models 2.1
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4



Item {
    id: objVBoxRoot
    property ObjectModel model: null
    property alias currentIndex: objListView.currentIndex
    property alias currentItem: objListView.currentItem
    property Item appUi: null
    property bool focreActiveFocusToFirstItem: true;
    onActiveFocusChanged: {
        if(activeFocus){
            objVBoxRoot.currentItem.forceActiveFocus();
        }
    }

    ListView{
        id: objListView
        clip: true
        anchors.fill: parent
        model: objVBoxRoot.model
        activeFocusOnTab: true
        highlightFollowsCurrentItem: true
        currentIndex: 0
        onCurrentIndexChanged: objVBoxRoot.currentIndex = objListView.currentIndex;
        Connections{
            target: objListView.currentItem
            onActiveFocusChanged:{
                if(objListView.currentIndex === (objListView.count-1)){
                    if(!objListView.currentItem.activeFocus) objListView.currentIndex = 0;
                }
            }
        }
        ScrollBar.vertical: ScrollBar {
            id: objScrollBar;
            active: objScrollBar.focus || objListView.focus
            focusReason: Qt.StrongFocus
            Keys.onLeftPressed: {
                event.accepted = false;
            }
            Keys.onRightPressed: {
                event.accepted = false;
            }
            Keys.onUpPressed: {
                objListView.decrementCurrentIndex()

            }
            Keys.onDownPressed: {
                objListView.incrementCurrentIndex();
            }
        }
        Material.accent: objVBoxRoot.appUi.zBaseTheme.accent
        Material.primary: objVBoxRoot.appUi.zBaseTheme.primary
        Material.foreground: objVBoxRoot.appUi.zBaseTheme.foreground
        Material.background: objVBoxRoot.appUi.zBaseTheme.background
        Keys.onUpPressed: {
            if(objListView.currentIndex === 0){
                event.accepted = false;
                return;
            }

            while(true){
                objListView.decrementCurrentIndex();
                if(objListView.currentIndex === 0){
                    break;
                }
                if(objListView.currentItem.visible !== false){
                    break;
                }
            }
        }
        Keys.onDownPressed: {
            if(objListView.currentIndex >= (objListView.count-1)){
                event.accepted = false;
                return;
            }
            while(true){
                objListView.incrementCurrentIndex();
                if(objListView.currentIndex >=(objListView.count-1)){
                    break;
                }
                if(objListView.currentItem.visible !== false){
                    break;
                }
            }
        }

        Keys.onLeftPressed: {
            event.accepted = false;

        }
        Keys.onRightPressed: {
            event.accepted = false;
        }
    }
}
