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
    id: plasmaStylesPage

    title: "Plasma Style"

    // Page background color

    Component.onCompleted: {
        getPlasmaStyles()
        opacityButtonAnimation.start()
    }

    function getPlasmaStyles() {
        PlasmaStyleBackend.getThemes()
        var fcount = PlasmaStyleBackend.stylesCount
        for (var i = 0 ; i < fcount ; i++) {
            plasmaStyleModel.append({"name": PlasmaStyleBackend.plasmaStyles[i].name,"folder": PlasmaStyleBackend.plasmaStyles[i].folder,"path": PlasmaStyleBackend.plasmaStyles[i].path,"selected": PlasmaStyleBackend.plasmaStyles[i].selected})
        }
    }

    ListModel {
        id: plasmaStyleModel
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
            text: i18nc("@title:window", "Add plasma style")
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
                title: i18n("Plasma styles")
            }

            MobileForm.FormTextDelegate {
                text: i18n("Personalize your style")
            }

            MobileForm.FormCardHeader {

                visible: true

                Layout.maximumWidth: parent.width + 100
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

                        model: plasmaStyleModel

                        delegate: Kirigami.Card {
                            id: card

                            Layout.minimumHeight: 150

                            property bool cardHovered: false
                            property bool styleSel: selected

                            Component.onCompleted: {
                                //xAnimation.start()
                                opacityAnimation.start()
                                formCardGroup.height = 150 * (Math.floor(PlasmaStyleBackend.stylesCount / 5) + 1)
                                plasmaStylesPage.verticalScrollBarPolicy = Controls.ScrollBar.AlwaysOn
                                plasmaStylesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing
                                plasmaStylesPage.flickable.width = plasmaStylesPage.width
                            }

                            // Card animations
/*
                            PropertyAnimation {
                                id: xAnimation
                                target: card
                                properties: "x"
                                from: -5
                                to: 0
                                duration: 400
                            }
*/
                            PropertyAnimation {
                                id: opacityAnimation
                                target: card
                                properties: "opacity"
                                from: 0.0
                                to: 1
                                duration: 800
                            }
                            PropertyAnimation {
                                id: hoverTextAnimation
                                target: hoverRect
                                properties: "opacity"
                                from: 0.0
                                to: 1
                                duration: 1000
                            }

                            // 1: Card view when the control is not being hovered

                            // Card banner

                            banner {
                                id: cardBanner
                                iconSource: "color-fill"
                                opacity: 0.9
                                title: folder
                                visible: cardHovered ? false : true
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
                                visible: cardHovered ? false : (styleSel ? true : false)
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
                                visible: cardHovered ? false : (styleSel ? true : false)
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

                                // Full plasma theme name

                                Controls.Label {
                                    id: hoverText
                                    anchors.fill: parent
                                    anchors.margins: 25
                                    text: folder
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
                                anchors.fill: card
                                hoverEnabled: true
                                propagateComposedEvents: true

                                // When the mouse enters on card

                                onEntered: {
                                    hoverTextAnimation.start()
                                    cardHovered = true
                                }

                                // When the mouse leaves the card

                                onExited: {
                                    cardHovered = false
                                }

                                // When card was cliked

                                MouseArea {
                                    id: mouse
                                    anchors.fill: parent
                                    anchors.margins: hoverText.anchors.margins

                                    onClicked: {
                                        cardHovered = false
                                        var fcount = PlasmaStyleBackend.stylesCount
                                        for (var i = 0 ; i < fcount ; i++) {
                                            plasmaStyleModel.setProperty(i, "selected", false)
                                        }
                                        plasmaStyleModel.setProperty(index, "selected", true)
                                        PlasmaStyleBackend.setSelectedStyle(index)
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
