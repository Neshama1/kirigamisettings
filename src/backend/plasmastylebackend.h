// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2022 asterion <email>
// SPDX-License-Identifier: LGPL-2.1-or-later

#ifndef PLASMASTYLEBACKEND_H
#define PLASMASTYLEBACKEND_H

#include <QDebug>
#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>
#include <QString>
#include <QDir>
#include <QProcess>
#include <KConfig>
#include <KConfigGroup>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>
#include <QFile>


/**
 * @todo write docs
 */
class PlasmaStyleBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString selectedStyle READ selectedStyle WRITE setSelectedStyle NOTIFY selectedStyleChanged)
    Q_PROPERTY(int stylesCount READ stylesCount WRITE setFilesCount NOTIFY stylesCountChanged)
    Q_PROPERTY(QVariantList plasmaStyles READ plasmaStyles WRITE setPlasmaStyles NOTIFY plasmaStylesChanged)

public:
    /**
     * Default constructor
     */
    PlasmaStyleBackend();

    /**
     * Destructor
     */
    ~PlasmaStyleBackend();

    /**
     * @return the selectedStyle
     */
    QString selectedStyle() const;

    /**
     * @return the stylesCount
     */
    int stylesCount() const;

    /**
     * @return the plasmaStyles
     */
    QVariantList plasmaStyles() const;

public Q_SLOTS:
    /**
     * Sets the selectedStyle.
     *
     * @param selectedStyle the new selectedStyle
     */
    void setSelectedStyle(const QString& selectedStyle);

    /**
     * Sets the stylesCount.
     *
     * @param stylesCount the new stylesCount
     */
    void setFilesCount(int stylesCount);

    /**
     * Sets the plasmaStyles.
     *
     * @param plasmaStyles the new plasmaStyles
     */
    void setPlasmaStyles(QVariantList plasmaStyles);

Q_SIGNALS:
    void selectedStyleChanged(const QString& selectedStyle);

    void stylesCountChanged(int stylesCount);

    void plasmaStylesChanged(QVariantList plasmaStyles);

private:
    QString m_selectedStyle;
    int m_stylesCount;
    QVariantList m_plasmaStyles;

    QStringList GetPlasmaStylesFolderList(QString path) const;
};

#endif // PLASMASTYLEBACKEND_H
