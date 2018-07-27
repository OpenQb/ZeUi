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

    onWidthChanged: {
        appResized();
    }

    function appResized(){
        var w = objBaseAppUi.width;
        if(w<576){
            objBaseAppUi.gridState = "xs";
        }
        else if(w>=576 && w<768){
            objBaseAppUi.gridState = "sm";
        }
        else if(w>=768 && w<960){
            objBaseAppUi.gridState = "md";
        }
        else if(w>=960 && w<1200){
            objBaseAppUi.gridState = "lg";
        }
        else{
            objBaseAppUi.gridState = "xl";
        }
    }
}
