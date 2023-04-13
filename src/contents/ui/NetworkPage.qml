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
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

Kirigami.ScrollablePage {
    id: networkPage

    title: "Network"
    verticalScrollBarPolicy: Controls.ScrollBar.AlwaysOn

    signal aboutToChangeConnection(bool exportable, string name, string path)

    leftPadding: 0
    rightPadding: 0
    topPadding: Kirigami.Units.gridUnit
    bottomPadding: Kirigami.Units.gridUnit

    Component.onCompleted: {
        opacityAnimation.start()
        yAnimation.start()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: networkPage
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 600
    }

    PropertyAnimation {
        id: yAnimation
        target: networkPage
        properties: "y"
        from: -5
        to: 0
        duration: 300
    }

    PlasmaNM.NetworkStatus {
        id: networkStatus
    }

    PlasmaNM.Handler {
        id: handler
    }

    PlasmaNM.KcmIdentityModel {
        id: connectionModel
    }

    PlasmaNM.EditorProxyModel {
        id: editorProxyModel

        sourceModel: connectionModel
    }

    ColumnLayout {

        MobileForm.FormCard {
            id: formCardGroup1
            Layout.fillWidth: true
            Layout.bottomMargin: Kirigami.Units.largeSpacing

            contentItem: ColumnLayout {

                // spacing: 0

                MobileForm.FormCardHeader {
                    title: i18n("Selected network")
                }

                MobileForm.FormTextDelegate {
                    text: networkStatus.activeConnections
                }
            }
        }

        MobileForm.FormCard {
            id: formCardGroup2
            Layout.fillWidth: true
            Layout.bottomMargin: Kirigami.Units.largeSpacing

            contentItem: ColumnLayout {

                MobileForm.FormCardHeader {
                    title: i18n("Network")
                }

                Repeater {
                    id: formTextRepeater

                    model: editorProxyModel

                    delegate: MobileForm.FormTextDelegate {
                        id: infoRect

                        background: Rectangle {
                            anchors.fill: parent
                            color: hovered ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor
                        }

                        text: Name

                        onClicked: {
                            handler.activateConnection(ConnectionPath, DevicePath, SpecificPath);
                        }
                    }
                }
            }
        }
    }
}
