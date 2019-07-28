import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtMultimedia 5.8

import QtQuick 2.7
import QtQuick.Layouts 1.1
//import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls 2.5

import ArcGIS.AppFramework 1.0

Item {
    signal next();
    signal back();

    property bool loading: true
    property string cameraFolderName: qsTr("Camera Roll")

    function pad(n, z) { return ("0000000" + n).substr(-z); }

    function dateStamp(d) {
      return pad(d.getUTCFullYear(), 4)
        + pad(d.getUTCMonth() + 1, 2)
        + pad(d.getUTCDate(), 2)
        + "_"
        + pad(d.getUTCHours(), 2)
        + pad(d.getUTCMinutes(), 2)
        + pad(d.getUTCSeconds(), 2)
      ;
    }

    function capturePhoto() {
        cameraFileFolder.makeFolder();

        var photoFileName = "PHOTO_" + dateStamp(new Date()) + ".jpg";

//        lastPhoto.lastPhoto = "fallen_tree.jpg"
        lastPhoto.lastPhoto = photoFileName;

        lastPhoto.viz = true;

        console.log(lastPhoto.lastPhoto)

        console.log(lastPhoto.viz)

        cameraView.camera.imageCapture.captureToLocation(cameraFileFolder.filePath(photoFileName));

        statusText.text = photoFileName;
    }
    // App Page
    Page{
        id: locationReport
        anchors.rightMargin: -8
        anchors.bottomMargin: 0
        anchors.leftMargin: 8
        anchors.topMargin: 0
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
                    text: qsTr("Make A Report")
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: app.titleFontSize
                    color: app.headerTextColor
                }
            }
        }

        CameraView {
            id: cameraView

            anchors.fill: parent

            onResolutionChanged: {
                if (loading) {
                    return;
                }

                app.settings.setValue("resolution_width", resolution[0]);
                app.settings.setValue("resolution_height", resolution[1]);
            }
        }

        Rectangle {
            anchors.fill: parent

            color: "black"

            opacity: (settingsDrawer.position) * 0.3
            visible: opacity > 0.0
        }

        Button {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10

            text: qsTr("Settings")
            opacity: 1.0 - settingsDrawer.position
            visible: opacity > 0.0

            onClicked: settingsDrawer.open()
        }

        Rectangle {
            anchors.fill: statusText
            anchors.margins: -2

            color: "blue"
            visible: statusText.text !== ""
            opacity: 0.5
        }

        Text {
            id: statusText

            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10

            color: "yellow"

        }

        SettingsDrawer {
            id: settingsDrawer

            width: 200 * AppFramework.displayScaleFactor
            height: parent.height

            camera: cameraView.camera
        }

        CameraSwitchButton {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 10

            camera: cameraView.camera
            opacity: 1.0 - settingsDrawer.position
            visible: opacity > 0.0

            onCameraSwitched: app.settings.setValue("deviceId", cameraView.camera.deviceId);
        }

        CaptureButton {
            anchors.right: parent.right
            y: (parent.height - height) / 2
            anchors.margins: 10

            opacity: (1.0 - settingsDrawer.position) * 0.8
            visible: opacity > 0.0

            onClicked: capturePhoto()
        }

        FileFolder {
            id: cameraFileFolder

            path: "./Images"
        }

        Component.onCompleted: {
            loading = true;

            console.log("settings.path: ", app.settings.path);

            var deviceId = app.settings.value("deviceId");
            if (deviceId && deviceId !== cameraView.camera.deviceId) {
                cameraView.camera.stop();
                cameraView.camera.deviceId = deviceId;
                cameraView.camera.start();
            }

            var resolution_width = app.settings.value("resolution_width");
            var resolution_height = app.settings.value("resolution_height");
            if (resolution_width > 0 && resolution_height > 0) {
                cameraView.camera.stop();
                cameraView.camera.viewfinder.resolution = Qt.size(resolution_width, resolution_height);
                cameraView.camera.start();
            }

            var flashMode = app.settings.value("flashMode");
            if (flashMode != null) {
                cameraView.camera.flash.mode = flashMode;
            }

            loading = false;
        }
    }
}
