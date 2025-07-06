import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import Nemo.Notifications 1.0
import "../scripts/GpxFunctions.js" as GPX

Page {
    id: main

    anchors {
        fill: parent
    }

    allowedOrientations: Orientation.Portrait

    property string selectedFile : qsTr("No file selected yet")
    property string filePath     : "no path"
    property string gpxFile      : generic.gpxFile
    property string wpt          : "empty"
    property string copyMessage  : ""
    property var    cache

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
        anchors {
            fill: parent
            leftMargin: Theme.paddingSmall
            rightMargin: Theme.paddingSmall
        }
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick

        VerticalScrollDecorator {
            flickable: flick
        }

        quickScroll : true

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader {
                id: pageHeader
                title: qsTr("Open gpx file")
            }

            ButtonLayout {
                Button {
                    height: Theme.itemSizeLarge
                    preferredWidth: Theme.buttonWidthLarge
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("GPX File Picker")
                    onClicked: pageStack.push(filePickerPage)
                }

                Button {
                    height: Theme.itemSizeLarge
                    preferredWidth: Theme.buttonWidthLarge
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Show GPX Multi page")
                    onClicked: pageStack.push(Qt.resolvedUrl("ShowMultiPage.qml"))
                }

                Component {
                    id: filePickerPage
                    FilePickerPage {
                        nameFilters: [ '*.gpx' ]
                        onSelectedContentPropertiesChanged: {
                            selectedFile = selectedContentProperties.fileName
                            filePath = selectedContentProperties.filePath
                            gpxFile = readFromFile(filePath)
                            generic.gpxFile = gpxFile
                            console.log(gpxFile)
                            copyMessage = "File selected"
                            notification.publish()
                            cache = GPX.gpxDecode(gpxFile)
                            generic.cache = cache
                        }
                    }
                }

            }

            SectionHeader {
                text: qsTr("Geocache")
            }

            TextField {
                text: cache ? cache.facts.name : ""
                label: qsTr("Geocache name")
                readOnly: true
            }

            TextField {
                text: cache ? cache.facts.code : ""
                label: qsTr("Geocache code")
                readOnly: true
            }

            TextField {
                text: cache ? cache.facts.owner : ""
                label: qsTr("Owner")
                readOnly: true
            }

            TextField {
                text: cache ? cache.facts.type + ", " + cache.facts.container + ", " + qsTr("D/T") + " " + cache.facts.difficult + "/" + cache.facts.terrain : ""
                label: qsTr("Cache type")
                readOnly: true
            }

            SectionHeader {
                text: qsTr("GPX File")
            }

            TextField {
                text: selectedFile
                readOnly: true
            }

            TextArea {
                text: gpxFile
                readOnly: true
            }

        }
    }

// Copied from https://codeberg.org/aerique/pusfofefe

// The BSD License
// 
// Copyright (c) 2020, 2021, Erik Winkels
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
// 
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
// 
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
// 
//     * The name of its contributor may not be used to endorse or
//       promote products derived from this software without specific
//       prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

    function readFromFile (file) {
        // 
        var req = new XMLHttpRequest();
        req.open('GET', 'file://' + file, false);
        req.send();
        return req.responseText;
    }

    function writeToFile(file, str) {
        var req = new XMLHttpRequest();
        req.open('PUT', 'file://' + file, false);
        req.send(str);
        return req.status;
    }
}
