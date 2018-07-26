.pragma library
.import "UiUno/app.js" as AppJS

/******
NOTE: This js library will be used to share instances.
******/


var pages = [];

function addPage(page){
    if(pages.indexOf(page) === -1){
        AppJS.showLoadingScreen();
        pages.push(page);
        AppJS.addPage("/pages/"+page,{"pageID":page});
    }
}

function removePage(page){
    var index = pages.indexOf(page);
    if(index !== -1){
        pages.splice(index,1);
    }
}

