import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.2

import QtPositioning 5.3
import QtSensors 5.3

import "../controls"

Item {
    id: geocodeView
    property var currentPoint
    property int compassDegree: 0
    property bool isShowBackground: false
    property bool isSuggestion: true

    property string currentLocatorTaskId: ""
    property string currentQueryTaskId:""


    signal resultSelected(var point)

    ColumnLayout{
        width: Math.min(600*app.scaleFactor, parent.width)-16*app.scaleFactor
        height: parent.height-32*app.scaleFactor
        anchors.centerIn: parent

   }
}
