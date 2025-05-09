import QtQuick 2.6
import Sailfish.Silica 1.0
import "../modules/Opal/Delegates"
import "../modules/Opal/Tabs"

TabItem {
    id: logsTab

    property var    cache   : generic.cache
    property var    facts   : cache.facts
    property int    listLen : 0

    ListModel {
        id: logsModel

        function update(list) {
            logsModel.clear();
            listLen = list.length;
            for (var i = 0; i < listLen; i++  ) {
                logsModel.append(list[i]);
            }
        }
    }

    Component.onCompleted: {
//        console.log(JSON.stringify(cache))
//        console.log(JSON.stringify(cache.logs))
        logsModel.update(cache.logs)
    }

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: (6 + listLen) * Theme.itemSizeHuge
        flickableDirection: Flickable.VerticalFlick
        quickScroll: true

        VerticalScrollDecorator {
            flickable: flick
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            TextField {
                text: facts.owner
                label: qsTr("Owner")
                readOnly: true
            }

            TextField {
                text: facts.type + ", " + facts.container + ", " + qsTr("D/T") + " " + facts.difficult + "/" + facts.terrain
                label: qsTr("Cache type")
                readOnly: true
            }

            PasswordField {
                id: hint
                text: facts.hints
                label: qsTr("Hint")
                placeholderText: qsTr("No hint available")
                readOnly: true
                onClicked: showEchoModeToggle = !showEchoModeToggle
                wrapMode: TextInput.WordWrap
            }

            SectionHeader {
                text: qsTr("Attributes")
            }

            TextArea {
                text: cache.attributes
                readOnly: true
            }

            ViewPlaceholder {
                id: placehInv
                enabled: listLen === 0
                text: qsTr("No logs yet")
            }

            SectionHeader {
                text: qsTr("Logs")
            }

            DelegateColumn {
                id: colDelLogs
                model: logsModel

                delegate: ThreeLineDelegate {
                    id: result
                    title: cacher + ", " + date
                    text: found
                    description: logText
                    descriptionLabel.wrapped: wrapped

                    onClicked: {
                        //toggleWrappedText(descriptionLabel)
                        wrapped = !wrapped
                    }

                }
            }
        }
    }
}
