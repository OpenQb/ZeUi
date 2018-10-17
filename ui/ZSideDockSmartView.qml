import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10

import "./../base"


ZBItem{
    id: objSideDockSmartViewRoot
    clip: false

    x: -objSideDockSmartViewRoot.width
    visible: false
    z: -100000
    focus: false
    //Keys.priority: Keys.AfterItem

    onFocusChanged: {
        objLogoView.isFocused = focus;
        objUserDataView.isFocused = focus;
        objPagesView.isFocused = focus;
        objPowerView.isFocused = focus;
    }

    signal selectedItem(string title,int index,int x,int y);
    signal selectedPageItem(string title,int index,int x,int y);
    signal selectedByMouse();

    signal exitClicked();
    signal logoClicked();

    property bool isOpened: false

    property int currentView: 0
    property string dockLogo: ""
    property string pageTitle: "Pages"
    property int dockPowerHeight: ZBTheme.dockItemHeight
    property int dockLogoHeight: ZBTheme.dockItemHeight
    property int dockItemHeight: ZBTheme.dockItemHeight
    property int dockItemWidth: ZBTheme.dockItemWidth
    property int dockItemExpandedWidth: ZBTheme.dockItemExpandedWidth
    property int dockViewMode: ZBTheme.dockViewMode


    property alias pageItemModel: objPagesList.menuItemModel
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

    function closePageMenu(){
        objPagesList.closeMenu();
    }

    function keysOnPressed(event){
        var viewList = [objLogoView,objPagesView,objUserDataView,objPowerView];
        var cView;

        if(event.key === Qt.Key_Up){
            if(objPagesList.visible){
                objPagesList.closeMenu();
            }
            objSideDockSmartViewRoot.forceActiveFocus();
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
            if(objPagesList.visible){
                objPagesList.closeMenu();
            }
            objSideDockSmartViewRoot.forceActiveFocus();
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
            if(objPagesList.visible){
                objPagesList.closeMenu();
                //objSideDockSmartViewRoot.forceActiveFocus();
                //objSideDockSmartViewRoot.focus = true;
            }
            else{
                for(var i=0;i<viewList.length;++i){
                    cView = viewList[i].clearSelection();
                }
                objSideDockSmartViewRoot.currentView = -1;
            }
        }
        else if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space){
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
        else if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space){
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
        //isFocused: objSideDockSmartViewRoot.focus
        dockItemCurrentIndex: 0
        activeFocusOnTab: false
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
            objSideDockSmartViewRoot.forceActiveFocus();
            objSideDockSmartViewRoot.focus = true;
            objSideDockSmartViewRoot.logoClicked();
        }
        onSelectedByMouse: {
            objSideDockSmartViewRoot.currentView = 0;
            objPagesView.clearSelection();
            objUserDataView.clearSelection();
            objPowerView.clearSelection();
            objPagesList.closeMenu();
            objSideDockSmartViewRoot.forceActiveFocus();
            objSideDockSmartViewRoot.focus = true;
            objSideDockSmartViewRoot.selectedByMouse();
        }
    }

    ZBSideDockView{
        id: objPagesView
        anchors.top: objLogoView.bottom
        anchors.left: parent.left
        width: objSideDockSmartViewRoot.width
        height: objSideDockSmartViewRoot.dockItemHeight*1
        visible: true
        z: 10000001
        focus: true
        //isFocused: objSideDockSmartViewRoot.focus
        dockInteractive: false
        dockViewMode: ZBTheme.zSingleColumn
        dockItemHeight: objSideDockSmartViewRoot.dockItemHeight
        activeFocusOnTab: false

        Component.onCompleted: {
            if(Qt.platform.os === "android" || Qt.platform.os === "ios"||QbCoreOne.isSingleWindowMode()||QbCoreOne.isWebglPlatofrm()){
                objPagesView.height = objSideDockSmartViewRoot.dockItemHeight*2;
            }
            else{
                objPageViewModel.remove(objPageViewModel.count-1);
            }
        }
        dockItemModel: ListModel{
            id: objPageViewModel
            ListElement{
                title: "Pages"
                icon: "mf-widgets"
            }
            ListElement{
                title: "Hide"
                icon: "mf-exit_to_app"
                icon_rotation: 180
            }
        }
        onSelectedItem: {
            if(title === "Pages"){
                if(!objPagesList.visible){
                    //objSideDockSmartViewRoot.focus = false;
                    objPagesList.openMenu(x+objSideDockSmartViewRoot.width,y+objSideDockSmartViewRoot.dockLogoHeight);
                }
                else{
                    objPagesList.closeMenu();
                    //objSideDockSmartViewRoot.forceActiveFocus();
                    //objSideDockSmartViewRoot.focus = true;
                }
            }
            else if(title === "Hide"){
                ZBLib.appUi.hide();
                objPagesList.closeMenu();
            }
        }
        onSelectedByMouse: {
            objSideDockSmartViewRoot.forceActiveFocus();
            objSideDockSmartViewRoot.focus = true;
            objSideDockSmartViewRoot.currentView = 1;
            objLogoView.clearSelection();
            objUserDataView.clearSelection();
            objPowerView.clearSelection();
            objSideDockSmartViewRoot.selectedByMouse();
        }
    }

    ZBListMenu{
        id: objPagesList
        title: objSideDockSmartViewRoot.pageTitle
        onSelectedItem: {
            objSideDockSmartViewRoot.selectedPageItem(title,index,x,y);
            objPagesList.closeMenu();
            objSideDockSmartViewRoot.forceActiveFocus();
            objSideDockSmartViewRoot.focus = true;
        }
        activeFocusOnTab: false
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
        //isFocused: objSideDockSmartViewRoot.focus
        dockViewMode: objSideDockSmartViewRoot.dockViewMode
        dockItemHeight: objSideDockSmartViewRoot.dockItemHeight
        activeFocusOnTab: false
        onSelectedItem: {
            objSideDockSmartViewRoot.forceActiveFocus();
            objSideDockSmartViewRoot.focus = true;
            objSideDockSmartViewRoot.selectedItem(title,index,x,y)
        }
        onSelectedByMouse: {
            objSideDockSmartViewRoot.currentView = 2;
            objPagesView.clearSelection();
            objLogoView.clearSelection();
            objPowerView.clearSelection();
            objPagesList.closeMenu();
            objSideDockSmartViewRoot.forceActiveFocus();
            objSideDockSmartViewRoot.focus = true;
            objSideDockSmartViewRoot.selectedByMouse();
        }
    }

    ZBSideDockView{
        id: objPowerView
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: objSideDockSmartViewRoot.width
        height: visible?objSideDockSmartViewRoot.dockPowerHeight:0
        visible: Qt.platform.os === "android"||Qt.platform.os === "ios"||QbCoreOne.isBuiltForRaspberryPi()||QbCoreOne.isSingleWindowMode()||QbCoreOne.isWebglPlatofrm()?true:false
        z: 10000001
        focus: Qt.platform.os === "android"||Qt.platform.os === "ios"||QbCoreOne.isBuiltForRaspberryPi()||QbCoreOne.isSingleWindowMode()||QbCoreOne.isWebglPlatofrm()?true:false
        keyAccepted: Qt.platform.os === "android"||Qt.platform.os === "ios"||QbCoreOne.isBuiltForRaspberryPi()||QbCoreOne.isSingleWindowMode()||QbCoreOne.isWebglPlatofrm()?true:false
        //isFocused: objSideDockSmartViewRoot.focus
        dockItemHeight: objSideDockSmartViewRoot.dockPowerHeight
        dockInteractive: false
        dockViewMode: ZBTheme.zSingleColumn
        activeFocusOnTab: false
        dockItemModel: ListModel{
            ListElement{
                title: "Exit"
                icon: "mf-power_settings_new"
            }
        }
        onSelectedItem: {
            objSideDockSmartViewRoot.forceActiveFocus();
            objSideDockSmartViewRoot.focus = true;
            objSideDockSmartViewRoot.exitClicked();
        }
        onSelectedByMouse: {
            objSideDockSmartViewRoot.forceActiveFocus();
            objSideDockSmartViewRoot.focus = true;
            objSideDockSmartViewRoot.currentView = 3;
            objPagesView.clearSelection();
            objLogoView.clearSelection();
            objUserDataView.clearSelection();
            objPagesList.closeMenu();
            objSideDockSmartViewRoot.selectedByMouse();
        }
    }

//    Rectangle{
//        color: ZBTheme.dockBackgroundColor
//        anchors.bottom: parent.bottom
//        anchors.left: parent.left
//        width: objSideDockSmartViewRoot.width
//        height: objSideDockSmartViewRoot.dockPowerHeight
//        visible: !objPowerView.visible
//    }
}
