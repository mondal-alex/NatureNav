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
//import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls 2.5


Item {
    signal next();
    signal back();
    // App Page
    Page {
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent

        background: Image {source: "./assets/bground.jpg"}

        // Adding App Page Header Section

        header: ToolBar{
            id:header

            contentHeight: 56 * app.scaleFactor
            Material.primary: app.primaryColor
            RowLayout{
                anchors.fill: parent
                spacing:0
                Item{
                    Layout.preferredWidth: 4*app.scaleFactor
                    Layout.fillHeight: true
                }
                ToolButton {
                    indicator: Image{
                        width: parent.width*0.5
                        height: parent.height*0.5
                        anchors.centerIn: parent
                        source: "./assets/back.png"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }
                    onClicked:{
                        // Go back previous page
                        back();
                    }
                }
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
                ToolButton {
                    indicator: Image{
                        width: parent.width*0.5
                        height: parent.height*0.5
                        x: 400
                        anchors.centerIn: parent
                        source: "./assets/pin.png"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }
                    onClicked:{
                        // Go back previous page
                        stackView.push(selectLocation);
                    }
                }
                Item{
                    Layout.preferredWidth: 20*app.scaleFactor
                    Layout.fillHeight: true
                }
                Label {
                    Layout.fillWidth: true
                    text: qsTr("Home")
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: app.titleFontSize
                    color: app.headerTextColor
                }
            }
        }
        Rectangle {
            x: 120
            y: 250
            width: 175
            height: 50
            radius: 5
            visible: !lastPhoto.viz || !lastThread.viz

            Image{
                width: parent.width
                height: parent.height
                source:"./assets/obground.jpg"
            }
            ToolButton {
                width: parent.width
                height: parent.height
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Text { x: 25; y: 17; width: 80; height: 16;text: "Plan Adventure"
                    font.pointSize: 18
                    color: "white"}
                onClicked:{
                    // go to campsite map
                    next();
                }
            }
        }
        Rectangle {
            id: yourReport
            x: 84
            y: 104
            width: 243
            height: 240
            radius: 5
            visible: lastPhoto.viz
            Image{
                x: 10
                y: 10
                width: parent.width - 20
                height: parent.height - 20
                source: "./Images/"+lastPhoto.lastPhoto
            }
        }
        Rectangle {
            color: "white"
            radius: 5
            x: 30
            y: 446
            width: 356
            height: 79
            visible: lastThread.viz

            TextEdit {
                id: campsitePost
                x: 0
                y: 70
                width: parent.width
                //                       lineCount: 40
    //                       height: parent.preferredHeight
    //                       Layout.alignment: parent.center
                visible: lastThread.viz
                Text {
                    visible:lastThread.viz
                    x: 75
                    y: -42
                    width: 245
                    height: 19
                    text: "Maria Peters - 4 hours ago \nLast Minute Cancellation 6/27, Zion Campsite"
                    font.bold: true
                    font.family: "Tahoma"
                    font.pointSize: 12
                }
            }
        }
        Rectangle {
            visible: lastThread.viz
            Image {
                id: maria1
                x: 37
                y: 458
                width: 62
                height: 58
                source: "./assets/maria_hiking.jpg"
            }
        }

        Rectangle {
            visible: lastThread.viz
            Image {
                id: campsiteIcon
                x: 170
                y: 360
                width: 62
                height: 58
                source: "./assets/tent-wo-white.png"
            }
        }

        Rectangle {
            visible: lastPhoto.viz
            Image {
                id: locationIcon
                x: 173
                y: 26
                width: 62
                height: 58
                source: "./assets/pin.png"
            }
        }
    }
}
