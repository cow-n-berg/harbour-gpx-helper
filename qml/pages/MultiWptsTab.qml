import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../modules/Opal/Delegates"
import "../modules/Opal/Tabs"

TabItem {
    id: wptsTab

    property var    cache   : generic.cache
    property int    listLen : 0
    property int    lenChar
    property int    lenLine
    property string copyMessage: ""

    ListModel {
        id: wptsModel

        function update(list) {
            wptsModel.clear();
            listLen = list.length;
            lenChar = 0;
            for (var i = 0; i < listLen; i++  ) {
                wptsModel.append(list[i]);
                lenChar += Math.max(list[i].instruction.length - 30, 0);
            }
            lenLine = lenChar / 30;
        }
    }

    Component.onCompleted: {
        console.log(JSON.stringify(cache))
        console.log(JSON.stringify(cache.waypoints))
        wptsModel.update(cache.waypoints)
    }

    Notification {
        id: notification

        summary: copyMessage
        body: "GPX Helper"
        expireTimeout: 500
        urgency: Notification.Low
        isTransient: true
    }

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: listLen * Theme.itemSizeHuge + lenLine * Theme.itemSizeExtraSmall
        flickableDirection: Flickable.VerticalFlick
        quickScroll: true

        VerticalScrollDecorator {
            flickable: flick
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            ViewPlaceholder {
                id: placehInv
                enabled: listLen === 0
                text: qsTr("No waypoints yet")
            }

            DelegateColumn {
                id: colDelWayp
                model: wptsModel

                delegate: ThreeLineDelegate {
                    id: wpt
                    title: number + " | " + descript + (txtLetter ? " | " + qsTr("Find") + ": " : "") + txtLetter
                    text: coordinate
                    description: instruction
                    descriptionLabel.wrapped: wrapped

                    rightItem: DelegateIconButton {
                        iconSource: "image://theme/icon-m-clipboard"
                        iconSize: Theme.iconSizeSmallPlus
                        onClicked: {
                            Clipboard.text = coordinate + " | " + descript + (txtLetter ? " | " + qsTr("Find") + ": " : "") + txtLetter
                            copyMessage = qsTr("Text copied")
                            notification.publish()
                        }
                    }

                    onClicked: {
                        //toggleWrappedText(descriptionLabel)
                        wrapped = !wrapped
                    }
                }
            }
        }
    }
}
