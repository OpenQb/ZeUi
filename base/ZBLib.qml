pragma Singleton

import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10


QtObject {
    id: objBaseLib
    property Item appUi: null


    function addPage(appUi,pageView,page,jsobject){
        try{
            jsobject["appId"] = appUi.appId;
            jsobject["appUi"] = appUi;
        }
        catch(e){
            console.log("Failed to push appId");
        }

        if(!appUi.isAddingPage){
            appUi.isAddingPage = true;
            try{
                if(QbCoreOne.isSingleWindowMode() === true || QbCoreOne.isWebglPlatofrm() === true){
                    directAdd(appUi,pageView,page,jsobject);
                }
                else{
                    incubateAdd(appUi,pageView,page,jsobject);
                }
            }
            catch(e){
                incubateAdd(appUi,pageView,page,jsobject);
            }
        }
    }

    function directAdd(appUi,pageView,page,jsobject){
        //showLoadingScreen();
        var component = Qt.createComponent(page);
        if(component.status === Component.Ready){
            var nobj;
            if(jsobject !== undefined){
                nobj = component.createObject(pageView,jsobject);
            }
            else{
                nobj = component.createObject(pageView);
            }

            if(nobj){
                //console.log("Page created");
                appUi.pageAdded(nobj.title);
                pageView.insertPage(pageView.count,nobj);
            }
            else{
                console.log("Undefined object");
            }
        }
        else{
            console.log("Component is not ready yet");
        }
        appUi.isAddingPage = false;
        //hideLoadingScreen();
    }


    function incubateAdd(appUi,pageView,page,jsobject){
        //showLoadingScreen();
        var component = Qt.createComponent(page);
        var incubator = null;
        if(component.status === Component.Ready){
            if(jsobject !== undefined){
                incubator = component.incubateObject(pageView,jsobject);
            }
            else{
                incubator = component.incubateObject(pageView);
            }
        }

        if(incubator !== null){
            if (incubator.status !== Component.Ready) {
                incubator.onStatusChanged = function(status) {
                    if (status === Component.Ready) {
                        //setupPage(incubator.object);
                        appUi.isAddingPage = false;
                        appUi.pageAdded(incubator.object.title);
                        pageView.insertPage(pageView.count,incubator.object);
                    }
                    else if(status === Component.Error){
                        appUi.isAddingPage = false;
                        console.log("Error on adding page: "+component.errorString());
                    }
                    //hideLoadingScreen();
                }
            }
            else {
                appUi.isAddingPage = false;
                appUi.pageAdded(incubator.object.title);
                pageView.insertPage(pageView.count,incubator.object);
                //setupPage(incubator.object);
                //hideLoadingScreen();
            }
        }
        else{
            appUi.isAddingPage = false;
            console.log("Error on adding page: "+component.errorString());
            //hideLoadingScreen();
        }
    }

    function removePage(appUi,pageView,index){
        if(pageView.removePage(index)) appUi.pageRemovedIndex(index);
    }

    function getGridState(s){
        var gridState="xs";
        if(s<576){
            gridState = "xs";
        }
        else if(s>=576 && s<768){
            gridState = "sm";
        }
        else if(s>=768 && s<960){
            gridState = "md";
        }
        else if(s>=960 && s<1200){
            gridState = "lg";
        }
        else{
            gridState = "xl";
        }

        return gridState;
    }
}
