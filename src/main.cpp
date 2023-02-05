/*
    SPDX-License-Identifier: GPL-2.0-or-later
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
*/

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QtQml>

#include "about.h"
#include "app.h"
#include "version-kirigamisettings.h"
#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>
#include <QQuickStyle>

#include "kirigamisettingsconfig.h"
#include "backend/colorschemesbackend.h"
#include "backend/plasmastylebackend.h"
#include "backend/wallpapersbackend.h"
#include "backend/aboutsystembackend.h"
#include "backend/iconsbackend.h"
#include "backend/cursorsbackend.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("KDE"));
    QCoreApplication::setApplicationName(QStringLiteral("Kirigami Settings"));

    KAboutData aboutData(
                         // The program name used internally.
                         QStringLiteral("Kirigami Settings"),
                         // A displayable program name string.
                         i18nc("@title", "Kirigami Settings"),
                         // The program version string.
                         QStringLiteral(KIRIGAMISETTINGS_VERSION_STRING),
                         // Short description of what the app does.
                         i18n("System manager for KDE platform settings based on Kirigami"),
                         // The license this code is released under.
                         KAboutLicense::LGPL_V3,
                         // Copyright Statement.
                         i18n("(c) 2023"));
    aboutData.addAuthor(i18nc("@info:credit", "Miguel Beltrán"),
                        i18nc("@info:credit", ""),
                        QStringLiteral("hopeandtruth6517@gmail.com"),
                        QStringLiteral("https://github.com/Neshama1/kirigamisettings"));
    KAboutData::setApplicationData(aboutData);

    // Qt Quick Style:
    // QQuickStyle::setStyle("org.kde.breeze");

    QQmlApplicationEngine engine;

    ColorSchemesBackend colorschemesbackend;
    qmlRegisterSingletonInstance<ColorSchemesBackend>("org.kde.KirigamiSettings", 1, 0, "ColorSchemesBackend", &colorschemesbackend);

    PlasmaStyleBackend plasmastylebackend;
    qmlRegisterSingletonInstance<PlasmaStyleBackend>("org.kde.KirigamiSettings", 1, 0, "PlasmaStyleBackend", &plasmastylebackend);

    WallpapersBackend wallpapersbackend;
    qmlRegisterSingletonInstance<WallpapersBackend>("org.kde.KirigamiSettings", 1, 0, "WallpapersBackend", &wallpapersbackend);

    AboutSystemBackend aboutsystembackend;
    qmlRegisterSingletonInstance<AboutSystemBackend>("org.kde.KirigamiSettings", 1, 0, "AboutSystemBackend", &aboutsystembackend);

    IconsBackend iconsbackend;
    qmlRegisterSingletonInstance<IconsBackend>("org.kde.KirigamiSettings", 1, 0, "IconsBackend", &iconsbackend);

    CursorsBackend cursorsbackend;
    qmlRegisterSingletonInstance<CursorsBackend>("org.kde.KirigamiSettings", 1, 0, "CursorsBackend", &cursorsbackend);

    auto config = KirigamiSettingsConfig::self();

    qmlRegisterSingletonInstance("org.kde.KirigamiSettings", 1, 0, "Config", config);

    AboutType about;
    qmlRegisterSingletonInstance("org.kde.KirigamiSettings", 1, 0, "AboutType", &about);

    App application;
    qmlRegisterSingletonInstance("org.kde.KirigamiSettings", 1, 0, "App", &application);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
