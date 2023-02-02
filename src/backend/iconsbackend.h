// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef ICONSBACKEND_H
#define ICONSBACKEND_H

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>
#include <QString>
#include <QDir>
#include <QProcess>
#include <KConfig>
#include <KConfigGroup>
#include <QDebug>

/**
 * @todo write docs
 */
class IconsBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int selectedTheme READ selectedTheme WRITE setSelectedTheme NOTIFY selectedThemeChanged)
    Q_PROPERTY(int themesCount READ themesCount WRITE setThemesCount NOTIFY themesCountChanged)
    Q_PROPERTY(QVariantList iconsThemes READ iconsThemes WRITE setIconsThemes NOTIFY iconsThemesChanged)

public:
    Q_INVOKABLE void getThemes();

public:
    /**
     * Default constructor
     */
    IconsBackend();

    /**
     * Destructor
     */
    ~IconsBackend();

    /**
     * @return the selectedTheme
     */
    int selectedTheme() const;

    /**
     * @return the themesCount
     */
    int themesCount() const;

    /**
     * @return the iconsThemes
     */
    QVariantList iconsThemes() const;

public Q_SLOTS:
    /**
     * Sets the selectedTheme.
     *
     * @param selectedTheme the new selectedTheme
     */
    void setSelectedTheme(int selectedThemeIndex);

    /**
     * Sets the themesCount.
     *
     * @param themesCount the new themesCount
     */
    void setThemesCount(int themesCount);

    /**
     * Sets the iconsThemes.
     *
     * @param iconsThemes the new iconsThemes
     */
    void setIconsThemes(QVariantList iconsThemes);

Q_SIGNALS:
    void selectedThemeChanged(int selectedThemeIndex);

    void themesCountChanged(int themesCount);

    void iconsThemesChanged(QVariantList iconsThemes);

private:
    int m_selectedThemeIndex;
    int m_themesCount;
    QVariantList m_iconsThemes;


    QStringList GetPlasmaStylesFolderList(QString path) const;
};

#endif // ICONSBACKEND_H
