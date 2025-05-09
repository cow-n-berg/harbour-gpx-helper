import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import "../modules/Opal/Delegates"
import "../modules/Opal/Tabs"

TabItem {
    id: descTab

    property var    cache   : generic.cache
    property int    listLen : 0
    property int    lenChar
    property int    lenLine
    property string copyMessage: ""

    ListModel {
        id: descModel

        function update(list) {
            descModel.clear();
            listLen = list.length;
            lenChar = 0;
            for (var i = 0; i < listLen; i++  ) {
                descModel.append(list[i]);
                lenChar += list[i].line.length;
            }
            lenLine = lenChar / 30;
        }
    }

    Component.onCompleted: {
        console.log(JSON.stringify(cache))
        console.log(JSON.stringify(cache.description))
        descModel.update(cache.description)
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
        contentHeight: Math.max(listLen * Theme.itemSizeHuge, lenLine * Theme.itemSizeExtraSmall)
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
                text: qsTr("No description yet")
            }

            DelegateColumn {
                id: colDelDesc
                model: descModel

                delegate: OneLineDelegate {
                    id: descr
                    text: line
                    textLabel.wrapped: wrapped

                    rightItem: DelegateIconButton {
                        iconSource: "image://theme/icon-m-clipboard"
                        iconSize: Theme.iconSizeSmallPlus
                        onClicked: {
                            Clipboard.text = line
                            copyMessage = qsTr("Text copied")
                            notification.publish()
                        }
                    }

                    onClicked: {
//                        toggleWrappedText(textLabel)
                        wrapped = !wrapped
                    }
                }
            }
        }
    }
}
