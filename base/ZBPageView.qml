import QtQuick 2.10

Item {
    id: objBasePageView
    clip: true

    property int count: 0
    property int oldIndex: -1
    property int currentIndex: -1
    property var pageList: []
    property Item currentItem: null


    function pageAt(index){
        try{
            return objBasePageView.pageList[index];
        }
        catch(e){
        }
    }

    function setCurrentIndex(index){
        objBasePageView.currentItem = objBasePageView.pageList[index];
        objBasePageView.currentIndex = index;
    }

    function setCurrentPage(index){
        objBasePageView.setCurrentIndex(index);
    }

    function getCurrentPage(index){
        return objBasePageView.pageList[index];
    }

    function insertPage(index,item){
        objBasePageView.pageList.splice(index,0,item);
        objBasePageView.count = objBasePageView.pageList.length;
        objBasePageView.currentItem = item;
    }

    function removePage(index){
        if(objBasePageView.count>0){
            try{
                objBasePageView.oldIndex = -1;

                var item = objBasePageView.takePage(index);
                item.visible = false;
                item.pageClosing();
                delete item;

                return true;
            }
            catch(e){
                return false;
            }
        }
        return false;
    }

    function takePage(index){
        var i = objBasePageView.pageList[index];
        objBasePageView.pageList.splice(index,1);
        objBasePageView.count = objBasePageView.pageList.length;
        if(index === currentIndex){
            var ni = --index;
            if(ni<0) ni = 0;
            objBasePageView.currentItem = objBasePageView.pageList[ni];
            objBasePageView.currentIndex = ni;
        }
        return i;
    }


    onCurrentIndexChanged: {
        if(objBasePageView.oldIndex!==objBasePageView.currentIndex && objBasePageView.oldIndex !==-1){
            try{
                var i = objBasePageView.pageAt(objBasePageView.oldIndex);
                i.visible = false;
                i.pageHidden();
            }
            catch(e){
                console.log("Exception:"+e)
            }
        }

        try{
            objBasePageView.currentItem.pageOpened();
        }
        catch(e){
        }
    }

}
