import Qb 1.0
import QbEx 1.0
import Qb.Core 1.0
import QtQuick 2.10

import "."

QbApp {
    id: objBaseAppUiRoot
    minimumHeight: 550
    minimumWidth: 500

    signal pageRemovedIndex(int index);
    signal pageRemovedTitle(string title);
    signal pageAdded(string title);

    property string gridState: "xs"
    property bool isAddingPage: false;
    property int scrollMode: ZBTheme.zInfiniteHeight;
    property bool androidFullScreen: true;

    property var zBaseLib: ZBLib
    property var zBaseTheme: ZBTheme

    /*
      0 - infinite height. fixed width
      1 - infinite width. fixed height
    */
    onWidthChanged: {
        if(objBaseAppUiRoot.scrollMode === ZBTheme.zInfiniteHeight){
            appResized();
        }
    }
    onHeightChanged: {
        if(objBaseAppUiRoot.scrollMode === ZBTheme.zInfiniteWidth){
            appResized();
        }
    }

    Component.onCompleted: {
        ZBLib.appUi = objBaseAppUiRoot;
    }

    function appResized(){
        var s;
        if(objBaseAppUiRoot.scrollMode === ZBTheme.zInfiniteHeight){
            s = objBaseAppUiRoot.width;
        }
        else{
            s = objBaseAppUiRoot.height;
        }

        if(s<576){
            objBaseAppUiRoot.gridState = "xs";
        }
        else if(s>=576 && s<768){
            objBaseAppUiRoot.gridState = "sm";
        }
        else if(s>=768 && s<960){
            objBaseAppUiRoot.gridState = "md";
        }
        else if(s>=960 && s<1200){
            objBaseAppUiRoot.gridState = "lg";
        }
        else{
            objBaseAppUiRoot.gridState = "xl";
        }
    }

    function mCT(c,v){
        return ZBTheme.metaTheme.changeTransparency(c,v);
    }

    Rectangle{
        id: objLoadingScreen
        color: objBaseAppUiRoot.mCT("black",200)
        anchors.fill: parent
        visible: objBaseAppUiRoot.isAddingPage
        z: 9999999999

        FishSpinner{
            width: QbCoreOne.scale(50)
            height: QbCoreOne.scale(50)
            anchors.centerIn: parent
            useDouble: true
        }

        MouseArea{
            anchors.fill: parent
            preventStealing: true
        }
    }
}
