.pragma library

var objAppUi;
var objAppTheme;
var objTopToolBar;
var objMainView;
var objBottomToolBar;
var objPackageReader;
var objLeftDock;

var appToolBarLoader;
var appStatusBarLoader;
var appBottomBarLoader;


var objLeftSideBar;
var objRightSideBar;

var appLeftSideBarLoader;
var appRightSideBarLoader;

var objAndroidExtras;


var theme;

function setup(appUi){
    objAppUi = appUi;
    theme = objAppTheme;

    var themeOne = {};
    themeOne["primary"] = "#004361";
    themeOne["secondary"] = "#007290";
    themeOne["accent"] = "#007290";
    themeOne["background"] = "white";
    themeOne["foreground"] = "black";
    themeOne["theme"] = "dark";
    setTheme(themeOne);
}

function setTheme(jsobject){
    objAppTheme.setThemeFromJsonData(JSON.stringify(jsobject));
}

function getTheme(){
    return objAppTheme;
}

function appId(){
    return objAppUi.appId;
}

function addPage(page,jsobject){
    objAppUi.pushPage(page,jsobject);
}

function isAddingPage(){
    return objAppUi.isAddingPage;
}

function addRemotePage(page,jsobject){
    objAppUi.addRemotePage(page,jsobject);
}

function getCurrentPage(){
    return objAppUi.getCurrentPage();
}

function closePage(index){
    objAppUi.removePage(index);
}

function closeCurrentPage(){
    objAppUi.popPage();
}

function removePage(index){
    objAppUi.removePage(index);
}

function isDark(color){
    return objAppTheme.isDark(color);
}


function showLeftSideBar(){
    objAppUi.showLeftSideBar();
}

function hideLeftSideBar(){
    objAppUi.hideLeftSideBar();
}

function showLoadingScreen(){
    objAppUi.showLoadingScreen();
}

function hideLoadingScreen(){
    objAppUi.hideLoadingScreen();
}

/* Methods for LeftDock */
function addDockItem(icon,title,callable){
    objLeftDock.addIcon({"icon":icon,"title":title});
    objLeftDock.callableList.push(callable);
}

function insertDockItem(index,icon,title,callable){
    objLeftDock.insertIcon(index,{"icon":icon,"title":title});
    objLeftDock.callableList.splice(index, 0, callable);
}

function pushDockItem(icon,title,callable){
    objLeftDock.addDockItem(icon,title,callable);
}

function popDockItem(){
    var i = totalDockItems()-1;
    var di = dockItemAt(i);
    removeDockItemByIndex(i);
    di["callable"] = objLeftDock.callableList[i];
    objLeftDock.callableList.splice(i, 1);
    return di;
}

function totalDockItems(){
    return objLeftDock.totalIcons;
}

function clearDockItems(){
    objLeftDock.clearAllIcons();
    objLeftDock.callableList.clear();
}

function dockItemAt(index){
    var di = objLeftDock.iconAt(index);
    di["callable"] = objLeftDock.callableList[i];
    return di;
}

function removeDockItemByIndex(index){
    try{
        objLeftDock.removeIcon(index);
        objLeftDock.callableList.splice(index, 1);
    }
    catch(e){
        console.log("ERROR on removeDockItemByIndex: "+index);
        console.log(e);
    }
}
/* END Methods for LeftDock */




function onGridStateChanged(callable){
    if(callable){
        objAppUi.gridStateChanged.connect(callable);
        callable();
    }
}

function gridState(){
    return objAppUi.gridState;
}

function showDock(){
    objLeftDock.open();
}

function hideDock(){
    objLeftDock.close();
}

/** Different path resolver **/
function resolveURL(path){
    return objAppUi.absoluteURL(path);
}

function resolvePath(path){
    return objAppUi.absolutePath(path);
}

function resolveDataPath(path){
    return objAppUi.absoluteDataPath(path);
}

function resolveDatabasePath(dbname){
    return objAppUi.absoluteDatabasePath(dbname);
}

/** QbAppPackageReader methods **/
function isFile(rpath){
    return objPackageReader.isFile(rpath);
}

function isExists(rpath){
    return objPackageReader.isExists(rpath);
}

function fileList(rpath){
    return objPackageReader.fileList(rpath);
}

function getList(rpath){
    return objPackageReader.getList(rpath);
}

function getFile(rpath){
    return objPackageReader.get(rpath);
}

function extract(src,dest){
    return objPackageReader.extract(src,dest);
}
/** END QbAppPackageReader **/


/** Android related things **/
function showAndroidStatusBar(){
    if(Qt.platform.os !== "android") return;

    objTopToolBar.height = objAppUi.dpscale(75);
    objTopToolBar.appStatusBarHeight = objAppUi.dpscale(25);
    objLeftDock.topBlockHeight = objAppUi.dpscale(25);
    objAndroidExtras.showSystemUi();
}

function hideAndroidStatusBar(){
    if(Qt.platform.os !== "android") return;
    objAndroidExtras.hideSystemUi();
    objTopToolBar.height = objAppUi.dpscale(50);
    objTopToolBar.appStatusBarHeight = 0;
    objLeftDock.topBlockHeight = 0;
}

function enableAndroidFullScreen(){
    if(Qt.platform.os !== "android") return;
    objAndroidExtras.enableFullScreen();
    objTopToolBar.height = objAppUi.dpscale(50);
    objTopToolBar.appStatusBarHeight = 0;
    objLeftDock.topBlockHeight = 0;
}

function disableAndroidFullScreen(){
    if(Qt.platform.os !== "android") return;
    objAndroidExtras.disableFullScreen();
    objTopToolBar.height = objAppUi.dpscale(75);
    objTopToolBar.appStatusBarHeight = objAppUi.dpscale(25);
    objLeftDock.topBlockHeight = objAppUi.dpscale(25);
}
