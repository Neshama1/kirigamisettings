// SPDX-FileCopyrightText: 2022 Name Surnamen <name@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.15 as Kirigami
import org.kde.KirigamiSettings 1.0
import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm

Kirigami.ScrollablePage {
    id: aboutSystemPage
    title: i18n("Settings")

    Component.onCompleted: {
        opacityAnimation.start()
        yAnimation.start()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: aboutSystemPage
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 600
    }

    PropertyAnimation {
        id: yAnimation
        target: aboutSystemPage
        properties: "y"
        from: -5
        to: 0
        duration: 300
    }

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: false

    leftPadding: 0
    rightPadding: 0
    topPadding: Kirigami.Units.gridUnit
    bottomPadding: Kirigami.Units.gridUnit

    ColumnLayout {
        spacing: 0
        width: aboutSystemPage.width

        MobileForm.FormCard {
            Layout.fillWidth: true

            contentItem: ColumnLayout {
                spacing: 0

                MobileForm.FormCardHeader {
                    title: i18n("OS")
                }

                MobileForm.FormTextDelegate {
                    text: AboutSystemBackend.osName
                }
                MobileForm.FormTextDelegate {
                    text: AboutSystemBackend.architecture
                }
                MobileForm.FormTextDelegate {
                    text: AboutSystemBackend.kernelVersion
                }
                MobileForm.FormTextDelegate {
                    text: AboutSystemBackend.hostname
                }
                MobileForm.FormTextDelegate {
                    text: AboutSystemBackend.userName
                }
                MobileForm.FormTextDelegate {
                    text: AboutSystemBackend.memorySize
                }
                MobileForm.FormTextDelegate {
                    text: AboutSystemBackend.internalStorage
                }
                MobileForm.FormTextDelegate {
                    text: AboutSystemBackend.cpuInfo
                }
            }
        }
    }
}
