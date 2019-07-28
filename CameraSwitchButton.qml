import QtQuick 2.8
import QtQuick.Controls 2.1
import QtMultimedia 5.8

Button {
    id: button

    property Camera camera

    text: qsTr("Switch")

    signal cameraSwitched(var cameraInfo);

    onClicked: {
        var cameraInfo = getCameraInfo(1);
        if (camera.deviceId !== cameraInfo.deviceId) {
            camera.stop();
            camera.deviceId = cameraInfo.deviceId;
            camera.start();
            cameraSwitched(cameraInfo);
        }
    }

    function getCameraInfo(next) {
        for (var i = 0; i < QtMultimedia.availableCameras.length; i++) {
            var cameraInfo = QtMultimedia.availableCameras[i];
            if (cameraInfo.deviceId === camera.deviceId) {
                if (next) {
                    return QtMultimedia.availableCameras[(i + next + QtMultimedia.availableCameras.length) % QtMultimedia.availableCameras.length];
                }

                return cameraInfo;
            }
        }

        return null;
    }

}

