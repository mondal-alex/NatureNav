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


Page {
//    id: app
    width: 414
    height: 736

    signal back();

//    property real scaleFactor: AppFramework.displayScaleFactor

    property string damageType
    property var selectedFeature: null

    //header bar
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
                text: qsTr("Campsite Map")
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pixelSize: app.titleFontSize
                color: app.headerTextColor
            }
        }
    }

    // Create MapView that contains a Map
    MapView {
        id: mapView
        anchors.fill: parent
        wrapAroundMode: Enums.WrapAroundModeDisabled

        Map {
            // Set the initial basemap to Streets
            BasemapStreets { }

            // set viewpoint over The United States
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
                    // "https://sampleserver6.arcgisonline.com/arcgis/rest/services/DamageAssessment/FeatureServer/0"
                    url: "https://sampleserver6.arcgisonline.com/arcgis/rest/services/DamageAssessment/FeatureServer/0"

                    // make sure edits are successfully applied to the service
                    onApplyEditsStatusChanged: {
                        if (applyEditsStatus === Enums.TaskStatusCompleted) {
                            console.log("successfully updated feature");
                        }
                    }

                    // signal handler for the asynchronous updateFeature method
                    onUpdateFeatureStatusChanged: {
                        if (updateFeatureStatus === Enums.TaskStatusCompleted) {
                            // apply the edits to the service
                            featureTable.applyEdits();
                        }
                    }
                }

                // signal handler for selecting features
                onSelectFeaturesStatusChanged: {
                    if (selectFeaturesStatus === Enums.TaskStatusCompleted) {
                        if (!selectFeaturesResult.iterator.hasNext)
                            return;

                        selectedFeature = selectFeaturesResult.iterator.next();
                        damageType = selectedFeature.attributes.attributeValue("typdamage");

                        // show the callout
                        callout.showCallout();

                        // set the combo box's default value
                        damageComboBox.currentIndex = featAttributes.indexOf(damageType);
                    }
                }
            }
        }

        QueryParameters {
            id: params
        }

        // hide the callout after navigation
        onViewpointChanged: {
            if (callout.visible)
                callout.dismiss();
            updateWindow.visible = false;
        }

        onMouseClicked: {
            // reset the map callout and update window
            featureLayer.clearSelection();
            if (callout.visible)
                callout.dismiss();
            updateWindow.visible = false;
           current.current_location = mapView.screenToLocation(mouse.x, mouse.y);
           console.log(current.current_location.x)
           console.log(current.current_location.y)
           mapView.identifyLayerWithMaxResults(featureLayer, mouse.x, mouse.y, 10, false, 1);
        }

        onIdentifyLayerStatusChanged: {
            if (identifyLayerStatus === Enums.TaskStatusCompleted) {
                if (identifyLayerResult.geoElements.length > 0) {
                    // get the objectid of the identifed object
                    params.objectIdsAsInts = [identifyLayerResult.geoElements[0].attributes.attributeValue("objectid")];
                    // query for the feature using the objectid
                    featureLayer.selectFeaturesWithQuery(params, Enums.SelectionModeNew);
                }
            }
        }

        calloutData {
            // HTML to style the title text by centering it, increase pt size,
            // and bolding it.
            title: "<br><b><font size=\"+2\">%1</font></b>".arg("Campsite Info")
            location: selectedFeature ? selectedFeature.geometry : null
        }

        Callout {
            id: callout
            calloutData: parent.calloutData;
            borderColor: "lightgrey"
            borderWidth: 1
            leaderPosition: leaderPositionEnum.Automatic
            onAccessoryButtonClicked: {
                updateWindow.visible = true;
            }
        }
    }
    // Update Window
     Rectangle {
         id: updateWindow
         width: 300
         height: 200
         anchors.centerIn: parent
         radius: 1
         visible: false

         GaussianBlur {
             anchors.fill: updateWindow
             source: mapView
             radius: 40
             samples: 20
         }

         Grid {
              id: campsiteInfo
              x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4; anchors.topMargin: 4
              rows: 3; columns: 1; spacing: 3
              width: parent.width;
              height: parent.height;

              Rectangle {
                  color: "lightgray";
                  width: parent.width - 10;
                  height: parent.height/3 - 50;

                  Text {
                      anchors.centerIn: parent
                      text: "Zion Campsite 1"
                  }
              }


              /* Weather Rectangle */
              ToolButton {
                  width: parent.width - 8;
                  height: parent.height/3 - 20;
                  background: Rectangle{
                      color: "lightblue";
                      implicitWidth: parent.width - 8;
                      implicitHeight: parent.height/3 + 50;
                 }
                 text: "Weather"
                 Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                 onClicked:{
                     // Go to campsite thread
                     stackView.push(weather)
                 }
             }

              ToolButton {
//                  x: 40;
                  width: parent.width - 8;
                  height: parent.height/2 - 20;
  //                    Layout.margins: 5
                  background: Rectangle{
                      color: "lightblue";
                      implicitWidth: parent.width - 8;
                      implicitHeight: parent.height/3 + 50;
                  }
                  text: "Campsite Thread"
                  opacity: 2
                  Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                  onClicked:{
                      // Go to campsite thread
                      stackView.push(campsitethread)
                  }
             }
        }
    }
}
