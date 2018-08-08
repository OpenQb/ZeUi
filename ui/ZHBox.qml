import Qb 1.0
import Qb.Core 1.0


import QtQuick 2.11
import QtQml.Models 2.1
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4



Item {
    id: objHBoxRoot
    property ObjectModel model: null
    property int currentIndex: -1
    property Item appUi: null
    property bool focreActiveFocusToFirstItem: true;

    ListView{
        id: objListView
        clip: true
        anchors.fill: parent
        model: objHBoxRoot.model
        activeFocusOnTab: true
        orientation: ListView.Horizontal
        highlightFollowsCurrentItem: true
        currentIndex: 0
        onActiveFocusChanged: {
            if(activeFocus){
                objListView.currentItem.forceActiveFocus();
                objListView.currentItem.focus = true;
            }
        }
        onCurrentIndexChanged: objHBoxRoot.currentIndex = objListView.currentIndex;
        Connections{
            target: objListView.currentItem
            onActiveFocusChanged:{
                if(!objListView.currentItem.activeFocus)
                if(objListView.currentIndex === (objListView.count-1)){
                    objListView.currentIndex = 0;
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
        Material.accent: objHBoxRoot.appUi.zBaseTheme.accent
        Material.primary: objHBoxRoot.appUi.zBaseTheme.primary
        Material.foreground: objHBoxRoot.appUi.zBaseTheme.foreground
        Material.background: objHBoxRoot.appUi.zBaseTheme.background
        Keys.onUpPressed: {
            event.accepted = false;
        }
        Keys.onDownPressed: {
             event.accepted = false;
        }

        Keys.onLeftPressed: {
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
        Keys.onRightPressed: {
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
    }
}
