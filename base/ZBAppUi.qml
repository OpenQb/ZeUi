import Qb 1.0
import QbEx 1.0
import Qb.Core 1.0
import QtQuick 2.10

QbApp {
    id: objBaseAppUi
    minimumHeight: 550
    minimumWidth: 500
    property string gridState: "xs"
    property bool isAddingPage: false;
    property int scrollMode: 0
    /*
      0 - infinite height. fixed width
      1 - infinite width. fixed height
    */
    onWidthChanged: {
        if(objBaseAppUi.scrollMode === 0){
            appResized();
        }
    }
    onHeightChanged: {
        if(objBaseAppUi.scrollMode === 1){
            appResized();
        }
    }

    function appResized(){
        var s;
        if(objBaseAppUi.scrollMode === 0){
            s = objBaseAppUi.width;
        }
        else{
            s = objBaseAppUi.height;
        }

        if(s<576){
            objBaseAppUi.gridState = "xs";
        }
        else if(s>=576 && s<768){
            objBaseAppUi.gridState = "sm";
        }
        else if(s>=768 && s<960){
            objBaseAppUi.gridState = "md";
        }
        else if(s>=960 && s<1200){
            objBaseAppUi.gridState = "lg";
        }
        else{
            objBaseAppUi.gridState = "xl";
        }
    }
}
