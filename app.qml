import QtQuick 2.10
import QtQuick.Controls 2.4

import "ui/"
import "base/"

ZAppUi{
    id: objMainAppUi

    Keys.forwardTo: [objMenu]

    ZBMenu{
        id: objMenu
        //height: 300
        menuItemModel: ListModel{
            ListElement{
                //icon: "image://qbcore/01?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 1"
            }
            ListElement{
                //icon: "image://qbcore/02?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 2"
            }
            ListElement{
                //icon: "image://qbcore/03?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 3"
            }
            ListElement{
                //icon: "image://qbcore/04?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 4"
            }
            ListElement{
                //icon: "image://qbcore/05?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 5"
            }
            ListElement{
                //icon: "image://qbcore/06?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 6"
            }
            ListElement{
                //icon: "image://qbcore/07?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 7"
            }
            ListElement{
                //icon: "image://qbcore/08?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 8"
            }
            ListElement{
                //icon: "image://qbcore/09?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 9"
            }
            ListElement{
                //icon: "image://qbcore/10?backgroundColor=0;0;0;0&borderColor=0;0;0;0"
                title: "Test 10"
            }
        }
    }
    Component.onCompleted: {
        objMenu.open(100,100);
    }

    //    ZSideDockSmartView{
    //        id: objDockView
    //        anchors.top: parent.top
    //        height: parent.height
    //        dockLogo: "image://letter-image/Z"
    //        onLogoClicked: {
    //            console.log("logo clicked");
    //        }
    //        onExitClicked: {
    //            //objMainAppUi.close();
    //        }

    //        dockItemModel: ListModel{
    //            ListElement{
    //                icon: "mf-widgets"
    //                title: "Test"
    //            }
    //        }
    //        Component.onCompleted: {
    //            objDockView.open();
    //        }
    //    }


}
