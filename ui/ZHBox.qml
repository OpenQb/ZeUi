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

    ListView{
        id: objListView
        clip: true
        anchors.fill: parent
        model: objHBoxRoot.model
        activeFocusOnTab: true
        onActiveFocusChanged: {
            if(!activeFocus){
                objListView.currentIndex = 0;
            }
        }
        orientation: ListView.Horizontal
        highlightFollowsCurrentItem: true
        onCurrentIndexChanged: objHBoxRoot.currentIndex = objListView.currentIndex;
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
        }
        Material.accent: objHBoxRoot.appUi.zBaseTheme.accent
        Material.primary: objHBoxRoot.appUi.zBaseTheme.primary
        Material.foreground: objHBoxRoot.appUi.zBaseTheme.foreground
        Material.background: objHBoxRoot.appUi.zBaseTheme.background

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
