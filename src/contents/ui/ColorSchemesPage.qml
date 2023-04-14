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
    id: colorSchemesPage

    title: "Color Schemes"
    verticalScrollBarPolicy: Controls.ScrollBar.AlwaysOn

    // Page background color

    Component.onCompleted: {
        getColorSchemes()
        opacityAnimation.start()
        yAnimation.start()
        opacityButtonAnimation.start()
    }

    function getColorSchemes() {
        ColorSchemesBackend.getThemes()
        var fcount = ColorSchemesBackend.filesCount
        for (var i = 0 ; i < fcount ; i++) {
            colorSchemesModel.append({"name": ColorSchemesBackend.colorSchemes[i].name,"titleBarColor": ColorSchemesBackend.colorSchemes[i].titleBarColor,"windowColor": ColorSchemesBackend.colorSchemes[i].windowColor,"selectionColor": ColorSchemesBackend.colorSchemes[i].selectionColor,"fileName": ColorSchemesBackend.colorSchemes[i].fileName,"path": ColorSchemesBackend.colorSchemes[i].path,"selected": ColorSchemesBackend.colorSchemes[i].selected})
        }
    }

    ListModel {
        id: colorSchemesModel
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
        target: colorSchemesPage
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 600
    }

    PropertyAnimation {
        id: yAnimation
        target: colorSchemesPage
        properties: "y"
        from: -10
        to: 0
        duration: 400
    }

    // Overlay sheet "Add scheme"

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
            text: i18nc("@title:window", "Add scheme")
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
                title: i18n("Color Schemes")
            }

            MobileForm.FormTextDelegate {
                text: i18n("Personalize your scheme")
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
                    rowSpacing: 9
                    columnSpacing: 9

                    anchors.topMargin: Kirigami.Units.largeSpacing

                    Repeater {
                        id: cardRepeater

                        model: colorSchemesModel

                        delegate: Kirigami.Card {
                            id: card

                            Layout.minimumHeight: 100
                            Layout.maximumHeight: 400

                            property bool cardHovered: false
                            property bool schemeSel: selected

                            Component.onCompleted: {
                                opacityAnimation.start()

                                // Mutar para columnas adaptables
                                grid.columns = 1

                                formCardGroup.height = Layout.minimumHeight * (Math.ceil(ColorSchemesBackend.colorSchemes / (grid.width / 100)))
                                colorSchemesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing
                                colorSchemesPage.flickable.width = colorSchemesPage.width
                            }

                            Connections {
                                target: formCardHeader
                                onWidthChanged: {
                                    formCardHeader.height = Layout.minimumHeight * (Math.ceil(PlasmaStyleBackend.stylesCount / grid.columns))
                                    colorSchemesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing + 65
                                    colorSchemesPage.flickable.width = colorSchemesPage.width
                                }
                                onHeightChanged: {
                                    formCardHeader.height = Layout.minimumHeight * (Math.ceil(PlasmaStyleBackend.stylesCount / grid.columns))
                                    colorSchemesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing + 65
                                    colorSchemesPage.flickable.width = colorSchemesPage.width
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

                            // Color Banner (Window Color)

                            Rectangle {
                                id: banner
                                //anchors.horizontalCenter: card.horizontalCenter
                                width: card.height - 2
                                height: card.height - 2
                                x: 1
                                y: 1
                                color: windowColor
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
                                opacity: 1.0
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
                                visible: schemeSel ? true : false
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
                                visible: schemeSel ? true : false
                                source: "emblem-ok-symbolic"
                            }

                            // Mouse handling

                            MouseArea {
                                id: mouse
                                anchors.fill: parent
                                //anchors.bottomMargin: 40
                                hoverEnabled: true

                                onClicked: {
                                    var fcount = ColorSchemesBackend.filesCount
                                    for (var i = 0 ; i < fcount ; i++) {
                                        colorSchemesModel.setProperty(i, "selected", false)
                                    }
                                    colorSchemesModel.setProperty(index, "selected", true)
                                    ColorSchemesBackend.setSelectedScheme(index)
                                }

                                onEntered: {
                                    //chipOpacityUpAnimation.start()
                                }
                                onExited: {
                                    //chipOpacityDownAnimation.start()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
