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
import org.kde.plasma.private.volume 0.1
import org.kde.plasma.core 2.1 as PlasmaCore

Kirigami.ScrollablePage {
    id: networkPage

    title: "Sound"
    verticalScrollBarPolicy: Controls.ScrollBar.AlwaysOn

    leftPadding: 0
    rightPadding: 0
    topPadding: Kirigami.Units.gridUnit
    bottomPadding: Kirigami.Units.gridUnit

    GlobalConfig {
        id: config
    }
/*
    property bool volumeFeedback: config.audioFeedback
    property bool globalMute: config.globalMute
    property int currentMaxVolumePercent: config.raiseMaximumVolume ? 150 : 100
    property int currentMaxVolumeValue: currentMaxVolumePercent * PulseAudio.NormalVolume / 100.00
    property int volumePercentStep: config.volumeStep
    property string displayName: i18n("Audio Volume")
    property QtObject draggedStream: null

    function audioIcon(value) {
        if (value <= 0)
            return "audio-volume-muted-symbolic"
        else if (value <= 25)
            return "audio-volume-low-symbolic"
        else if (value <= 75)
            return "audio-volume-medium-symbolic"
        else
            return "audio-volume-high-symbolic"
    }

    function microphoneIcon(value) {
        if (value <= 25)
            return "audio-input-microphone-low-symbolic"
        else if (value <= 70)
            return "audio-input-microphone-medium-symbolic"
        else
            return "audio-input-microphone-high-symbolic"
    }
*/
    SinkModel {
        id: paSinkModel
    }

    SourceModel {
        id: paSourceModel
    }

    PulseObjectFilterModel {
        id: paSinkFilterModel
        sortRole: "SortByDefault"
        sortOrder: Qt.DescendingOrder
        filterOutInactiveDevices: true
        sourceModel: paSinkModel
    }

    PulseObjectFilterModel {
        id: paSourceFilterModel
        sortRole: "SortByDefault"
        sortOrder: Qt.DescendingOrder
        filterOutInactiveDevices: true
        sourceModel: paSourceModel
    }

    ColumnLayout {

        MobileForm.FormCard {
            id: formCardGroup1
            Layout.fillWidth: true
            Layout.bottomMargin: Kirigami.Units.largeSpacing

            contentItem: ColumnLayout {

                MobileForm.FormCardHeader {
                    title: i18n("Input Devices")
                }

                Repeater {
                    id: formTextRepeater1

                    model: paSourceFilterModel
                    delegate: MobileForm.FormTextDelegate {
                        id: infoRect1

                        background: Rectangle {
                            anchors.fill: parent
                            color: hovered ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor
                        }

                        text: Description
                    }
                }
            }
        }

        MobileForm.FormCard {
            id: formCardGroup2
            Layout.fillWidth: true
            Layout.bottomMargin: Kirigami.Units.largeSpacing

            contentItem: ColumnLayout {

                MobileForm.FormCardHeader {
                    title: i18n("Output Devices")
                }

                Repeater {
                    id: formTextRepeater2

                    model: paSinkFilterModel
                    delegate: MobileForm.FormTextDelegate {
                        id: infoRect2

                        background: Rectangle {
                            anchors.fill: parent
                            color: hovered ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor
                        }

                        text: Description
                    }
                }
            }
        }
    }
}
