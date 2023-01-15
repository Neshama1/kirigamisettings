// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2022 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef COLORSCHEMESBACKEND_H
#define COLORSCHEMESBACKEND_H

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>
#include <QColor>
#include <QString>
#include <QDir>
#include <QProcess>
#include <KConfig>
#include <KConfigGroup>
#include <QDebug>

/**
 * @todo write docs
 */
class ColorSchemesBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int selectedScheme READ selectedScheme WRITE setSelectedScheme NOTIFY selectedSchemeChanged)
    Q_PROPERTY(QVariantList colorSchemes READ colorSchemes WRITE setColorSchemes NOTIFY colorSchemesChanged)
    Q_PROPERTY(int filesCount READ filesCount WRITE setFilesCount NOTIFY filesCountChanged)

public:
    Q_INVOKABLE void getThemes();

public:
    ColorSchemesBackend();
    ~ColorSchemesBackend();

    /**
     * @return the colorSchemes
     */
    QVariantList colorSchemes() const;
    int filesCount() const;
    int selectedScheme() const;

public Q_SLOTS:
    /**
     * Sets the colorSchemes.
     *
     * @param colorSchemes the new colorSchemes
     */
    void setColorSchemes(QVariantList colorSchemes);
    void setFilesCount(int filesCount);
    void setSelectedScheme(int selectedSchemeIndex);

Q_SIGNALS:
    void colorSchemesChanged(QVariantList colorSchemes);
    void filesCountChanged(int filesCount);
    void selectedSchemeChanged(int selectedSchemeIndex);

private:
    QVariantList m_colorSchemes;
    int m_filesCount;
    int m_selectedSchemeIndex;

    QStringList GetColorSchemesFileList(QString path) const;
};

#endif // COLORSCHEMESBACKEND_H
