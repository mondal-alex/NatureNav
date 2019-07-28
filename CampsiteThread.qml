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
import QtGraphicalEffects 1.0

Item {
    signal next();
    signal back();
    // App Page
    Page{
        anchors.fill: parent
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
                Item{
                    Layout.preferredWidth: 20*app.scaleFactor
                    Layout.fillHeight: true
                }
                Label {
                    Layout.fillWidth: true
                    text: qsTr("Campsite Thread")
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: app.titleFontSize
                    color: app.headerTextColor
                }
            }
        }
        Rectangle {
            color: "lightblue"
            width: 400
            height: 700

            ColumnLayout {
                x: 10
                y: 10
                //               x: 12
 //               y: 33
                width: parent.width - 20
                height: parent.height - 20
                spacing: 5

                Rectangle {
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    color: "white"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    radius: 7

                    Rectangle {
                        radius: 7
                        Image {
                            id: maria
                            x: 8
                            y: 8
                            width: 62
                            height: 58
                            source: "./assets/maria_hiking.jpg"
                        }
                    }

                    TextEdit {
                        id: campsitePost
                        width: parent.width
 //                       lineCount: 40
 //                       height: parent.preferredHeight
 //                       Layout.alignment: parent.center
                        Text {
                            x: 94
                            y: 19
                            width: 245
                            height: 19
                            text: "Maria Peters - 4 hours ago \nLast Minute Cancellation 6/27, Zion Campsite"
                            font.bold: true
                            font.family: "Tahoma"
                            font.pointSize: 12
                        }
                    }

                    ToolButton {
                        x: 152
                        y: 105
                        width: 76
                        height: 77
                        indicator: Image{
                            width: parent.width*0.5
                            height: parent.height*0.5
                            anchors.centerIn: parent
                            source: "./assets/location.png"
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                        }
                        onClicked:{
                            // Go back previous page
                           responseWindow.visible = true;
                           lastThread.lastThread = campsitePost.text
                           lastThread.viz = true;
                        }
                    }
                }
                Rectangle {
                    id: responseWindow
                    visible: false
                    width: 200
                    color: "white"
                    height: 100
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredHeight: 300
                    radius: 7

                    GaussianBlur {
                        anchors.fill: updateWindow
                        source: mapView
                        radius: 40
                        samples: 20
                    }

                    TextField {
                        id: campsiteResponse
                        x: 0
                        y: 20
                        width: parent.width
                        font.pointSize: 15
                    }
                }

                Rectangle {
                    width: 380
                    color: "white"
                    height: 200
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredHeight: 300
                    radius: 1

                    TextEdit {
                        id: campsiteInfo
                        x: 0
                        y: 20
                        width: parent.width
                        text: "Hi everyone! I have a campsite reservation for \n" +
                              "Watchman Campground from July 31st to August 2nd \n " +
                              "My specific campsite reservation is Site \n " +
                              "A006, Loop A. Here is a link to my reservation: \n" +
                              "https://www.recreation.gov/camping/campsites/495 \n"
                        font.pointSize: 15
 //                       lineCount: 40
                        //                       height: parent.preferredHeight
                        //                       Layout.alignment: parent.center
                    }
                }
            }
        }
    }
}
