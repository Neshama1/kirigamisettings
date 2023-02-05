// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2022 asterion <email>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "backend/wallpapersbackend.h"

WallpapersBackend::WallpapersBackend()
{
}

WallpapersBackend::~WallpapersBackend()
{
}

int WallpapersBackend::selectedWallpaper() const
{
    return m_selectedWallpaperIndex;
}

void WallpapersBackend::setSelectedWallpaper(int selectedWallpaperIndex)
{
    if (m_selectedWallpaperIndex == selectedWallpaperIndex) {
        return;
    }


    for (int i=0; i<filesCount(); i++) {
        QVariantMap wallpaper = m_wallpapers[i].toMap();
        wallpaper["selected"] = false;
    }

    QVariantMap wallpaper = m_wallpapers[selectedWallpaperIndex].toMap();
    wallpaper["selected"] = true;
    QString wallpaperName = wallpaper["paperUrl"].toString();

    QProcess *blendEffectProcess = new QProcess(this->parent());
    QStringList blendEffectArguments;
    blendEffectArguments << "org.kde.KWin" << "/org/kde/KWin/BlendChanges" << "start" << "100";
    blendEffectProcess->execute("qdbus-qt5",blendEffectArguments);

    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << wallpaperName;
    process->execute("plasma-apply-wallpaperimage",arguments);

    m_selectedWallpaperIndex = selectedWallpaperIndex;
    emit selectedWallpaperChanged(m_selectedWallpaperIndex);
}

int WallpapersBackend::filesCount() const
{
    return m_filesCount;
}

void WallpapersBackend::setFilesCount(int filesCount)
{
    if (m_filesCount == filesCount) {
        return;
    }

    m_filesCount = filesCount;
    emit filesCountChanged(m_filesCount);
}

QVariantList WallpapersBackend::wallpapers() const
{
    return m_wallpapers;
}

void WallpapersBackend::setWallpapers(QVariantList wallpapers)
{
    if (m_wallpapers == wallpapers) {
        return;
    }

    m_wallpapers = wallpapers;
    emit wallpapersChanged(m_wallpapers);
}

