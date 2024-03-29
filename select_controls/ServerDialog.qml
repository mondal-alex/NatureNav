/* Copyright 2017 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.2

import "./styles"

Rectangle {
    id: defaultDialog

    property alias usernameLabel: usernameText.text
    property alias username: usernameField.text
    property alias passwordLabel: passwordText.text
    property alias password: passwordField.text
    property bool busy: false
    property string errorDetails : ""
    property string errorMessage : ""
    property alias acceptLabel : acceptButton.text
    property alias rejectLabel : rejectButton.text

    property string signingInString: qsTr("Signing In")
    property string signInString: qsTr("Sign In")
    property string cancelString: qsTr("Cancel")

    signal accepted()
    signal rejected()

    property AppInfo appInfo

    anchors.fill: parent
    color: "#80000000"
    visible: false

    function clearText(){
        usernameField.text = "";
        passwordField.text = "";
    }

    MouseArea {
        anchors.fill: parent
        onPressAndHold: {

        }
    }

    Rectangle {
        id: content
        color: app.pageBackgroundColor
        radius: 3*app.scaleFactor
        implicitHeight: Math.min(columnContent.height + 24*AppFramework.displayScaleFactor, app.height*0.8)
        implicitWidth: Math.min(500*AppFramework.displayScaleFactor, app.width*0.8)
        width: implicitWidth
        height: implicitHeight
        clip: true
        anchors.centerIn: parent

        Flickable{
            width: parent.width - 12*AppFramework.displayScaleFactor*2
            height: parent.height
            contentWidth: columnContent.width
            contentHeight: columnContent.height + 24*AppFramework.displayScaleFactor
            anchors{
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 12*AppFramework.displayScaleFactor
            }
            Column{
                id: columnContent
                width: content.width - 12*AppFramework.displayScaleFactor*2
                height: iconWithText.height + buttons.height + columnContent.spacing
                spacing: 6*AppFramework.displayScaleFactor

                Rectangle{
                    id: iconWithText
                    width: parent.width
                    height: columnContainer.height
                    color: "transparent"

                    ColumnLayout{
                        id: columnContainer
                        width: parent.width

                        spacing: 6*app.scaleFactor

                        ImageOverlay{
                            id: icon
                            source: "../images/locker.png"
                            Layout.preferredWidth: 32*app.scaleFactor
                            Layout.preferredHeight: 32*app.scaleFactor
                            fillMode: Image.PreserveAspectFit
                            Layout.alignment: Qt.AlignHCenter
                            opacity: 0.6
                            showOverlay: app.isDarkMode
                        }

                        Text {
                            Layout.fillWidth: true
                            font.family: app.customTextFont.name
                            width: parent.width-icon.width
                            color: "red"
                            Layout.topMargin: 6*app.scaleFactor
                            Layout.bottomMargin: 6*app.scaleFactor
                            text: errorDetails
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                            maximumLineCount: 3
                            visible: text>""
                        }

                        Text {
                            id: errorText
                            Layout.fillWidth: true
                            font.family: app.customTextFont.name
                            width: parent.width-icon.width
                            color: "red"
                            Layout.topMargin: 6*app.scaleFactor
                            Layout.bottomMargin: 6*app.scaleFactor
                            text: errorMessage
                            wrapMode: Text.Wrap
                            maximumLineCount: 3
                            visible: text>""
                        }

                        Text {
                            id: usernameText

                            Layout.fillWidth: true

                            text: qsTr("Username")
                            horizontalAlignment: Text.AlignLeft
                            color: app.subtitleColor
                            font {
                                pixelSize: app.textFontSize
                                family: app.customTextFont.name
                                bold: true
                                weight: Font.Bold
                            }
                        }

                        TextField {
                            id: usernameField

                            Layout.fillWidth: true

//                            placeholderText: usernameLabel
                            text: rot13(app.settings.value("username",""))

                            style: TextFieldStyle {
                                property int buttonBorderRadius: 0
                                property real rectHeight: Text.paintedHeight + 10 * app.scaleFactor
                                property int borderWidth: 1*app.scaleFactor
                                property int rectRadius: 3*app.scaleFactor

                                renderType: Text.QtRendering
                                textColor: app.isDarkMode? "white": app.textColor
                                placeholderTextColor: app.isDarkMode? "white": app.textColor
                                background: Rectangle{
                                    color: app.isDarkMode? Qt.lighter(app.pageBackgroundColor, 1.2): "transparent"
                                    radius: rectRadius
                                    border.width: 1*app.scaleFactor
                                    border.color: app.isDarkMode? "white" : Qt.darker(app.pageBackgroundColor, 1.2)
                                }
                                font {
                                    bold: false
                                    pixelSize: app.subtitleFontSize
                                    family: app.customTextFont.name
                                }
                            }

                            activeFocusOnTab: true
                            focus: true
                            inputMethodHints: Qt.ImhNoAutoUppercase + Qt.ImhNoPredictiveText + Qt.ImhSensitiveData
                        }

                        Text {
                            id: passwordText

                            Layout.fillWidth: true

                            text: qsTr("Password")
                            horizontalAlignment: Text.AlignLeft
                            color: app.subtitleColor
                            font: usernameText.font
                        }

                        TextField {
                            id: passwordField

                            Layout.fillWidth: true
                            text: rot13(app.settings.value("password",""))

                            echoMode: TextInput.Password
//                            placeholderText: passwordLabel
                            font: usernameField.font
                            style: usernameField.style
                            activeFocusOnTab: true
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 16*app.scaleFactor
                        }
                    }
                }


                Row {
                    id: buttons
                    spacing: 6*AppFramework.displayScaleFactor
                    layoutDirection: Qt.RightToLeft
                    width: parent.width
                    clip: true

                    Button {
                        id: acceptButton
                        text: signInString
                        width: 80*AppFramework.displayScaleFactor
                        style: buttonCustomSytle
                        onClicked: {
                            app.focus = true;
                            errorDetails = "";
                            errorMessage = "";

                            accepted()//tryClick();
                            Qt.inputMethod.hide();
                            serverDialog.visible = false;
                        }

                        function tryClick() {
                            if (!enabled) {
                                return;
                            }

                            busy = true;
                            errorDetails = "";
                            errorMessage = "";

                            app.username = username.trim();
                            app.password = password.trim();
                            Qt.inputMethod.hide();
                            accepted()
                        }
                    }

                    Button {
                        id: rejectButton
                        text: cancelString
                        style: buttonCustomSytle
                        width: 80*AppFramework.displayScaleFactor
                        onClicked:{
                            app.focus = true;
                            errorDetails = "";
                            errorMessage = "";

                            defaultDialog.visible = false
                            Qt.inputMethod.hide();
                        }
                    }
                }

            }
        }

        BusyIndicator {
            id: busyIndicator
            running: busy
            anchors.centerIn: parent
        }

    }

    Component{
        id: buttonCustomSytle
        ButtonStyle{
            background: Rectangle{
                radius: 2*AppFramework.displayScaleFactor
                width: parent.width
                height: parent.height
                clip: true
                color: app.pageBackgroundColor
                border.width: 1
                border.color: app.isDarkMode? "white":"#888"
            }

            label: Text{
                color: app.isDarkMode? "white": app.textColor
                text: control.text
                clip: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

    }

}
