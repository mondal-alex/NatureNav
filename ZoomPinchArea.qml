import QtQuick 2.8
import QtMultimedia 5.8

PinchArea {
    id: pinchArea

    property real pinchInitialZoom: 1.0
    property real pinchScale: 1.0
    property Camera camera

    signal zoomChanged(real zoom)
    signal clicked()

    onPinchStarted: {
        pinchInitialZoom = camera.digitalZoom * camera.opticalZoom
        pinchScale = 1.0;
    }

    onPinchUpdated: {
        pinchScale = pinch.scale;
        setZoom(pinchInitialZoom * pinchScale);
    }

    function setZoom(newZoom) {
        newZoom = Math.max(Math.min(newZoom, camera.maximumDigitalZoom * camera.maximumOpticalZoom), 1.0);

        if (newZoom === camera.digitalZoom * camera.opticalZoom) {
            return;
        }

        var newOpticalZoom = 1.0;
        var newDigitalZoom = 1.0;

        if (newZoom > camera.maximumOpticalZoom) {
            newOpticalZoom = camera.maximumOpticalZoom;
            newDigitalZoom = newZoom / camera.maximumOpticalZoom;
        } else {
            newOpticalZoom = newZoom;
            newDigitalZoom = 1.0;
        }

        if (camera.maximumOpticalZoom > 1.0) {
            camera.opticalZoom = newOpticalZoom;
        }

        if (camera.maximumDigitalZoom > 1.0) {
            camera.digitalZoom = newDigitalZoom;
        }

        //showFadingMessage(qsTr("%1x").arg(camera.zoom));
        zoomChanged(newZoom)
    }

    MouseArea {
        anchors.fill: parent

        onClicked: pinchArea.clicked()
    }
}
