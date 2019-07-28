import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtMultimedia 5.5

ComboBox {
    id: resolutionComboBox

    property bool loading: true
    property Camera camera

    model: resModel
    textRole: "displayText"

    ListModel {
        id: resModel
    }

    function compareRes(a, b) {
        return (a.height !== b.height) ? a.height - b.height : a.width - b.width;
    }

    function refresh() {
        loading = true;

        var list = camera.supportedViewfinderResolutions().map( function(e) {
            return {
                width: e.width,
                height: e.height,
                displayText: qsTr("%1x%2").arg(e.width).arg(e.height)
            }
        } );

        list = list.sort(compareRes);

        resModel.clear();
        list.forEach(function (p, i, a) {
            resModel.append( p );
            if (p.width === camera.viewfinder.resolution.width
                    && p.height === camera.viewfinder.resolution.height) {
                currentIndex = i;
            }
        } );

        loading = false;
    }

    onCurrentTextChanged: {
        if (loading) {
            return;
        }

        var res = resModel.get(currentIndex);

        if (res.width === camera.viewfinder.resolution.width
                && res.height === camera.viewfinder.resolution.height)
        {
            return;
        }

        camera.stop();
        camera.viewfinder.resolution = Qt.size(res.width, res.height);
        camera.start();
    }

    Component.onCompleted: {
        refresh();
    }

}