void WallpapersBackend::getThemes()
{
    m_wallpapers.clear();

    // Obtener el fondo de pantalla seleccionado
    KConfig wallpaperConfigFile(QDir::homePath()+"/.config/plasma-org.kde.plasma.desktop-appletsrc");
    KConfigGroup defaultWallpaperPlugin = wallpaperConfigFile.group("Containments").group("27").group("Wallpaper").group("org.kde.image").group("General");
    QString selectedWallpaper = defaultWallpaperPlugin.readEntry("Image", QString());
    selectedWallpaper.remove("file://");

    qDebug() << "Selected wallpaper: " << selectedWallpaper;

    // User wallpapers
    KConfig userWallpaperConfigFile(QDir::homePath()+"/.config/plasmarc");
    KConfigGroup wallpapersGroup = userWallpaperConfigFile.group("Wallpapers");
    QStringList filelist1 = wallpapersGroup.readEntry("usersWallpapers", QStringList());

    m_filesCount = 0;

    for (int i=0; i<filelist1.length(); i++) {
        QFileInfo wallpaperFile(filelist1[i]);

        if (wallpaperFile.exists() && wallpaperFile.isFile()){
            QVariantMap item;

            QString paperUrl = filelist1[i];
            QString paperName = filelist1[i].section('/', -1);

            item["name"] = paperName;
            item["paperUrl"] = paperUrl;

            if (paperUrl == selectedWallpaper) {
                item["selected"] = true;
                m_selectedWallpaperIndex = i;
            }
            else {
                item["selected"] = false;
            }

            QStringList paperSizes;
            paperSizes << paperUrl;

            item["paperSizes"] = paperSizes;
            item["paperSizesAvailable"] = false;

            m_wallpapers.append(item);
            m_filesCount += 1;
        }
    }

    // System wallpapers
    QStringList paperPacks;
    QDirIterator folder("/usr/share/wallpapers", QDir::Dirs | QDir::NoDotAndDotDot);
    while (folder.hasNext()) {
        paperPacks << folder.next();
    }

    for (int i=0; i<paperPacks.length(); i++) {

        QStringList metadataFiles;
        QStringList filters;
        filters << "*.desktop" << "*.json";
        QDirIterator file(paperPacks[i], filters, QDir::Files, QDirIterator::Subdirectories);
        while (file.hasNext()) {
            metadataFiles << file.next();
        }

        if (metadataFiles.length() == 0) {
            QStringList paperFiles;
            QStringList filesFilters;
            filters << "*.jpg" << "*.png" << "*.jpeg";
            QDirIterator paperFile(paperPacks[i], filesFilters, QDir::Files, QDirIterator::Subdirectories);
            while (paperFile.hasNext()) {
                paperFiles << paperFile.next();
            }

            for (int j=0; j<paperFiles.length(); j++) {
                QVariantMap item;

                QString paperUrl = paperFiles[j];
                QString paperName = paperFiles[j].section('/', -1);

                item["name"] = paperName;
                item["paperUrl"] = paperUrl;

                if (paperUrl == selectedWallpaper) {
                    item["selected"] = true;
                    m_selectedWallpaperIndex = i;
                }
                else {
                    item["selected"] = false;
                }

                QStringList paperSizes;
                paperSizes << paperUrl;

                item["paperSizes"] = paperSizes;
                item["paperSizesAvailable"] = false;

                m_wallpapers.append(item);
                m_filesCount += 1;
            }
        }
        else {
            for (int k=0; k<metadataFiles.length(); k++) {
                if (metadataFiles[k].contains("metadata.desktop")) {

                    QString metadataUrl = metadataFiles[k];
                    QString basePath = metadataFiles[k].remove("metadata.desktop");
                    QString paperPath = basePath + "contents/images/";

                    QStringList paperSizes;
                    QStringList filesFilters;
                    filters << "*.jpg" << "*.png" << "*.jpeg";
                    QDirIterator paperSize(paperPath, filesFilters, QDir::Files);
                    while (paperSize.hasNext()) {
                        paperSizes << paperSize.next();
                    }

                    // Query the Screen resolution
                    QScreen *screen = qApp->primaryScreen();
                    int screenWidth = screen->geometry().width();
                    int screenHeight = screen->geometry().height();

                    QString paperURL;
                    QString screenSize = QString::number(screenWidth) + "x" + QString::number(screenHeight);

                    for (int l=0; l<paperSizes.length(); l++) {
                        QString size = paperSizes[l];
                        if (size.contains(screenSize)) {
                            paperURL = paperSizes[l];
                        }
                    }

                    for (int m=0; m<paperSizes.length(); m++) {
                        if (paperURL.isNull()) {

                            QString paper = paperSizes[m];
                            QString size = paper.section('/', -1);
                            QString width = size.section("x",0,0);
                            QString height = size.section("x",1,1);
                            QString cleanHeight = height;

                            if (height.contains(".jpg")) {
                                cleanHeight = cleanHeight.remove(".jpg");
                            }
                            else if (height.contains(".png")) {
                                cleanHeight = cleanHeight.remove(".png");
                            }
                            else {
                                cleanHeight = cleanHeight.remove(".jpeg");
                            }

                            if (width.toInt() >= screenWidth) {
                                if (cleanHeight.toInt() >= screenHeight) {
                                    paperURL = paperPath + width + "x" + height;
                                }
                            }
                        }
                    }

                    if (paperURL.isNull()) {
                        int length = paperSizes.length();
                        paperURL = paperSizes[length-1];
                    }

                    // Item

                    QVariantMap item;

                    KConfig metadataFile(metadataUrl);
                    KConfigGroup desktopEntry = metadataFile.group("Desktop Entry");

                    item["name"] = desktopEntry.readEntry("Name", QString());
                    item["paperUrl"] = paperURL;

                    if (paperURL == selectedWallpaper) {
                        item["selected"] = true;
                    }
                    else {
                        item["selected"] = false;
                    }

                    item["paperSizes"] = paperSizes;

                    if (paperSizes.length() > 1) {
                        item["paperSizesAvailable"] = true;
                    }
                    else {
                        item["paperSizesAvailable"] = false;
                    }

                    m_wallpapers.append(item);
                    m_filesCount += 1;
                }
            }
        }
    }
}
