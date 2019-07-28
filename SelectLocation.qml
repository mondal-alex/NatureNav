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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtPositioning 5.8
import QtSensors 5.8

import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.5
import Esri.ArcGISRuntime.Toolkit.Controls 100.5

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import QtPositioning 5.3
import QtSensors 5.3


Item {
    signal next();
    signal back();
    // App Page
    Page{
        id: page
        anchors.rightMargin: -8
        anchors.bottomMargin: 0
        anchors.leftMargin: 8
        anchors.topMargin: 0
        anchors.fill: parent
        width: 414
        height: 736
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
                Item{
                    Layout.preferredWidth: 20*app.scaleFactor
                    Layout.fillHeight: true
                }
                Label {
                    Layout.fillWidth: true
                    text: qsTr("ReportMap")
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: app.titleFontSize
                    color: app.headerTextColor
                }
            }
        }
        Rectangle {
            width: parent.width
            height: parent.height

            // Create MapView that contains a Map
            MapView {
                id: mapView2
                anchors.fill: parent
                wrapAroundMode: Enums.WrapAroundModeDisabled

                Map {
                    // Set the initial basemap to Streets
                    BasemapStreets { }

                    // set initial viewpoint to The United States
                    ViewpointCenter {
                        Point {
                            x: -10800000
                            y: 4500000
                            spatialReference: SpatialReference {
                                wkid: 102100
                            }
                        }
                        targetScale: 3e7
                    }

                    FeatureLayer {
                        id: featureLayer

                        // declare as child of feature layer, as featureTable is the default property
                        ServiceFeatureTable {
                            id: featureTable
                            url: "https://sampleserver6.arcgisonline.com/arcgis/rest/services/DamageAssessment/FeatureServer/0"

                            // make sure edits are successfully applied to the service
                            onApplyEditsStatusChanged: {
                                if (applyEditsStatus === Enums.TaskStatusCompleted) {
                                    console.log("successfully added feature");
                                }
                            }

                            // signal handler for the asynchronous addFeature method
                            onAddFeatureStatusChanged: {
                                if (addFeatureStatus === Enums.TaskStatusCompleted) {
                                    // apply the edits to the service
                                    featureTable.applyEdits();
                                }
                            }
                        }
                    }
                }

                //! [AddFeaturesFeatureService new feature at mouse click]
                onMouseClicked: {  // mouseClicked came from the MapView
                    // create attributes json for the new feature
                    var featureAttributes = {"typdamage" : "Minor", "primcause" : "Earthquake"};

                    // create a new feature using the mouse's map point
                    var feature = featureTable.createFeatureWithAttributes(featureAttributes, mouse.mapPoint);

                    // add the new feature to the feature table
                    featureTable.addFeature(feature);

                    gotoReport.visible = true;
                    hehe.visible = true;
                }
                //! [AddFeaturesFeatureService new feature at mouse click]
            }
        }

        // Update Window
         Rectangle {
             id: gotoReport
             width: 150
             height: 50
             anchors.centerIn: parent
             radius: 7
             visible: false

             GaussianBlur {
                 anchors.fill: gotoReport
                 source: mapView2
                 radius: 40
                 samples: 20
             }

             Grid {
                  id: gridgotoReport
                  x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4; anchors.topMargin: 4
                  rows: 1; columns: 1; spacing: 3
                  width: parent.width;
                  height: parent.height;

                  /* Weather Rectangle */
                  ToolButton {
                      width: parent.width - 8;
                      height: parent.height - 20;
                      background: Rectangle{
                          id: inner
                          color: "lightblue";
                          implicitWidth: parent.width - 8;
                          implicitHeight: parent.height - 20;
                          radius: 7

                          GaussianBlur {
                              anchors.fill: inner
                              source: mapView2
                              radius: 40
                              samples: 20
                          }
                     }
                     text: "Add Report Info"
                     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                     onClicked:{
                         // Go to campsite thread
                         stackView.push(locationReport)
                     }
                 }
            }
        }
    }
}
