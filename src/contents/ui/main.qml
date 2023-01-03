// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.KirigamiSettings 1.0
import QtGraphicalEffects 1.15

Kirigami.ApplicationWindow {
    id: root

    title: i18n("Kirigami Settings")

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    onClosing: App.saveWindowGeometry(root)

    onWidthChanged: saveWindowGeometryTimer.restart()
    onHeightChanged: saveWindowGeometryTimer.restart()
    onXChanged: saveWindowGeometryTimer.restart()
    onYChanged: saveWindowGeometryTimer.restart()

    Component.onCompleted: {
        App.restoreWindowGeometry(root)
        pageStack.push("qrc:/LooksPage.qml")
        pageStack.push("qrc:/ColorSchemesPage.qml")
        pageStack.currentIndex = 0
    }

    // This timer allows to batch update the window size change to reduce
    // the io load and also work around the fact that x/y/width/height are
    // changed when loading the page and overwrite the saved geometry from
    // the previous session.
    Timer {
        id: saveWindowGeometryTimer
        interval: 1000
        onTriggered: App.saveWindowGeometry(root)
    }

    globalDrawer: Kirigami.GlobalDrawer {
        title: i18n("Kirigami Settings")
        titleIcon: "applications-graphics"
        isMenu: !root.isMobile
        actions: [
            Kirigami.Action {
                text: i18n("About Kirigami Settings")
                icon.name: "help-about"
                onTriggered: pageStack.layers.push('qrc:About.qml')
            },
            Kirigami.Action {
                text: i18n("Quit")
                icon.name: "application-exit"
                onTriggered: Qt.quit()
            }
        ]
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    pageStack.initialPage: page

    Kirigami.ScrollablePage {
        id: page

        title: "Home"

        ListModel {
        id: homeModel
            ListElement {
                name: "Appearance"
                description: "Configure the appearance"
                iconItem: "preferences-desktop-theme-global"
                group: "Look and feel"
            }
            ListElement {
                name: "General Behavior"
                description: ""
                iconItem: "preferences-desktop"
            }
        }

        ListView {
            id: homeListView

            Component.onCompleted: {
                opacityAnimation.start()
                xAnimation.start()
            }

            PropertyAnimation {
                id: opacityAnimation
                target: homeListView
                properties: "opacity"
                from: 0.5
                to: 1.0
                duration: 250
            }

            PropertyAnimation {
                id: xAnimation
                target: homeListView
                properties: "x"
                from: -20
                to: 0
                duration: 250
            }

            // Elements list header (groups)

            section.property: "group"
            section.delegate: sectionDelegate

            Component {
                id: sectionDelegate

                Rectangle {
                    height: 30
                    width: ListView.view.width

                    Kirigami.Theme.colorSet: Kirigami.Theme.Window
                    Kirigami.Theme.inherit: false

                    color: Kirigami.Theme.backgroundColor

                    Kirigami.Label {
                        x: 10
                        height: parent.height
                        font.weight: Font.Light
                        verticalAlignment: Text.AlignVCenter
                        text: section
                    }
                }
            }

            model: homeModel

            // Elements list

            delegate: Kirigami.SwipeListItem {
                id: delegateItem

                height: 45

                RowLayout {
                    Layout.fillHeight: true

                    // Element icon

                    Kirigami.Icon {
                        implicitWidth: Kirigami.Units.iconSizes.smallMedium
                        implicitHeight: Kirigami.Units.iconSizes.smallMedium
                        source: iconItem
                    }

                    // Element text

                    Controls.Label {
                        id: listLabel

                        Layout.fillWidth: true
                        elide: Qt.ElideRight

                        text: name

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                switch (index) {
                                    case 0: {
                                        pageStack.push("qrc:/LooksPage.qml")
                                        return
                                    }
                                    case 1: {
                                        pageStack.push("qrc:/GeneralBehaviorPage.qml")
                                        return
                                    }
                                }
                            }
                        }
                    }
                }

                // Element buttons

                actions: [
                    Kirigami.Action {
                        id: actionSelect
                        Component.onCompleted: {
                            switch (index) {
                                case 0: { visible = true ; return }
                                case 1: { visible = false ; return }
                                case 2: { visible = true ; return }
                            }
                        }
                        icon.name: "go-next"
                        onTriggered: {
                            switch (index) {
                                case 0: {
                                    pageStack.push("qrc:/LooksPage.qml")
                                    return
                                }
                            }
                        }
                    }
                ]
            }
        }
    }
}
