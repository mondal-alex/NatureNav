import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.4

Rectangle {
    color: "#2F4f4F"
    Layout.fillHeight: true
    Layout.fillWidth: true
    clip: true

    Image {
        fillMode: Image.Tile

        source: "onlinelogomaker-072619-2103-0968-500.jpg"         // loads dog.jpg
    }
}
