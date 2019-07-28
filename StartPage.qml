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
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtWebView 1.1
import "./controls"

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.4

Item {
    signal next();
    signal back();
    // App Page
    Page{
        anchors.rightMargin: 0
        anchors.bottomMargin: -8
        anchors.leftMargin: 0
        anchors.topMargin: 8
        background: Image {source: "./assets/bground.jpg"}
        anchors.fill: parent
        // Adding App Page Header Section
        header: ToolBar{
            id:header
            contentHeight: 56 * app.scaleFactor
            Material.primary: app.primaryColor

            RowLayout{
                anchors.fill: parent
                spacing:0

                ToolButton {
                    indicator: Image{
                        width: parent.width*0.5
                        height: parent.height*0.5
                        x: 400
                        anchors.centerIn: parent
                        source: "./assets/next.png"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }
                    onClicked:{
                        // Go back previous page
                        next();
                    }
                }

                Item{
                    Layout.preferredWidth: 16*app.scaleFactor
                    Layout.fillHeight: true
                }

                Label {
                    Layout.fillWidth: true
                    text: qsTr("Login")
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: app.titleFontSize
                    color: app.headerTextColor
                }               
            }
        }

        ColumnLayout {
            spacing: 0

            ToolButton {
                id: toolButton
                Image { x: 216; y: 13; width: 237; height: 238; anchors.horizontalCenterOffset: 188; anchors.horizontalCenter: parent.horizontalCenter;source: "assets/logo_clear.PNG"}
                width: 10
               height: 10
           }

            ToolButton {
                width: 100
                Image { x: 121; y: 231; width: 176; height: 142;source: "assets/google_g.png"}
                height: 25* AppFramework.displayScaleFactor
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    browser.stop();
                    browser.visible = true
                    browser.url = "https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=urn:ietf:wg:oauth:2.0:oob:auto&response_type=code&client_id=628047675110-k1er45mckjk00ve6lu7c6kvmfm7o6ts1.apps.googleusercontent.com"
                }
            }
             ToolButton {
                 width: 300
                 Image { x: 128; y: 393; width: 171; height: 151;source: "assets/facebook_f.png"}
                 height: 41
                 Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                    browser.stop();
                    browser.visible = true
                    browser.url = "https://www.facebook.com/dialog/oauth?client_id=250484821629866&response_type=token&redirect_uri=https://www.facebook.com/connect/login_success.html"
                }
            }
       }
        ContentBlock {

            Text {
                id: someText
                visible: !browser.visible
                text: ""
                anchors.margins: 20* AppFramework.displayScaleFactor
                anchors.centerIn: parent
                width: parent.width
                wrapMode: Text.WrapAnywhere
            }

            WebView {
                id: browser
                width: parent.width
                height: parent.height

                property var startTime
                property var loadTime

                BusyIndicator {
                    running: browser.loading
                    z:111
                    anchors.centerIn: browser
                }

//                onNavigationRequested: {
//                    console.log("URL: ", url)
//                }

                onTitleChanged: {
                    console.log("Title: ", title);
                }

//                onJavaScriptConsoleMessage: {
//                    console.log(message, sourceID, lineNumber)
//                }

                onUrlChanged: {
                    console.log("Url changed: ", url)
                }

                onLoadProgressChanged: {

                    console.log(startTime, loadTime, loadProgress);

                    if(loadProgress < 11) {
                        startTime = new Date().valueOf();
                        console.log(startTime, loadTime, loadProgress);
                    }

                    if(loadProgress == 100) {
                        loadTime = new Date().valueOf();
                        console.log(startTime, loadTime, loadProgress);
                        loadTime = loadTime - startTime;
                        console.log("Total load time: ", loadTime/1000, "secs")
                    }
                }

                onLoadingChanged: {

                    if (title.toLowerCase().indexOf("success code=") > -1) {
                        var authCode = title.replace(/success code=/i, "");
                        console.log("Auth Code is: ", authCode)
                        someText.text = authCode;
                        browser.visible = false;
                    }

                    if (title.toLowerCase().indexOf("https://www.facebook.com/connect/login_success.html#access_token=") > -1) {
                        var authCode = title.replace("https://www.facebook.com/connect/login_success.html#access_token=", "");
                        console.log("Auth Code is: ", authCode)
                        someText.text = authCode;
                        browser.visible = false;
                    }
                }
            }
        }

        Text {
            id: text1
            x: 156
            y: 662
            width: 81
            height: 20
            color: "#ffffff"
            text: "<a href='http://www.facebook.com'>Facebook Login</a>"
            onLinkActivated: Qt.openUrlExternally(link)
            font.pixelSize: 16
        }

        Text {
            id: text2
            x: 165
            y: 434
            width: 93
            height: 15
            color: "#fefefe"
            text:  "<a href='http://www.facebook.com'>Google Login</a>"
            onLinkActivated: Qt.openUrlExternally(link)
            font.pixelSize: 16
        }
    }
}
