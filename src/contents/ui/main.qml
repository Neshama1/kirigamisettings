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

    pageStack.globalToolBar.style: Kirigami.Settings.isMobile? Kirigami.ApplicationHeaderStyle.Titles : Kirigami.ApplicationHeaderStyle.Auto
    pageStack.globalToolBar.showNavigationButtons: Kirigami.ApplicationHeaderStyle.ShowBackButton

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    onClosing: App.saveWindowGeometry(root)

    onWidthChanged: saveWindowGeometryTimer.restart()
    onHeightChanged: saveWindowGeometryTimer.restart()
    onXChanged: saveWindowGeometryTimer.restart()
    onYChanged: saveWindowGeometryTimer.restart()

    // Default page when application starts

    Component.onCompleted: {
        App.restoreWindowGeometry(root)
        pageStack.push("qrc:/AboutSystemPage.qml")
        pageStack.currentIndex = 0
    }

    property int pagesNumber: 0

    function closePages() {
        pagesNumber = pageStack.currentIndex + 1

        while (pagesNumber > 0) {
            pageStack.pop(pageStack.currentPage)
            pagesNumber = pagesNumber - 1
        }
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

    // Menu

    globalDrawer: Kirigami.GlobalDrawer {
        id: globalDrawer

        title: i18n("Kirigami Settings")
        titleIcon: "applications-graphics"
        isMenu: root.isMobile

        modal: !wideScreen || Kirigami.Settings.isMobile
        width: 60
        //margins: 0
        //padding: 20

        Behavior on width {
            NumberAnimation {
                duration: 2000
                easing.type: Easing.OutExpo		// Comprobar diferencia en animación tanto con la curva
            }					// OutExpo como sin dicha curva de animación
        }

        header: Kirigami.AbstractApplicationHeader {
        }

        Kirigami.Theme.colorSet: Kirigami.Theme.View

        actions: [
            Kirigami.Action {
                text: i18n("Expand")
                icon.name: "application-exit"
                displayHint: Kirigami.DisplayHint.KeepVisible
                onTriggered: globalDrawer.width = globalDrawer.width == 60 ? 170 : 60
            },/*
            Kirigami.Action {
                text: i18n("About Kirigami Settings")
                icon.name: "help-about"
                displayHint: Kirigami.DisplayHint.KeepVisible
                onTriggered: pageStack.layers.push('qrc:About.qml')
            },*/
            Kirigami.Action {
                text: "Appearance"
                icon.name: "preferences-desktop-theme-global"
                displayHint: Kirigami.DisplayHint.KeepVisible
                onTriggered: {
                    closePages()
                    pageStack.push("qrc:/LooksPage.qml")
                }
            },
            Kirigami.Action {
                text: "About the system"
                icon.name: "preferences-desktop"
                displayHint: Kirigami.DisplayHint.KeepVisible
                onTriggered: {
                    closePages()
                    pageStack.push("qrc:/AboutSystemPage.qml")
                }
            },
            Kirigami.Action {
                text: "Network"
                icon.name: "network-wireless-connected-25.svg"
                displayHint: Kirigami.DisplayHint.KeepVisible
                onTriggered: {
                    closePages()
                    pageStack.push("qrc:/NetworkPage.qml")
                }
            }
        ]
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    // Main page: Home

    pageStack.initialPage: AboutSystemPage
}
