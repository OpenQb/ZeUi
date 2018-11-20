import QtQuick 2.11
import QtQuick.Controls 2.4

import "./../ui"

ZFlickPage {
    id: objFlickPage
    title: "ZSSFlickPage Test"
    contentHeight: c.height
    contentWidth: parent.width
    flickableDirection: Flickable.VerticalFlick
    ScrollBar.vertical: ScrollBar { }

    onContentHeightChanged: {
        console.log("W:"+objFlickPage.contentWidth);
        console.log("H:"+objFlickPage.contentHeight);
    }
    onContentWidthChanged: {
        console.log("W:"+objFlickPage.contentWidth);
        console.log("H:"+objFlickPage.contentHeight);
    }

    Column{
        id: c
        Repeater{
            model: 100
            Rectangle {
                width: 100
                height: 40
                border.width: 1
                activeFocusOnTab: true
                color: activeFocus?"black":index%2?"yellow":"blue"
                onFocusChanged: {
                    console.log("Index:"+index);
                    objFlickPage.focusXY(x,y);
                }
            }
        }
    }

}
