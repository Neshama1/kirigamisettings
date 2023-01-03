// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.KirigamiSettings 1.0
import QtQml 2.15
import QtGraphicalEffects 1.15

Kirigami.ScrollablePage {
    id: colorSchemesPage

    title: "Color schemes"

    background: Rectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.Window
        Kirigami.Theme.inherit: false
        color: Kirigami.Theme.backgroundColor
    }

    Component.onCompleted: {
        getColorSchemes()
        opacityButtonAnimation.start()
    }

    function getColorSchemes() {
        var fcount = ColorSchemesBackend.filesCount
        for (var i = 0 ; i < fcount ; i++) {
            colorSchemesModel.append({"name": ColorSchemesBackend.colorSchemes[i].name,"titleBarColor": ColorSchemesBackend.colorSchemes[i].titleBarColor,"windowColor": ColorSchemesBackend.colorSchemes[i].windowColor,"selectionColor": ColorSchemesBackend.colorSchemes[i].selectionColor,"fileName": ColorSchemesBackend.colorSchemes[i].fileName,"path": ColorSchemesBackend.colorSchemes[i].path,"selected": ColorSchemesBackend.colorSchemes[i].selected})
        }
    }

    footer: FloatingActionButton {
        id: floatingButton
        iconName: "list-add"
        onClicked: {
            infoSheet.open()
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

    Kirigami.OverlaySheet {
        id: infoSheet

        header: Kirigami.Heading {
            text: i18nc("@title:window", "Help")
        }

        Kirigami.FormLayout {
            Controls.Label {
                text: "Texto informativo"
            }
        }
    }

    ListModel {
        id: colorSchemesModel
    }

    Kirigami.CardsListView {
        id: cardList
        anchors.fill: parent
        Layout.fillHeight: true

        model: colorSchemesModel

        delegate: Kirigami.Card {
            id: card

            Component.onCompleted: {
                xAnimation.start()
                opacityAnimation.start()
            }

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
                duration: 800
            }

            actions: [
                Kirigami.Action {
                    text: qsTr("Remove scheme")
                    icon.name: "edit-delete-remove"
                    visible: path == "/usr/share/color-schemes" ? false : true
                }
            ]
            banner {
                iconSource: "color-fill"
                opacity: 0.9
                title: name
            }
            contentItem: Kirigami.InlineMessage {
                id: inlineMessage
                text: "Scheme selected"
                visible: selected ? true : false
            }
            onClicked: {
                var fcount = ColorSchemesBackend.filesCount
                for (var i = 0 ; i < fcount ; i++) {
                    colorSchemesModel.setProperty(i, "selected", false)
                }
                selected = true
                ColorSchemesBackend.setSelectedScheme(fileName)
            }
        }
    }
}
