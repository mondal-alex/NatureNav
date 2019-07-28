import QtQuick 2.8
import QtQuick.Controls 2.1
import QtMultimedia 5.8

import ArcGIS.AppFramework 1.0

Drawer {
    id: settingsDrawer

    property color textColor: "yellow"
    property int textPointSize: 10
    property color backgroundColor: "#808080"

    property Camera camera

    edge: Qt.RightEdge

    Rectangle {
        anchors.fill: parent

        color: backgroundColor
    }

    Column {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        Text {
            text: qsTr("Resolution")
            font.pointSize: textPointSize
            color: textColor
        }

        ResolutionComboBox {
            width: parent.width

            camera: settingsDrawer.camera
        }

    }

}
