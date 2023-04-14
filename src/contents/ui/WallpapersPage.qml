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
    verticalScrollBarPolicy: Controls.ScrollBar.AlwaysOn

    // Page background color

    Component.onCompleted: {
        getWallpapers()
        opacityAnimation.start()
        yAnimation.start()
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

    PropertyAnimation {
        id: opacityAnimation
        target: wallpapersPage
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 600
    }

    PropertyAnimation {
        id: yAnimation
        target: wallpapersPage
        properties: "y"
        from: -10
        to: 0
        duration: 400
    }

    // Overlay sheet "Add plasma style"

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
                id: formCardHeader

                visible: true

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

                            Layout.minimumHeight: 100
                            Layout.maximumHeight: 400

                            property bool cardHovered: false
                            property bool paperSel: selected

                            Component.onCompleted: {
                                // Mutar para columnas adaptables
                                grid.columns = 1

                                formCardHeader.height = Layout.minimumHeight * (Math.ceil(WallpapersBackend.stylesCount / (grid.width / 100)))
                                wallpapersPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing + 65
                                wallpapersPage.flickable.width = wallpapersPage.width
                            }

                            Connections {
                                target: formCardHeader
                                onWidthChanged: {
                                    formCardHeader.height = Layout.minimumHeight * (Math.ceil(WallpapersBackend.stylesCount / grid.columns))
                                    wallpapersPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing + 65
                                    wallpapersPage.flickable.width = wallpapersPage.width
                                }
                                onHeightChanged: {
                                    formCardHeader.height = Layout.minimumHeight * (Math.ceil(WallpapersBackend.stylesCount / grid.columns))
                                    wallpapersPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing + 65
                                    wallpapersPage.flickable.width = wallpapersPage.width
                                }
                            }

                            // Wallpaper

                            Image {
                                id: banner
                                //anchors.fill: parent
                                width: card.height
                                height: card.height
                                source: Qt.resolvedUrl("file://" + paperUrl)
                                asynchronous: true
                                fillMode: Image.PreserveAspectCrop

                                Connections {
                                    target: banner
                                    onStatusChanged: {
                                        if (banner.status == Image.Ready) {
                                            bannerOpacityAnimation.start()
                                            chipOpacityOnStartAnimation.start()
                                        }
                                    }
                                }

                                PropertyAnimation {
                                    id: bannerOpacityAnimation
                                    target: banner
                                    properties: "opacity"
                                    from: 0.0
                                    to: 0.15
                                    duration: 1000
                                    easing.type: Easing.OutExpo
                                }

                                PropertyAnimation {
                                    id: bannerOpacityUpAnimation
                                    target: banner
                                    properties: "opacity"
                                    from: 0.15
                                    to: 1
                                    duration: 1000
                                    easing.type: Easing.OutExpo
                                }

                                PropertyAnimation {
                                    id: bannerOpacityDownAnimation
                                    target: banner
                                    properties: "opacity"
                                    from: 1.0
                                    to: 0.15
                                    duration: 1000
                                    easing.type: Easing.InExpo
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
                                            radius: 4
                                        }
                                    }
                                }
                            }

                            // Informative chip

                            Kirigami.Chip {
                                id: bannerChip
                                anchors.left: banner.right
                                anchors.top: card.top
                                anchors.margins: 7
                                width: 120
                                height: 30
                                opacity: 0.9
                                closable: false

                                text: name
                                icon.name: "tag-symbolic"
                            }

                            PropertyAnimation {
                                id: chipOpacityOnStartAnimation
                                target: bannerChip
                                properties: "opacity"
                                from: 0.0
                                to: bannerChip.opacity
                                duration: 1000
                                easing.type: Easing.OutExpo
                            }

                            PropertyAnimation {
                                id: chipOpacityUpAnimation
                                target: bannerChip
                                properties: "opacity"
                                from: 0.9
                                to: 1.0
                                duration: 1000
                                easing.type: Easing.OutExpo
                            }

                            PropertyAnimation {
                                id: chipOpacityDownAnimation
                                target: bannerChip
                                properties: "opacity"
                                from: 1.0
                                to: 0.9
                                duration: 1000
                                easing.type: Easing.OutExpo
                            }

                            // Selection icon rectangle (icon background)

                            Rectangle {
                                id: selectIconRect
                                implicitWidth: Kirigami.Units.iconSizes.medium
                                implicitHeight: Kirigami.Units.iconSizes.medium
                                anchors.bottom: card.bottom
                                anchors.right: card.right
                                anchors.margins: 8
                                scale: 1.2
                                radius: width
                                Kirigami.Theme.colorSet: Kirigami.Theme.View
                                Kirigami.Theme.inherit: false
                                color: Kirigami.Theme.disabledTextColor
                                opacity: 0.1
                                visible: paperSel ? true : false
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
                                visible: paperSel ? true : false
                                source: "emblem-ok-symbolic"
                            }

                            MouseArea {
                                id: mouse
                                anchors.fill: card
                                //anchors.bottomMargin: 40
                                hoverEnabled: true

                                onClicked: {
                                    var fcount = WallpapersBackend.filesCount
                                    for (var i = 0 ; i < fcount ; i++) {
                                        wallpapersModel.setProperty(i, "selected", false)
                                    }
                                    wallpapersModel.setProperty(index, "selected", true)
                                    WallpapersBackend.setSelectedWallpaper(index)
                                }

                                onEntered: {
                                    bannerOpacityUpAnimation.start()
                                    chipOpacityUpAnimation.start()
                                }
                                onExited: {
                                    bannerOpacityDownAnimation.start()
                                    chipOpacityDownAnimation.start()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
