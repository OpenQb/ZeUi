import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "./../base"

Item {
    id: objField

    activeFocusOnTab: true
    width: 200
    height: 40

    property alias fieldText: objTextField.text
    property alias textInputItem: objTextField

    property string label: "Label"
    property int labelWidth: 20
    property bool fieldReadOnly: false
    property bool isFixedWidthForLabel:false
    property bool useAlternateColor: false

    property int radious: 0
    property int borderWidth: 0
    property color borderColor: ZBTheme.metaTheme.idarker(ZBTheme.accent,20)//ZBTheme.accent
    property color backgroundColor: ZBTheme.background

    property color labelFieldBackgroundColor: ZBTheme.background//useAlternateColor?ZBTheme.metaTheme.analagousColor(ZBTheme.accent)[0]:ZBTheme.accent
    property color labelFieldColor: ZBTheme.accent
    property color labelFieldTextColor: ZBTheme.metaTheme.textColor(labelFieldBackgroundColor)

    property color textFieldBackgroundColor: ZBTheme.metaTheme.idarker(labelFieldBackgroundColor,20)
    property color textFieldColor: ZBTheme.accent
    property color textFieldTextColor: ZBTheme.metaTheme.textColor(textFieldBackgroundColor)

    onActiveFocusChanged: {
        if(activeFocus){
            objTextField.forceActiveFocus();
        }
    }

    Rectangle{
        id: objBackground
        anchors.fill: parent
        anchors.centerIn: parent
        radius: objField.radious
        color: objField.backgroundColor
        border.width: objField.borderWidth
        border.color:objField.borderColor


        Row{
            anchors.fill: parent
            spacing: 0

            Rectangle{
                id: objLabelField
                width: objField.isFixedWidthForLabel?objField.labelWidth:parent.width*(objField.labelWidth/100.0)
                height: parent.height
                clip: true
                color: objField.labelFieldBackgroundColor
                border.width: objField.borderWidth
                border.color: objField.borderColor
                Text{
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    width: parent.width
                    color: objField.labelFieldTextColor
                    text: objField.label
                }
            }

            Rectangle{
                width: parent.width - objLabelField.width
                height: parent.height
                color: objField.textFieldBackgroundColor
                border.width: objField.borderWidth
                border.color: objField.borderColor
                clip: true

                TextInput{
                    id: objTextField
                    anchors.fill: parent
                    selectionColor: "lightblue"
                    selectedTextColor: "black"
                    color: objField.textFieldTextColor
                    anchors.leftMargin: 10
                    anchors.rightMargin: 5
                    readOnly: objField.fieldReadOnly
                    inputMethodHints: Qt.ImhNoPredictiveText
                    verticalAlignment: TextInput.AlignVCenter
                    activeFocusOnPress: true
                    activeFocusOnTab: false
                    Keys.onReturnPressed: nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)
                    Keys.onEnterPressed: nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)
                    MouseArea{
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: {
                            var startPosition = objTextField.positionAt(mouse.x, mouse.y);
                            //console.log("Start pos:"+startPosition);
                            //console.log("Length:"+objTextField.text.length);
                            if(objTextField.text.length === 0){
                                objTextField.cursorPosition = 0;
                            }
                            else{
                                objTextField.cursorPosition = startPosition;
                            }
                            objTextField.focus = false;
                            objTextField.forceActiveFocus();
                            if (mouse.button === Qt.RightButton){
                                objContextMenu.popup(mouse.x,mouse.y);
                            }
                        }
                        onPressed: {
                            var startPosition = objTextField.positionAt(mouse.x, mouse.y);
                            objTextField.cursorPosition = startPosition;
                            objTextField.forceActiveFocus();
                        }

                    }
                    Menu{
                        id: objContextMenu
                        //x: parent.width - width
                        MenuItem {
                            text: "Paste"
                            onTriggered: {
                                objTextField.text = QbCoreOne.textFromClipboard();
                            }
                        }
                        MenuItem {
                            text: "Copy"
                            onTriggered: {
                                QbCoreOne.copyTextToClipboard(objTextField.text);
                            }
                        }
                        MenuItem {
                            text: "Close"
                            onTriggered: {
                                objContextMenu.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
