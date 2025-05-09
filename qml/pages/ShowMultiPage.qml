import QtQuick 2.6
import Sailfish.Silica 1.0
import "../modules/Opal/Tabs"
import "../scripts/GpxFunctions.js" as GPX

Page {
    id: root

    property string gpxFile : generic.gpxFile
    property var    cache

    allowedOrientations: Orientation.Portrait

    Component.onCompleted: {
        cache = GPX.gpxDecode(gpxFile)
        generic.cache = cache
    }

    TabView {
        id: tabs
        anchors.fill: parent
        currentIndex: 0
        tabBarPosition: Qt.AlignTop

        Tab {
            id: wptsTab
            title: qsTr("Waypoints")


            Component {
                MultiWptsTab { }
            }
        }

        Tab {
            id: descTab
            title: qsTr("Description")

            Component {
                MultiDescTab { }
            }
        }

        Tab {
            id: logsTab
            title: qsTr("Facts & Logs")

            Component {
                MultiLogsTab { }
            }
        }
    }
}
