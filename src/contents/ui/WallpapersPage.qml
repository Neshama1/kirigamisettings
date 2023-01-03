// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.KirigamiSettings 1.0
import QtQml 2.15
import QtGraphicalEffects 1.15

Kirigami.Page {

    Component.onCompleted: {
        getWallpapers()
        //opacityButtonAnimation.start()
    }

    function getWallpapers() {
        var fcount = WallpapersBackend.filesCount
        for (var i = 0 ; i < fcount ; i++) {
            wallpapersModel.append({"name": WallpapersBackend.wallpapers[i].name,"paperUrl": WallpapersBackend.wallpapers[i].paperUrl,"selected": WallpapersBackend.wallpapers[i].selected,"paperSizes": WallpapersBackend.wallpapers[i].paperSizes,"paperSizesAvailable": WallpapersBackend.wallpapers[i].paperSizesAvailable})
        }
    }

    ListModel {
        id: wallpapersModel
    }
    /*
    ListModel {
        id: appsModel

        ListElement {
            name: "Index"
            description: "Index le permite navegar por su equipo y previsualizar archivos multimedia"
        }
        ListElement {
            name: "Vvave"
            description: "Pequeño reproductor de música en Qt para tener a mano sus canciones favoritas"
        }
    }
    */
    Kirigami.CardsGridView {
        id: cardsGridView

        anchors.fill: parent

        minimumColumnWidth: 50
        maximumColumnWidth: 210
        cellHeight: 186
        model: wallpapersModel

        delegate: Kirigami.Card {

            property bool paperSel: selected

            height: 170 // + nameLabel.contentHeight - 50

            banner.source: Qt.resolvedUrl("file://" + paperUrl)
            banner.opacity: 1.0

            header: Rectangle {
                color: Qt.rgba(0,0,0,0.3)
                implicitWidth: headerLayout.implicitWidth
                implicitHeight: headerLayout.implicitHeight - avatarIcon.height/2
                ColumnLayout {
                    id: headerLayout
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    Controls.Label {
                        id: nameLabel
                        Layout.fillWidth: true
                        padding: Kirigami.Units.largeSpacing

                        color: "white"
                        font.pointSize: 16
                        clip: true
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        maximumLineCount: 1
                        text: name
                    }
                    Rectangle {
                        id: avatarIcon
                        color: "steelblue"
                        radius: width
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: Kirigami.Units.iconSizes.huge
                        Layout.preferredHeight: Kirigami.Units.iconSizes.huge
                        Controls.Label {
                            anchors.centerIn: parent
                            color: "white"
                            font.pixelSize: 30
                            font.capitalization: Font.Capitalize
                            text: nameLabel.text.substring(0,1)
                        }
                    }
                }
            }
            contentItem: Controls.Label {
                //wrapMode: Text.Wrap
                //topPadding: avatarIcon.height/2
                //implicitWidth: headerLayout.implicitWidth
                //implicitHeight: headerLayout.implicitHeight - avatarIcon.height/2
                text: ""
                visible: selected ? true : false
            }
            footer: RowLayout {
                /*Controls.Label {
                    Layout.fillWidth: true
                    //text: qsTr("Custom footer")
                    text: "Wallpaper selected"
                    visible: selected ? true : false
                }
                Controls.Button {
                    text: qsTr("Ok")
                }*/
                Kirigami.Icon {
                    width: 150
                    height: 150
                    source: "emblem-ok-symbolic"
                    Layout.alignment: Qt.AlignRight
                    visible: paperSel ? true : false
                }
            }
            onClicked: {
                var fcount = WallpapersBackend.filesCount
                for (var i = 0 ; i < fcount ; i++) {
                    wallpapersModel.setProperty(i, "selected", false)
                }
                wallpapersModel.setProperty(index, "selected", true)
                WallpapersBackend.setSelectedWallpaper(paperUrl)
            }
        }
    }
}
