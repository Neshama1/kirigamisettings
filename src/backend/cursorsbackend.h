// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef CURSORSBACKEND_H
#define CURSORSBACKEND_H

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
class CursorsBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList cursorsThemes READ cursorsThemes WRITE setCursorsThemes NOTIFY cursorsThemesChanged)
    Q_PROPERTY(int themesCount READ themesCount WRITE setThemesCount NOTIFY themesCountChanged)
    Q_PROPERTY(int selectedTheme READ selectedTheme WRITE setSelectedTheme NOTIFY selectedThemeChanged)

public:
    Q_INVOKABLE void getThemes();

public:
    /**
     * Default constructor
     */
    CursorsBackend();

    /**
     * Destructor
     */
    ~CursorsBackend();

    /**
     * @return the cursorsThemes
     */
    QVariantList cursorsThemes() const;

    /**
     * @return the themesCount
     */
    int themesCount() const;

    /**
     * @return the selectedTheme
     */
    int selectedTheme() const;

public Q_SLOTS:
    /**
     * Sets the cursorsThemes.
     *
     * @param cursorsThemes the new cursorsThemes
     */
    void setCursorsThemes(QVariantList cursorsThemes);

    /**
     * Sets the themesCount.
     *
     * @param themesCount the new themesCount
     */
    void setThemesCount(int themesCount);

    /**
     * Sets the selectedTheme.
     *
     * @param selectedTheme the new selectedTheme
     */
    void setSelectedTheme(int selectedTheme);

Q_SIGNALS:
    void cursorsThemesChanged(QVariantList cursorsThemes);

    void themesCountChanged(int themesCount);

    void selectedThemeChanged(int selectedTheme);

private:
    QVariantList m_cursorsThemes;
    int m_themesCount;
    int m_selectedTheme;

    QStringList GetCursorsThemesFolderList(QString path) const;
};

#endif // CURSORSBACKEND_H
