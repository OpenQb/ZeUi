import QtQuick 2.10

import "./../base"


Item{
    id: objSideDockSmartViewRoot
    clip: false

    x: -objSideDockSmartViewRoot.width
    visible: false
    z: -100000
    focus: false

    signal selectedItem(string title,int index,int x,int y);

    signal exitClicked();
    signal logoClicked();

    property bool isOpened: false

    property int currentView: -1
    property string dockLogo: ""
    property int dockPowerHeight: ZBTheme.dockItemHeight
    property int dockLogoHeight: ZBTheme.dockItemHeight
    property int dockItemHeight: ZBTheme.dockItemHeight
    property int dockItemWidth: ZBTheme.dockItemWidth
    property int dockItemExpandedWidth: ZBTheme.dockItemExpandedWidth
    property int dockViewMode: ZBTheme.dockViewMode


    property alias dockItemModel: objUserDataView.dockItemModel
    property alias dockItemDelegate: objUserDataView.dockItemDelegate

    property alias dockItemCurrentIndex: objUserDataView.dockItemCurrentIndex
    property alias dockItemCurrentItem: objUserDataView.dockItemCurrentItem

    property alias dockItemSelectedX: objUserDataView.dockItemSelectedX
    property alias dockItemSelectedY: objUserDataView.dockItemSelectedY

    width:objSideDockSmartViewRoot.dockViewMode === ZBTheme.zMultiColumn?objSideDockSmartViewRoot.dockItemWidth+objSideDockSmartViewRoot.dockItemExpandedWidth:objSideDockSmartViewRoot.dockItemWidth

    Behavior on x{
        enabled: ZBTheme.useAnimation
        NumberAnimation{
            duration: 500
            easing.type: Easing.InOutQuad
            onRunningChanged: {
                if(objSideDockSmartViewRoot.x !== 0){
                    if(!running){
                        objSideDockSmartViewRoot.z = -100000;
                        objSideDockSmartViewRoot.visible = false;
                    }
                }
            }
        }
    }

    function open(){
        objSideDockSmartViewRoot.visible = true;
        objSideDockSmartViewRoot.z = 100000;
        objSideDockSmartViewRoot.isOpened = true;
        objSideDockSmartViewRoot.x = 0
    }

    function close(){
        objSideDockSmartViewRoot.isOpened = false;
        objSideDockSmartViewRoot.x = -objSideDockSmartViewRoot.width;
    }

    function keysOnPressed(event){
        var viewList = [objLogoView,objPagesView,objUserDataView,objPowerView];
        var cView;

        if(event.key === Qt.Key_Up){
            if(objSideDockSmartViewRoot.currentView<0){
                objSideDockSmartViewRoot.currentView = viewList.length - 1;
            }
            cView = viewList[objSideDockSmartViewRoot.currentView];

            if(cView.canAcceptUpKey()){
                cView.keysOnPressed(event);
            }
            else{
                cView.clearSelection();
                objSideDockSmartViewRoot.currentView = objSideDockSmartViewRoot.currentView-1
                keysOnPressed(event);
            }
        }
        else if(event.key === Qt.Key_Down){
            if(objSideDockSmartViewRoot.currentView<0 || objSideDockSmartViewRoot.currentView>=viewList.length){
                objSideDockSmartViewRoot.currentView = 0;
            }
            cView = viewList[objSideDockSmartViewRoot.currentView];
            if(cView.canAcceptDownKey()){
                cView.keysOnPressed(event);
            }
            else{
                cView.clearSelection();
                objSideDockSmartViewRoot.currentView = objSideDockSmartViewRoot.currentView+1
                keysOnPressed(event);
            }
        }
        else if(event.key === Qt.Key_Escape||event.key === Qt.Key_Back){
            event.accepted = true;
            for(var i=0;i<viewList.length;++i){
                cView = viewList[i].clearSelection();
            }
            objSideDockSmartViewRoot.currentView = -1;
        }
        else if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
            cView = viewList[objSideDockSmartViewRoot.currentView];
            if(cView){
                if(cView.canAcceptEnterKey()){
                    cView.keysOnPressed(event);
                }
                else{
                    event.accepted = false;
                }
            }
            else{
                event.accepted = false;
            }
        }
    }

    function keysOnReleased(event){
        if(event.key === Qt.Key_Up){
            event.accepted = true;
        }
        else if(event.key === Qt.Key_Down){
            event.accepted = true;
        }
        else if(event.key === Qt.Key_Escape||event.key === Qt.Key_Back){
            event.accepted = true;
        }
        else if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
            event.accepted = true;
        }
    }

    Keys.onPressed: keysOnPressed(event);
    Keys.onReleased: keysOnReleased(event);

    ZBSideDockView{
        id: objLogoView
        anchors.top: parent.top
        anchors.left: parent.left
        width: objSideDockSmartViewRoot.width
        height: objSideDockSmartViewRoot.dockLogoHeight
        visible: true
        z: 10000001
        focus: true
        dockInteractive: false
        dockViewMode: ZBTheme.zSingleColumn
        dockItemHeight: objSideDockSmartViewRoot.dockLogoHeight
        dockItemModel: ListModel{
            id: objLogoModel
            Component.onCompleted: {
                objLogoModel.clear();
                objLogoModel.append({"title": "Logo","icon": objSideDockSmartViewRoot.dockLogo});
            }
        }
        onSelectedItem: {
            objSideDockSmartViewRoot.logoClicked();
        }
        onSelectedByMouse: {
            objSideDockSmartViewRoot.currentView = 0;
            objPagesView.clearSelection();
            objUserDataView.clearSelection();
            objPowerView.clearSelection();
        }
    }

    ZBSideDockView{
        id: objPagesView
        anchors.top: objLogoView.bottom
        anchors.left: parent.left
        width: objSideDockSmartViewRoot.width
        height: objSideDockSmartViewRoot.dockItemHeight
        visible: true
        z: 10000001
        focus: true
        dockInteractive: false
        dockViewMode: ZBTheme.zSingleColumn
        dockItemHeight: objSideDockSmartViewRoot.dockItemHeight
        dockItemModel: ListModel{
            ListElement{
                title: "Pages"
                icon: "mf-widgets"
            }
        }
        onSelectedItem: {

        }
        onSelectedByMouse: {
            objSideDockSmartViewRoot.currentView = 1;
            objLogoView.clearSelection();
            objUserDataView.clearSelection();
            objPowerView.clearSelection();
        }
    }

    ZBSideDockView{
        id: objUserDataView
        anchors.top: objPagesView.bottom
        anchors.left: parent.left
        anchors.bottom: objPowerView.top
        width: objSideDockSmartViewRoot.width
        visible: true
        z: 10000000
        focus: true
        dockViewMode: objSideDockSmartViewRoot.dockViewMode
        dockItemHeight: objSideDockSmartViewRoot.dockItemHeight
        onSelectedItem: {
            objSideDockSmartViewRoot.selectedItem(title,index,x,y)
        }
        onSelectedByMouse: {
            objSideDockSmartViewRoot.currentView = 2;
            objPagesView.clearSelection();
            objLogoView.clearSelection();
            objPowerView.clearSelection();
        }
    }

    ZBSideDockView{
        id: objPowerView
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: objSideDockSmartViewRoot.width
        height: objSideDockSmartViewRoot.dockPowerHeight
        visible: true
        z: 10000001
        focus: true
        dockItemHeight: objSideDockSmartViewRoot.dockPowerHeight
        dockInteractive: false
        dockViewMode: ZBTheme.zSingleColumn
        dockItemModel: ListModel{
            ListElement{
                title: "Exit"
                icon: "mf-power_settings_new"
            }
        }
        onSelectedItem: {
            objSideDockSmartViewRoot.exitClicked();
        }
        onSelectedByMouse: {
            objSideDockSmartViewRoot.currentView = 3;
            objPagesView.clearSelection();
            objLogoView.clearSelection();
            objUserDataView.clearSelection();
        }
    }
}
