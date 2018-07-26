import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

Item{
    id: objBottomToolBar
    property alias appBottomBar: objPlaceHolder
    property bool hasBottomBar: objPlaceHolder.depth === 1


    function add(item){
        if(item !== null){
            if(objPlaceHolder.depth === 0){
                objPlaceHolder.push(item);
            }
            else{
                objPlaceHolder.replace(objPlaceHolder.currentItem,item);
            }
        }
        else{
            objPlaceHolder.clear();
        }
    }

    StackView{
        id: objPlaceHolder
        anchors.fill: parent
    }
}
