import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4


SwipeView{
    id: objBasePageView

    function getPage(index){
        return objBasePageView.itemAt(index);
    }

    function insertPage(index,item){
        objBasePageView.insertItem(index,item);
    }

    function setCurrentPage(index){
        objBasePageView.setCurrentIndex(index)
    }

    function takePage(index){
        return objBasePageView.takeItem(index);
    }

    function removePage(index){
        if(objBasePageView.count>0){
            try{
                var item = objBasePageView.takePage(index);
                item.visible = false;
                item.focus = false;
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
}
