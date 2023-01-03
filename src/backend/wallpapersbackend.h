// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2022 asterion <email>
// SPDX-License-Identifier: LGPL-2.1-or-later

#ifndef WALLPAPERSBACKEND_H
#define WALLPAPERSBACKEND_H

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>
#include <QString>
#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QProcess>
#include <QDebug>
#include <KConfig>
#include <KConfigGroup>
#include <QApplication>
#include <QScreen>

/**
 * @todo write docs
 */
class WallpapersBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString selectedWallpaper READ selectedWallpaper WRITE setSelectedWallpaper NOTIFY selectedWallpaperChanged)
    Q_PROPERTY(int filesCount READ filesCount WRITE setFilesCount NOTIFY filesCountChanged)
    Q_PROPERTY(QVariantList wallpapers READ wallpapers WRITE setWallpapers NOTIFY wallpapersChanged)

public:
    /**
     * Default constructor
     */
    WallpapersBackend();

    /**
     * Destructor
     */
    ~WallpapersBackend();

    /**
     * @return the selectedWallpaper
     */
    QString selectedWallpaper() const;

    /**
     * @return the filesCount
     */
    int filesCount() const;

    /**
     * @return the wallpapers
     */
    QVariantList wallpapers() const;

public Q_SLOTS:
    /**
     * Sets the selectedWallpaper.
     *
     * @param selectedWallpaper the new selectedWallpaper
     */
    void setSelectedWallpaper(const QString& selectedWallpaper);

    /**
     * Sets the filesCount.
     *
     * @param filesCount the new filesCount
     */
    void setFilesCount(int filesCount);

    /**
     * Sets the wallpapers.
     *
     * @param wallpapers the new wallpapers
     */
    void setWallpapers(QVariantList wallpapers);

Q_SIGNALS:
    void selectedWallpaperChanged(const QString& selectedWallpaper);

    void filesCountChanged(int filesCount);

    void wallpapersChanged(QVariantList wallpapers);

private:
    QString m_selectedWallpaper;
    int m_filesCount;
    QVariantList m_wallpapers;
};

#endif // WALLPAPERSBACKEND_H
