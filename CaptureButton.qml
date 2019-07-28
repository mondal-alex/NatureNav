import QtQuick 2.8
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0

Item {
    id: captureButton

    property int size: 48 * AppFramework.displayScaleFactor
    property color color: "white"
    property color hoverColor: "yellow"

    width: size
    height: size

    signal clicked()

    Image {
        id: image

        anchors.fill: parent

        source: "Images/camera.png"
    }

    ColorOverlay {
        id: colorOverlay

        anchors.fill: image

        source: image
        color: mouseArea.mouseOver ? captureButton.hoverColor : captureButton.color
    }

    MouseArea {
        id: mouseArea

        property bool mouseOver: false
        anchors.fill: parent

        hoverEnabled: true


        onClicked: captureButton.clicked()

        onEntered: mouseOver = true
        onExited: mouseOver = false

    }

}
