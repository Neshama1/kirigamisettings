// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.KirigamiSettings 1.0

Kirigami.ScrollablePage {
    id: looksPage

    title: "Appearance"

    ListModel {
        id: looksModel

        ListElement { name: "Colors" ; description: "Choose color scheme" ; iconItem: "preferences-desktop-color" }
        ListElement { name: "Plasma Style" ; description: "Choose plasma style" ; iconItem: "preferences-desktop-plasma-theme" }
        ListElement { name: "Wallpapers" ; description: "Choose wallpaper" ; iconItem: "preferences-desktop-wallpaper" }
        ListElement { name: "Icons" ; description: "Choose icon theme" ; iconItem: "preferences-desktop-icons" }
        ListElement { name: "Cursors" ; description: "Choose cursor theme" ; iconItem: "preferences-desktop-cursors" }
        ListElement { name: "Qt Quick Controls Style" ; description: "Choose appearance settings for Kirigami and Mauikit applications" ; iconItem: "QtProject-qtcreator" }
    }

    ListView {
        id: looksListView

        Component.onCompleted: {
            opacity = 0
            animationTimer.start()
        }

        Timer {
            id: animationTimer
            interval: 50; running: true; repeat: false
            onTriggered: {
                opacityAnimation.start()
                xAnimation.start()
            }
        }

        PropertyAnimation {
            id: opacityAnimation
            target: looksListView
            properties: "opacity"
            from: 0.0
            to: 1.0
            duration: 250
        }

        PropertyAnimation {
            id: xAnimation
            target: looksListView
            properties: "x"
            from: -10
            to: 0
            duration: 250
        }

        model: looksModel

        // Elements list

        delegate: Kirigami.BasicListItem {
            id: delegateItem

            height: 60 // 45

            background: Rectangle {
                anchors.fill: parent

                Kirigami.Theme.colorSet: Kirigami.Theme.Window
                //Kirigami.Theme.inherit: false
                color: hovered ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor
            }

            RowLayout {
                Layout.fillHeight: true

                // Element icon

                Kirigami.Icon {
                    //Layout.fillHeight: true
                    Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                    Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                    source: iconItem
                }

                // Element text

                Controls.Label {
                    Layout.fillWidth: true
                    text: name
                    elide: Qt.ElideRight
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            switch (index) {
                                case 0: {
                                    pageStack.push("qrc:/ColorSchemesPage.qml")
                                    return
                                }
                                case 1: {
                                    pageStack.push("qrc:/PlasmaStylePage.qml")
                                    return
                                }
                                case 2: {
                                    pageStack.push("qrc:/WallpapersPage.qml")
                                    return
                                }
                                case 3: {
                                    pageStack.push("qrc:/IconsPage.qml")
                                    return
                                }
                                case 4: {
                                    pageStack.push("qrc:/CursorsPage.qml")
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
