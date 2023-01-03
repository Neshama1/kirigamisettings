// SPDX-FileCopyrightText: 2022 Name Surnamen <name@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm

Kirigami.ScrollablePage {
    id: generalBehaviorPage
    title: i18n("Settings")

    Component.onCompleted: {
        opacityAnimation.start()
        yAnimation.start()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: generalBehaviorPage
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 600
    }

    PropertyAnimation {
        id: yAnimation
        target: generalBehaviorPage
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
        width: generalBehaviorPage.width

        MobileForm.FormCard {
            Layout.fillWidth: true

            contentItem: ColumnLayout {
                spacing: 0

                MobileForm.FormCardHeader {
                    title: i18n("General")
                }

                MobileForm.FormButtonDelegate {
                    id: aboutDelegate
                    text: i18n("About")
                    //onClicked: applicationWindow().pageStack.layers.push(applicationWindow().getPage("AboutPage"))
                }
            }
        }

        MobileForm.FormCard {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing

            contentItem: ColumnLayout {
                spacing: 0

                MobileForm.FormCardHeader {
                    title: i18n("Accounts")
                }

                MobileForm.FormDelegateSeparator { below: addAccountDelegate }

                MobileForm.FormButtonDelegate {
                    id: addAccountDelegate
                    text: i18n("Add Account")
                    icon.name: "list-add"
                    //onClicked: applicationWindow().pageStack.layers.push("qrc:/accounts/AddAccountPage.qml")
                }
/*
                Repeater {
                    model: MailAccounts.runningMailAgents
                    delegate: MobileForm.AbstractFormDelegate {
                        Layout.fillWidth: true
                        Loader {
                            id: dialogLoader
                            sourceComponent: Kirigami.PromptDialog {
                                id: dialog
                                title: i18n("Configure %1", model.display)
                                subtitle: i18n("Modify or delete this account agent.")
                                standardButtons: Kirigami.Dialog.NoButton

                                customFooterActions: [
                                    Kirigami.Action {
                                        text: i18n("Modify")
                                        iconName: "edit-entry"
                                        onTriggered: {
                                            MailAccounts.openConfigWindow(model.index);
                                            dialog.close();
                                        }
                                    },
                                    Kirigami.Action {
                                        text: i18n("Delete")
                                        iconName: "delete"
                                        onTriggered: {
                                            MailAccounts.remove(model.index);
                                            dialog.close();
                                        }
                                    }
                                ]
                            }
                        }

                        onClicked: {
                            dialogLoader.active = true;
                            dialogLoader.item.open();
                        }

                        contentItem: RowLayout {
                            Kirigami.Icon {
                                source: model.decoration
                                Layout.rightMargin: Kirigami.Units.largeSpacing
                                implicitWidth: Kirigami.Units.iconSizes.medium
                                implicitHeight: Kirigami.Units.iconSizes.medium
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Kirigami.Units.smallSpacing

                                Controls.Label {
                                    Layout.fillWidth: true
                                    text: model.display
                                    elide: Text.ElideRight
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 2
                                    color: Kirigami.Theme.textColor
                                }

                                Controls.Label {
                                    Layout.fillWidth: true
                                    text: model.statusMessage
                                    color: Kirigami.Theme.disabledTextColor
                                    font: Kirigami.Theme.smallFont
                                    elide: Text.ElideRight
                                }
                            }

                            MobileForm.FormArrow {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                direction: MobileForm.FormArrow.Right
                            }
                        }
                    }
                }
*/
            }
        }
    }
}

/*
Kirigami.ScrollablePage {
    id: generalBehaviorPage

    title: i18nc("@title:window", "General Behavior")

    Component.onCompleted: {
        opacityAnimation.start()
        yAnimation.start()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: generalBehaviorPage
        properties: "opacity"
        from: 0.0
        to: 1.0
        duration: 600
    }

    PropertyAnimation {
        id: yAnimation
        target: generalBehaviorPage
        properties: "y"
        from: -5
        to: 0
        duration: 300
    }

    ColumnLayout {
        Kirigami.FormLayout {
            Layout.fillWidth: true
            QQC2.CheckBox {
                Kirigami.FormData.label: i18n("General settings:")
                text: i18n("Close to system tray")
                checked: Config.systemTray
                visible: Controller.supportSystemTray
                enabled: !Config.isSystemTrayImmutable
                onToggled: {
                    Config.systemTray = checked
                    Config.save()
                }
            }
            QQC2.CheckBox {
                text: i18n("Minimize to system tray on startup")
                checked: Config.minimizeToSystemTrayOnStartup
                visible: Controller.supportSystemTray && !Kirigami.Settings.isMobile
                enabled: Config.systemTray && !Config.isMinimizeToSystemTrayOnStartupImmutable
                onToggled: {
                    Config.minimizeToSystemTrayOnStartup = checked
                    Config.save()
                }
            }
            QQC2.CheckBox {
                // TODO: When there are enough notification and timeline event
                // settings, make 2 separate groups with FormData labels.
                Kirigami.FormData.label: i18n("Notifications and events:")
                text: i18n("Show notifications")
                checked: Config.showNotifications
                enabled: !Config.isShowNotificationsImmutable
                onToggled: {
                    Config.showNotifications = checked
                    Config.save()
                    NotificationsManager.globalNotificationsEnabled = checked
                }
            }
            QQC2.CheckBox {
                text: i18n("Show leave and join events")
                checked: Config.showLeaveJoinEvent
                enabled: !Config.isShowLeaveJoinEventImmutable
                onToggled: {
                    Config.showLeaveJoinEvent = checked
                    Config.save()
                }
            }
            Component.onCompleted: this.contentItem.wrap = QQC2.Label.Wrap
        }
    }
}
*/
