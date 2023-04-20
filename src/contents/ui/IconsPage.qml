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
    id: iconsThemesPage

    title: "Icons Theme"
    verticalScrollBarPolicy: Controls.ScrollBar.AlwaysOn

    // Page background color

    Component.onCompleted: {
        getIconsThemes()
        opacityAnimation.start()
        yAnimation.start()
        opacityButtonAnimation.start()
    }

    function getIconsThemes() {
        IconsBackend.getThemes()
        var fcount = IconsBackend.themesCount
        for (var i = 0 ; i < fcount ; i++) {
            iconsModel.append({"name": IconsBackend.iconsThemes[i].name,"path": IconsBackend.iconsThemes[i].path,"selected": IconsBackend.iconsThemes[i].selected})
        }
    }

    ListModel {
        id: iconsModel
    }

    // Floating button to add sche"plasmaColor": IconsBackend.iconsThemes[i].plasmaColorme and animation

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
        target: iconsThemesPage
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 600
    }

    PropertyAnimation {
        id: yAnimation
        target: iconsThemesPage
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
            text: i18nc("@title:window", "Add icon theme")
        }

        Kirigami.FormLayout {
            Controls.Label {
                text: i18n("Overlay sheet")
            }
        }
    }

    ColumnLayout {

        // Icons (selected)

        MobileForm.FormCard {
            id: formSelected

            Layout.fillWidth: true
            Layout.bottomMargin: Kirigami.Units.largeSpacing

            contentItem: ColumnLayout {

                // spacing: 0

                MobileForm.FormCardHeader {
                    title: i18n("Selected")
                }

                MobileForm.FormTextDelegate {

                    id: formTextSelected

                    Layout.minimumHeight: 110
                    Layout.maximumHeight: 110

                    // Banner

                    Rectangle {
                        id: selectedBanner
                        anchors.left: selectedName.left
                        anchors.right: selectedName.right
                        anchors.top: formTextSelected.top
                        anchors.bottom: selectedName.bottom
                        anchors.topMargin: selectedName.anchors.margins - 4
                        anchors.bottomMargin: selectedName.anchors.margins
                        radius: 4
                        property color dColor: Kirigami.Theme.disabledTextColor
                        border.color: Qt.rgba(dColor.r,dColor.g,dColor.b,0.8)
                        border.width: 1

                        Component.onCompleted: {
                            bannerSelectedOpacityAnimation.start()
                        }

                        PropertyAnimation {
                            id: bannerSelectedOpacityAnimation
                            target: selectedBanner
                            properties: "opacity"
                            from: 0.0
                            to: 0.8
                            duration: 750
                            easing.type: Easing.InExpo
                        }
                    }

                    // Theme name

                    Rectangle {
                        id: selectedName

                        anchors.left: formTextSelected.left
                        anchors.bottom: formTextSelected.bottom
                        anchors.margins: Kirigami.Units.smallSpacing * 3
                        width: 90
                        height: 30
                        opacity: 1.0
                        radius: 4
                        property color dColor: Kirigami.Theme.disabledTextColor
                        border.color: Qt.rgba(dColor.r,dColor.g,dColor.b,0.8)
                        border.width: 1
                        color: Kirigami.Theme.backgroundColor

                        Controls.Label {
                            id: selectedLabel
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: -2
                            anchors.left:parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: Kirigami.Units.smallSpacing
                            anchors.rightMargin: Kirigami.Units.smallSpacing

                            elide: Qt.ElideRight
                            wrapMode: Qt.WordWrap
                            color: Kirigami.Theme.textColor
                        }
                    }
                }
            }
        }

        // Icons (all)

        MobileForm.FormCard {
            id: formCardGroup
            Layout.fillWidth: true
            Layout.bottomMargin: Kirigami.Units.largeSpacing

            contentItem: ColumnLayout {

                // spacing: 0

                MobileForm.FormCardHeader {
                    title: i18n("Icons")
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
                        rowSpacing: 5
                        columnSpacing: 0

                        anchors.topMargin: Kirigami.Units.largeSpacing

                        Repeater {
                            id: cardRepeater

                            model: iconsModel

                            delegate: Kirigami.Card {
                                id: card

                                Layout.minimumHeight: 110
                                Layout.maximumHeight: 400

                                property bool cardHovered: false
                                property bool themeSel: selected


                                background: Rectangle {
                                    anchors.fill: parent
                                    opacity: 0
                                }

                                Component.onCompleted: {
                                    opacityAnimation.start()

                                    // Mutar para columnas adaptables
                                    // grid.columns = 5

                                    formCardGroup.height = Layout.minimumHeight * (Math.ceil(IconsBackend.iconsThemes / (grid.width / 100)))
                                    iconsThemesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing
                                    iconsThemesPage.flickable.width = iconsThemesPage.width

                                    selectedLabel.text = iconsModel.get(IconsBackend.selectedTheme).name
                                    formTextSelected.height = 100
                                    selectedBanner.color = Kirigami.Theme.backgroundColor
                                }

                                Connections {
                                    target: formCardHeader
                                    onWidthChanged: {
                                        formCardHeader.height = Layout.minimumHeight * (Math.ceil(IconsBackend.themesCount / grid.columns))
                                        iconsThemesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing * 3 + 65 + formSelected.height
                                        iconsThemesPage.flickable.width = iconsThemesPage.width
                                    }
                                    onHeightChanged: {
                                        formCardHeader.height = Layout.minimumHeight * (Math.ceil(IconsBackend.themesCount / grid.columns))
                                        iconsThemesPage.flickable.contentHeight = formCardGroup.height + Kirigami.Units.largeSpacing * 3 + 65 + formSelected.height
                                        iconsThemesPage.flickable.width = iconsThemesPage.width
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

                                // Banner

                                Rectangle {
                                    id: banner
                                    anchors.left: nameRect.left
                                    anchors.right: nameRect.right
                                    anchors.top: card.top
                                    anchors.bottom: card.bottom
                                    anchors.topMargin: nameRect.anchors.margins
                                    anchors.bottomMargin: nameRect.anchors.margins
                                    radius: 4
                                    border.width: 1
                                    property color dColor: Kirigami.Theme.disabledTextColor
                                    border.color: Qt.rgba(dColor.r,dColor.g,dColor.b,0.8)

                                    color: windowColor

                                    Component.onCompleted: {
                                        bannerOpacityAnimation.start()
                                    }

                                    PropertyAnimation {
                                        id: bannerOpacityAnimation
                                        target: banner
                                        properties: "opacity"
                                        from: 0.0
                                        to: 0.6
                                        duration: 750
                                        easing.type: Easing.InExpo
                                    }
                                }

                                // Name

                                Rectangle {

                                    id: nameRect

                                    anchors.left: card.left

                                    anchors.bottom: card.bottom
                                    anchors.margins: 7
                                    width: 90
                                    height: 30
                                    opacity: 1.0
                                    radius: 4
                                    Kirigami.Theme.colorSet: Kirigami.Theme.Window
                                    property color dColor: Kirigami.Theme.disabledTextColor
                                    border.width: 1
                                    border.color: Qt.rgba(dColor.r,dColor.g,dColor.b,0.8)

                                    color: Kirigami.Theme.backgroundColor

                                    Controls.Label {
                                        id: nameLabel
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.verticalCenterOffset: -2
                                        anchors.left:parent.left
                                        anchors.right: parent.right
                                        anchors.leftMargin: Kirigami.Units.smallSpacing
                                        anchors.rightMargin: Kirigami.Units.smallSpacing

                                        text: name
                                        elide: Qt.ElideRight
                                        wrapMode: Qt.WordWrap
                                        color: Kirigami.Theme.textColor
                                    }
                                }

                                // Selection icon (circle)

                                Rectangle {
                                    id: selectIconRect
                                    implicitWidth: Kirigami.Units.iconSizes.medium
                                    implicitHeight: Kirigami.Units.iconSizes.medium
                                    anchors.centerIn: banner
                                    anchors.verticalCenterOffset: 0 - nameRect.height / 2
                                    scale: 1.2
                                    radius: width
                                    Kirigami.Theme.colorSet: Kirigami.Theme.View
                                    Kirigami.Theme.inherit: false
                                    color: Kirigami.Theme.disabledTextColor
                                    opacity: 0.1
                                    visible: themeSel ? true : false
                                }

                                // Selection icon (icon)

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
                                    hoverEnabled: true

                                    onClicked: {
                                        var fcount = IconsBackend.themesCount
                                        for (var i = 0 ; i < fcount ; i++) {
                                            iconsModel.setProperty(i, "selected", false)
                                        }
                                        iconsModel.setProperty(index, "selected", true)
                                        IconsBackend.setSelectedTheme(index)
                                        selectedLabel.text = iconsModel.get(IconsBackend.selectedTheme).name
                                        selectedBanner.color = Kirigami.Theme.backgroundColor
                                    }

                                    onEntered: {
                                        //
                                    }
                                    onExited: {
                                        //
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
