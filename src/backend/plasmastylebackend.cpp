// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2022 asterion <email>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "backend/plasmastylebackend.h"
#include <QAbstractListModel>

PlasmaStyleBackend::PlasmaStyleBackend()
{

}

PlasmaStyleBackend::~PlasmaStyleBackend()
{

}

int PlasmaStyleBackend::selectedStyle() const
{
    return m_selectedStyleIndex;
}

void PlasmaStyleBackend::setSelectedStyle(int selectedStyleIndex)
{
    if (m_selectedStyleIndex == selectedStyleIndex) {
        return;
    }

    for (int i=0; i<stylesCount(); i++) {
        QVariantMap plasmaStyle = m_plasmaStyles[i].toMap();
        plasmaStyle["selected"] = false;
    }

    QVariantMap plasmaStyle = m_plasmaStyles[selectedStyleIndex].toMap();
    plasmaStyle["selected"] = true;
    QString selectedStyle = plasmaStyle["folder"].toString();

    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << selectedStyle;
    process->execute("plasma-apply-desktoptheme",arguments);

    m_selectedStyleIndex = selectedStyleIndex;
    emit selectedStyleChanged(m_selectedStyleIndex);
}

int PlasmaStyleBackend::stylesCount() const
{
    return m_stylesCount;
}

void PlasmaStyleBackend::setStylesCount(int stylesCount)
{
    if (m_stylesCount == stylesCount) {
        return;
    }

    m_stylesCount = stylesCount;
    emit stylesCountChanged(m_stylesCount);
}

QVariantList PlasmaStyleBackend::plasmaStyles() const
{
    return m_plasmaStyles;
}

void PlasmaStyleBackend::setPlasmaStyles(QVariantList plasmaStyles)
{
    if (m_plasmaStyles == plasmaStyles) {
        return;
    }

    m_plasmaStyles = plasmaStyles;
    emit plasmaStylesChanged(m_plasmaStyles);
}

QStringList PlasmaStyleBackend::GetPlasmaStylesFolderList(QString path) const
{
    QDir directory = QDir(path);
    QStringList folders = directory.entryList(QStringList() << "*", QDir::Dirs | QDir::NoDotAndDotDot);

    return folders;
}

void PlasmaStyleBackend::getThemes()
{
    m_plasmaStyles.clear();

    // Obtener valor de estilo plasma seleccionado
    KConfig defaultThemesFile(QDir::homePath()+"/.config/plasmarc");
    KConfigGroup theme = defaultThemesFile.group("Theme");
    QString selectedStyle = theme.readEntry("name", QString());

    // Obtener cuenta de esquemas de color
    QStringList folderlist1 = GetPlasmaStylesFolderList(QDir::homePath()+"/.local/share/plasma/desktoptheme");
    QStringList folderlist2 = GetPlasmaStylesFolderList("/usr/share/plasma/desktoptheme");
    int count = folderlist1.length() + folderlist2.length();

    m_stylesCount = count;
    qDebug() << "Plasma themes number: " << count;

    // Idioma del sistema:

    QFile inputFile(QString(QDir::homePath() + "/.config/user-dirs.locale"));
    inputFile.open(QIODevice::ReadOnly);
    if (!inputFile.isOpen())
        return;

    QTextStream stream(&inputFile);
    QString line = stream.readLine();

    QString locale = line;
    QString shortLocale = locale.mid(0,2);

    // Leer la totalidad de estilos plasma
    for (int i = 0; i < folderlist1.length(); i++) {

        QVariantMap item;

        item["folder"] = folderlist1[i];
        item["path"] = QDir::homePath() + "/.local/share/plasma/desktoptheme";

        if (folderlist1[i] == selectedStyle) {
            item["selected"] = true;
        }
        else {
            item["selected"] = false;
        }

        QString path1 = QDir::homePath() + "/.local/share/plasma/desktoptheme/" + folderlist1[i] + "/" + "metadata.desktop";
        QFile file1(path1);

        if (file1.exists(path1)) {
            KConfig plasmaStyle(path1);
            KConfigGroup desktopEntry = plasmaStyle.group("Desktop Entry");
            item["name"] = desktopEntry.readEntry("Name", QString());
            m_plasmaStyles.append(item);
        }

        QString path2 = QDir::homePath() + "/.local/share/plasma/desktoptheme/" + folderlist1[i] + "/" + "metadata.json";
        QFile file2(path2);

        if (file2.exists(path2)) {
            file2.open(QIODevice::ReadOnly | QIODevice::Text);
            QString val;
            val = file2.readAll();
            file2.close();

            QJsonDocument jsonDocument = QJsonDocument::fromJson(val.toUtf8());
            QJsonObject documentObject = jsonDocument.object();

            QJsonObject objectKPlugin = documentObject.value(QString("KPlugin")).toObject();

            QString name;

            QString localeName = "Name[" + locale + "]";
            QString shortLocaleName = "Name[" + shortLocale + "]";

            if (objectKPlugin[localeName].toString() != "") {
                name = objectKPlugin[localeName].toString();
            }
            else if (objectKPlugin[shortLocaleName].toString() != "") {
                name = objectKPlugin[shortLocaleName].toString();
            }
            else {
                name = objectKPlugin["Name"].toString();
            }

            item["name"] = name;

            m_plasmaStyles.append(item);
        }
    }

    for (int i = 0; i < folderlist2.length(); i++) {

        QVariantMap item;

        item["folder"] = folderlist2[i];
        item["path"] = "/usr/share/plasma/desktoptheme";

        if (folderlist2[i] == selectedStyle) {
            item["selected"] = true;
        }
        else {
            item["selected"] = false;
        }

        QString path1 = "/usr/share/plasma/desktoptheme/" + folderlist2[i] + "/" + "metadata.desktop";
        QFile file1(path1);

        if (file1.exists(path1)) {
            KConfig plasmaStyle(path1);
            KConfigGroup desktopEntry = plasmaStyle.group("Desktop Entry");
            item["name"] = desktopEntry.readEntry("Name", QString());
            m_plasmaStyles.append(item);
        }

        QString path2 = "/usr/share/plasma/desktoptheme/" + folderlist2[i] + "/" + "metadata.json";
        QFile file2(path2);

        if (file2.exists(path2)) {
            file2.open(QIODevice::ReadOnly | QIODevice::Text);
            QString val;
            val = file2.readAll();
            file2.close();

            QJsonDocument jsonDocument = QJsonDocument::fromJson(val.toUtf8());
            QJsonObject documentObject = jsonDocument.object();

            QJsonObject objectKPlugin = documentObject.value(QString("KPlugin")).toObject();

            QString name;

            QString localeName = "Name[" + locale + "]";
            QString shortLocaleName = "Name[" + shortLocale + "]";

            if (objectKPlugin[localeName].toString() != "") {
                name = objectKPlugin[localeName].toString();
            }
            else if (objectKPlugin[shortLocaleName].toString() != "") {
                name = objectKPlugin[shortLocaleName].toString();
            }
            else {
                name = objectKPlugin["Name"].toString();
            }

            item["name"] = name;

            m_plasmaStyles.append(item);
        }
    }
}

