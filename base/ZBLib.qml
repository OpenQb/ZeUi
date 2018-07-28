pragma Singleton

import QtQuick 2.10


QtObject {
    id: objBaseLib

    function addPage(appUi,pageView,page,jsobject){
        try{
            jsobject["appId"] = appUi.appId;
        }
        catch(e){
            console.log("Failed to push appId");
        }


    }

    function removePage(appUi,pageView,index){
        if(pageView.removePage(index)) appUi.pageRemovedIndex(index);
    }
}
