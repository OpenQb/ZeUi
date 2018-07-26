import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

Item{
    id: objSideBar
    property alias appSideBar: objSideBarPlaceHolder
    property bool hasSideBar: objSideBarPlaceHolder.depth === 1

    function add(item){
        if(item !== null){
            objSideBarPlaceHolder.clear();
            if(objSideBarPlaceHolder.depth === 0){
                objSideBarPlaceHolder.push(item);
            }
            else{
                objSideBarPlaceHolder.replace(objSideBarPlaceHolder.currentItem,item);
            }
        }
        else{
            objSideBarPlaceHolder.clear();
        }
    }

    StackView{
        id: objSideBarPlaceHolder
        anchors.fill: parent
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0
    }
}
