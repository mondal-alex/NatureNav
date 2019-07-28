import QtQuick 2.8
import QtQuick.Controls 2.1
import QtMultimedia 5.8

import ArcGIS.AppFramework 1.0

Rectangle {
    id: cameraView

    property alias camera: camera
    property alias videoOutput: videoOutput
    property var resolution: [camera.viewfinder.resolution.width, camera.viewfinder.resolution.height]

    signal zoomChanged(real zoom)
    signal imageCaptured()

    color: "black"

    VideoOutput {
        id: videoOutput

        anchors.fill: parent

        autoOrientation: true
        source: camera

        ZoomPinchArea {
            id: zoomPinchArea

            anchors.fill: parent

            onZoomChanged: zoomChanged(zoom)
        }
    }

    Camera {
        id: camera

        captureMode: Camera.CaptureStillImage

        focus {
        }

        exposure {
            exposureMode: Camera.ExposureAuto
        }

        viewfinder.resolution: Qt.size(640, 480)
    }

    function setZoom(newZoom)
    {
        newZoom = Math.max(Math.min(newZoom, camera.maximumZoom), 1.0);

        if (newZoom === camera.zoom) {
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

        showFadingMessage(qsTr("%1x").arg(camera.zoom));
    }

}
