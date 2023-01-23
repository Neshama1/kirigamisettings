// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.KirigamiSettings 1.0
import QtQml 2.15
import QtGraphicalEffects 1.15
import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm

Kirigami.ScrollablePage {
    id: wallpapersPage

    title: "Wallpapers"

    // Get wallpapers

    Component.onCompleted: {
        getWallpapers()
        opacityButtonAnimation.start()
    }

    function getWallpapers() {
        WallpapersBackend.getThemes()
        var fcount = WallpapersBackend.filesCount
        for (var i = 0 ; i < fcount ; i++) {
            wallpapersModel.append({"name": WallpapersBackend.wallpapers[i].name,"paperUrl": WallpapersBackend.wallpapers[i].paperUrl,"selected": WallpapersBackend.wallpapers[i].selected,"paperSizes": WallpapersBackend.wallpapers[i].paperSizes,"paperSizesAvailable": WallpapersBackend.wallpapers[i].paperSizesAvailable})
        }
    }

    ListModel {
        id: wallpapersModel
    }

    // Floating button to add scheme and animation

    footer: FloatingActionButton {
        id: floatingButton
        iconName: "list-add"
        onClicked: {
            // infoSheet.open()
        }
    }

    PropertyAnimation {
        id: opacityButtonAnimation
        target: floatingButton
        properties: "opacity"
        from: 0.0
        to: 1
        duration: 800
    }

    // Overlay sheet "Add wallpaper"

    Kirigami.OverlaySheet {
        id: infoSheet

        background: Kirigami.ShadowedRectangle {
            width: 500
            height: 500
            Kirigami.Theme.colorSet: Kirigami.Theme.Window
            Kirigami.Theme.inherit: false
            color: Kirigami.Theme.backgroundColor
            radius: 3
            shadow.size: 8
        }

        header: Kirigami.Heading {
            text: i18nc("@title:window", "Add wallpaper")
        }

        Kirigami.FormLayout {
            Controls.Label {
                text: i18n("Overlay sheet")
            }
        }
    }

    // Cards

    MobileForm.FormCard {
        id: formCardGroup
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.largeSpacing
        Layout.topMargin: Kirigami.Units.largeSpacing

        contentItem: ColumnLayout {

            // spacing: 0

            MobileForm.FormCardHeader {
                title: i18n("Wallpapers")
            }

            MobileForm.FormTextDelegate {
                text: i18n("Personalize your background")
            }

            MobileForm.FormCardHeader {

                visible: true

                Layout.maximumWidth: parent.width
                Layout.leftMargin: Kirigami.Units.largeSpacing
                Layout.rightMargin: Kirigami.Units.largeSpacing
                Layout.bottomMargin: Kirigami.Units.largeSpacing * 2

                GridLayout {
                    id: grid
                    anchors.fill: parent

                    columns: width / 100
                    rowSpacing: 7
                    columnSpacing: 7

                    anchors.topMargin: Kirigami.Units.largeSpacing

                    Repeater {
                        id: cardRepeater

                        model: wallpapersModel

                        delegate: Kirigami.Card {
                            id: card

                            property bool cardHovered: false
                            property bool paperSel: selected

                            Layout.fillHeight: true

                            Component.onCompleted: {
                                //xAnimation.start()
                                opacityAnimation.start()
                                formCardGroup.height = 200 * (Math.floor(WallpapersBackend.filesCount / 5) + 1)
                                wallpapersPage.verticalScrollBarPolicy = Controls.ScrollBar.AlwaysOn
                                wallpapersPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing
                                wallpapersPage.flickable.width = wallpapersPage.width
                            }

                            // Card animations

                            PropertyAnimation {
                                id: xAnimation
                                target: card
                                properties: "x"
                                from: -5
                                to: 0
                                duration: 400
                            }
                            PropertyAnimation {
                                id: opacityAnimation
                                target: card
                                properties: "opacity"
                                from: 0.0
                                to: 1
                                duration: 400
                            }
                            PropertyAnimation {
                                id: bannerOpacityAnimation
                                target: banner
                                properties: "opacity"
                                from: 0.0
                                to: 1.0
                                duration: 2500
                                easing.type: Easing.InExpo
                            }
                            PropertyAnimation {
                                id: hoverTextAnimation
                                target: hoverRect
                                properties: "opacity"
                                from: 0
                                to: 1
                                duration: 1000
                            }

                            // 1: Card view when the control is not being hovered

                            Rectangle {
                                anchors.fill: card
                                color: "transparent"
                                visible: cardHovered ? false : true

                                // Wallpaper image

                                Image {
                                    id: banner
                                    //anchors.fill: parent
                                    width: card.width
                                    height: card.height / 2
                                    source: Qt.resolvedUrl("file://" + paperUrl)
                                    asynchronous: true

                                    Connections {
                                        target: banner
                                        onStatusChanged: {
                                            if (banner.status == Image.Ready) {
                                                bannerOpacityAnimation.start()
                                            }
                                        }
                                    }

                                    layer.enabled: true
                                    layer.effect: OpacityMask {
                                        maskSource: Item {
                                            width: banner.width
                                            height: banner.height
                                            Rectangle {
                                                anchors.centerIn: parent
                                                width: banner.width
                                                height: banner.height
                                                radius: 3
                                            }
                                        }
                                    }
                                }

                                // Wallpaper name

                                Controls.Label {
                                    id: nameLabel
                                    anchors.top: banner.top
                                    width: banner.width
                                    padding: Kirigami.Units.largeSpacing
                                    color: "white"
                                    font.pointSize: 16
                                    elide: Text.ElideRight
                                    wrapMode: Text.WordWrap
                                    maximumLineCount: 1
                                    text: name
                                }

                                // Avatar icon (circle)

                                Rectangle {
                                    id: avatarIcon
                                    anchors.centerIn: parent
                                    color: "steelblue"
                                    width: 50
                                    height: width
                                    radius: width
                                    Controls.Label {
                                        anchors.centerIn: parent
                                        color: "white"
                                        font.pixelSize: 30
                                        font.capitalization: Font.Capitalize
                                        text: nameLabel.text.substring(0,1)
                                    }
                                }
                            }

                            // Selection icon rectangle (icon background)

                            Rectangle {
                                id: selectIconRect
                                implicitWidth: Kirigami.Units.iconSizes.small
                                implicitHeight: Kirigami.Units.iconSizes.small
                                anchors.bottom: hoverRect.bottom
                                anchors.right: hoverRect.right
                                anchors.margins: 4
                                scale: 1.2
                                radius: width
                                Kirigami.Theme.colorSet: Kirigami.Theme.View
                                Kirigami.Theme.inherit: false
                                color: Kirigami.Theme.disabledTextColor
                                opacity: 0.1
                                visible: cardHovered ? false : (paperSel ? true : false)
                            }

                            // Selection icon

                            Kirigami.Icon {
                                anchors.centerIn: selectIconRect
                                implicitWidth: Kirigami.Units.iconSizes.small
                                implicitHeight: Kirigami.Units.iconSizes.small
                                Kirigami.Theme.colorSet: Kirigami.Theme.View
                                Kirigami.Theme.inherit: false
                                color: Kirigami.Theme.textColor
                                opacity: 0.7
                                visible: cardHovered ? false : (paperSel ? true : false)
                                source: "emblem-ok-symbolic"
                            }

                            // 2: Card view when the control is being hovered

                            Rectangle {
                                id: hoverRect
                                opacity: 0
                                anchors.fill: parent
                                anchors.margins: 2
                                visible: cardHovered ? true : false
                                Kirigami.Theme.colorSet: Kirigami.Theme.View
                                Kirigami.Theme.inherit: false
                                color: Kirigami.Theme.backgroundColor

                                // Full wallpaper name

                                Controls.Label {
                                    id: hoverText
                                    anchors.fill: parent
                                    anchors.margins: 25
                                    text: name
                                    fontSizeMode: Text.WrapAnywhere
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    wrapMode: Text.Wrap
                                    minimumPixelSize: 10
                                    font.pixelSize: 38
                                }

                                // Remove icon rectangle (circle)

                                Rectangle {
                                    id: removeIconRect
                                    implicitWidth: Kirigami.Units.iconSizes.small
                                    implicitHeight: Kirigami.Units.iconSizes.small
                                    anchors.bottom: hoverRect.bottom
                                    anchors.right: hoverRect.right
                                    anchors.margins: 4
                                    scale: 1.2
                                    radius: width
                                    Kirigami.Theme.colorSet: Kirigami.Theme.View
                                    Kirigami.Theme.inherit: false
                                    color: Kirigami.Theme.disabledTextColor
                                    opacity: 0.1
                                    visible: paperUrl.includes("/usr/share/wallpapers") ? false : true
                                }

                                // Remove Icon

                                Kirigami.Icon {
                                    id: removeIcon
                                    anchors.centerIn: removeIconRect
                                    x: card.width - 5
                                    y: hoverRect.height - implicitHeight - 5
                                    implicitWidth: Kirigami.Units.iconSizes.small
                                    implicitHeight: Kirigami.Units.iconSizes.small
                                    Kirigami.Theme.colorSet: Kirigami.Theme.View
                                    Kirigami.Theme.inherit: false
                                    color: Kirigami.Theme.textColor
                                    opacity: 0.7
                                    visible: paperUrl.includes("/usr/share/wallpapers") ? false : true
                                    source: "bqm-remove"

                                    // Action when remove was cliked

                                    MouseArea {
                                        anchors.fill: removeIcon
                                        hoverEnabled: true
                                        onClicked: {
                                            // infoSheet.open()
                                        }
                                    }
                                }
                            }

                            // Mouse handling for card

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
                                onEntered: {
                                    hoverTextAnimation.start()
                                    cardHovered = true
                                }
                                onExited: {
                                    cardHovered = false
                                }
                                MouseArea {
                                    id: mouse
                                    anchors.fill: parent
                                    anchors.margins: hoverText.anchors.margins
                                    onClicked: {
                                        cardHovered = false
                                        var fcount = WallpapersBackend.filesCount
                                        for (var i = 0 ; i < fcount ; i++) {
                                            wallpapersModel.setProperty(i, "selected", false)
                                        }
                                        wallpapersModel.setProperty(index, "selected", true)
                                        WallpapersBackend.setSelectedWallpaper(index)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
