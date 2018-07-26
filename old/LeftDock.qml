import Qb 1.0
import Qb.Core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

Rectangle{
    id: objLeftDock
    width: QbCoreOne.scale(50)
    height: parent.height
    property int topBlockHeight: 0

    color: objAppTheme.changeTransparency(objAppUi.dockColor,200)
    x:-objLeftDock.width
    y:0
    visible: false
    z: -10000000
    focus: false
    property bool isOpened: false
    property var callableList: []

    Behavior on x{
        NumberAnimation{
            duration: 100
            easing.type: Easing.InOutQuad
            onRunningChanged: {
                if(objLeftDock.x !== 0){
                    if(!running){
                        objLeftDock.z = -100000;
                        objLeftDock.visible = false;
                    }
                }
            }
        }
    }

    function open(){
        objLeftDock.visible = true;
        objLeftDock.z = 10000000;
        isOpened = true;
        objLeftDock.x = 0
    }

    function close(){
        isOpened = false;
        objLeftDock.x = - objLeftDock.width;
    }

    function addIcon(data){
        objLeftDockModel.append(data);
    }

    function insertIcon(index,data){
        objLeftDockModel.insert(index,data);
    }

    function totalIcons(){
        return objLeftDockModel.count;
    }

    function iconAt(index){
        return objLeftDockModel.get(index);
    }

    function removeIcon(index){
        try{
            objLeftDockModel.remove(index);
        }
        catch(e){};
    }

    function clearAllIcons(){
        objLeftDockModel.clear();
    }

    Component{
        id: compMenuItem
        MenuItem{
            property int index: 0
            highlighted: false
            onTriggered: {
                objMainView.oldIndex = objMainView.currentIndex;
                //objMainView.currentIndex = index;
                objMainView.setCurrentIndex(index);
                if(!objAppUi.leftDockAlwaysVisible){
                    objLeftDock.close();
                }
            }
        }
    }

    function addRunningPage(title){
        var index = objRunningPageList.count;
        var item = compMenuItem.createObject(listButton,{"text":title,"index":index});
        objRunningPageList.insertItem(index,item);
    }

    function removeRunningPage(index){
        var mi = objRunningPageList.itemAt(index);
        objRunningPageList.removeItem(mi);
        //update indexes of all items
        for(var i = 0;i<objRunningPageList.count;++i){
            objRunningPageList.itemAt(i).index = i;
        }
    }

    ListModel{
        id: objLeftDockModel
    }

    Rectangle{
        id: topBlock
        width: objLeftDock.width
        height: objLeftDock.topBlockHeight
        anchors.top: parent.top
        color: objAppUi.dockColor
    }

    Rectangle{
        id: topButton
        width: objLeftDock.width
        height: QbCoreOne.scale(50)
        anchors.top: topBlock.bottom
        color: objAppUi.dockLogoColor
        Image{
            id: objLogo
            anchors.fill: parent
            sourceSize.width: width*2
            sourceSize.height: height*2
            smooth: true
            mipmap: true
            fillMode: Image.Image.PreserveAspectFit
            source: objAppUi.appLogo
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(!objAppUi.leftDockAlwaysVisible){
                        objLeftDock.close();
                    }
                }
            }
        }
    }

    Item{
        id: listButton
        width: objLeftDock.width
        height: width
        anchors.top: topButton.bottom

        Menu {
            id: objRunningPageList
        }

        Text{
            anchors.fill: parent
            anchors.centerIn: parent
            text: QbMF3.icon("mf-widgets")
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font.family: QbMF3.family
            font.bold: true
            font.pixelSize: parent.height*0.60
        }

        MouseArea{
            anchors.fill: parent
            onClicked:{
                if(objRunningPageList.visible){
                    objRunningPageList.close();
                }
                else{
                    objRunningPageList.popup(listButton.width,0);
                }
            }
        }
    }


    Rectangle{
        id: bottomButton
        width: objLeftDock.width
        height: width
        anchors.bottom: parent.bottom
        color: "black"
        property color textColor: "white"
        Text{
            anchors.fill: parent
            anchors.centerIn: parent
            text: QbMF3.icon("mf-power_settings_new")
            color: bottomButton.textColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font.family: QbMF3.family
            font.bold: true
            font.pixelSize: parent.height*0.50
        }
        MouseArea{
            anchors.fill: parent
            preventStealing: true
            hoverEnabled: true
            onClicked: {
                objAppUi.close();
            }
            onEntered: {
                bottomButton.color = "black";
                bottomButton.textColor = "red";
            }
            onExited: {
                bottomButton.color = "black";
                bottomButton.textColor = "white";
            }
        }
    }

    ListView{
        id: objLeftDockView
        anchors.top: listButton.bottom
        anchors.bottom: bottomButton.top
        width: parent.width
        clip: true
        model: objLeftDockModel
        delegate: Item{
            id: objLeftDockDelegate
            property bool showToolTip: false
            width: objLeftDockView.width
            height: objLeftDockView.width
            ToolTip.text: title
            ToolTip.visible: showToolTip

            Text{
                anchors.fill: parent
                color: "white"
                text: QbCoreOne.icon_font_text_code(icon)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: QbCoreOne.icon_font_name(icon)
                font.bold: false
                font.pixelSize: objLeftDockDelegate.height*0.60
                visible: QbCoreOne.icon_font_is_text(icon)
            }

            Image{
                width: parent.width*0.70
                height: parent.height*0.70
                anchors.centerIn: parent
                visible: QbCoreOne.icon_font_is_image(icon)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                mipmap: true
                smooth: true
                sourceSize.width: parent.width*2
                sourceSize.height: parent.height*2
                source: visible?icon:""
            }

            MouseArea{
                anchors.fill: parent
                preventStealing: true
                onClicked: {
                    var gco = objLeftDockDelegate.mapToItem(objLeftDock, 0, 0);
                    if(objLeftDock.callableList[index]){
                        objLeftDock.callableList[index](gco.x,gco.y);
                    }
                }
                onPressAndHold: {
                    objLeftDockDelegate.showToolTip = true;
                }
                onReleased: {
                    objLeftDockDelegate.showToolTip = false;
                }
            }
        }
    }
}
