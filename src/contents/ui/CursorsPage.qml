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
    id: cursorsThemesPage

    title: "Cursors Theme"
    verticalScrollBarPolicy: Controls.ScrollBar.AlwaysOn

    // Page background color

    Component.onCompleted: {
        getCursorsThemes()
        opacityAnimation.start()
        yAnimation.start()
        opacityButtonAnimation.start()
    }

    function getCursorsThemes() {
        CursorsBackend.getThemes()
        var fcount = CursorsBackend.themesCount
        for (var i = 0 ; i < fcount ; i++) {
            cursorsModel.append({"name": CursorsBackend.cursorsThemes[i].name,"path": CursorsBackend.cursorsThemes[i].path,"selected": CursorsBackend.cursorsThemes[i].selected})
        }
    }

    ListModel {
        id: cursorsModel
    }

    // Floating button to add sche"plasmaColor": CursorsBackend.cursorsThemes[i].plasmaColorme and animation

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
        target: cursorsThemesPage
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 600
    }

    PropertyAnimation {
        id: yAnimation
        target: cursorsThemesPage
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
            text: i18nc("@title:window", "Add cursor theme")
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
                title: i18n("Cursors themes")
            }

            MobileForm.FormTextDelegate {
                text: i18n("Personalize your style")
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

                        model: cursorsModel

                        delegate: Kirigami.Card {
                            id: card

                            Layout.minimumHeight: 100
                            Layout.maximumHeight: 400

                            property bool themeSel: selected

                            Component.onCompleted: {
                                opacityAnimation.start()

                                // Mutar para columnas adaptables
                                grid.columns = 1

                                formCardHeader.height = Layout.minimumHeight * (Math.ceil(CursorsBackend.themesCount / (grid.width / 100)))
                                cursorsThemesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing + 65
                                cursorsThemesPage.flickable.width = cursorsThemesPage.width
                            }

                            Connections {
                                target: formCardHeader
                                onWidthChanged: {
                                    formCardHeader.height = Layout.minimumHeight * (Math.ceil(CursorsBackend.themesCount / grid.columns))
                                    cursorsThemesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing + 65
                                    cursorsThemesPage.flickable.width = cursorsThemesPage.width
                                }
                                onHeightChanged: {
                                    formCardHeader.height = Layout.minimumHeight * (Math.ceil(CursorsBackend.themesCount / grid.columns))
                                    cursorsThemesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing + 65
                                    cursorsThemesPage.flickable.width = cursorsThemesPage.width
                                }
                            }

                            // Card animations

                            PropertyAnimation {
                                id: opacityAnimation
                                target: card
                                properties: "opacity"
                                from: 0.0
                                to: 1
                                duration: 800
                            }

                            // Banner (Icons)

                            Rectangle {
                                id: banner
                                //anchors.horizontalCenter: card.horizontalCenter
                                width: card.height - 2
                                height: card.height - 2
                                x: 1
                                y: 1
                                color: Kirigami.Theme.backgroundColor
                                opacity: 0

                                Component.onCompleted: {
                                    bannerOpacityAnimation.start()
                                }

                                PropertyAnimation {
                                    id: bannerOpacityAnimation
                                    target: banner
                                    properties: "opacity"
                                    from: 0.0
                                    to: 0.8
                                    duration: 2500
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
                                opacity: 0.8
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
                                from: 0.8
                                to: 1.0
                                duration: 1000
                                easing.type: Easing.OutExpo
                            }

                            PropertyAnimation {
                                id: chipOpacityDownAnimation
                                target: bannerChip
                                properties: "opacity"
                                from: 1.0
                                to: 0.8
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
                                visible: themeSel ? true : false
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
                                visible: themeSel ? true : false
                                source: "emblem-ok-symbolic"
                            }

                            // Mouse handling

                            MouseArea {
                                id: mouse
                                anchors.fill: parent
                                //anchors.bottomMargin: 40
                                hoverEnabled: true

                                onClicked: {
                                    var fcount = CursorsBackend.themesCount
                                    for (var i = 0 ; i < fcount ; i++) {
                                        cursorsModel.setProperty(i, "selected", false)
                                    }
                                    cursorsModel.setProperty(index, "selected", true)
                                    CursorsBackend.setSelectedTheme(index)
                                }

                                onEntered: {
                                    chipOpacityUpAnimation.start()
                                }
                                onExited: {
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
