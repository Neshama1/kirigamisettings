// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "backend/iconsbackend.h"

IconsBackend::IconsBackend()
{
}

IconsBackend::~IconsBackend()
{
}

int IconsBackend::selectedTheme() const
{
    return m_selectedThemeIndex;
}

void IconsBackend::setSelectedTheme(int selectedThemeIndex)
{
    if (m_selectedThemeIndex == selectedThemeIndex) {
        return;
    }

    qDebug() << "Establecer tema con índice: " << selectedThemeIndex;

    for (int i=0; i<themesCount(); i++) {
        QVariantMap iconTheme = m_iconsThemes[i].toMap();
        iconTheme["selected"] = false;
    }

    QVariantMap iconTheme = m_iconsThemes[selectedThemeIndex].toMap();
    iconTheme["selected"] = true;
    QString selectedTheme = iconTheme["name"].toString();

    qDebug() << "Tema seleccionado: " << selectedTheme;

    // Locate plasma-changeicons
    QProcess *locate = new QProcess(this->parent());
    QStringList argumentsLocate;
    argumentsLocate << "plasma-changeicons";
    locate->start("locate",argumentsLocate);
    locate->waitForFinished();

    QString line = locate->readLine();
    QString changeIconsCommand = line.remove("\n");

    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << selectedTheme;
    process->execute(changeIconsCommand,arguments);

    m_selectedThemeIndex = selectedThemeIndex;
    emit selectedThemeChanged(m_selectedThemeIndex);
}

int IconsBackend::themesCount() const
{
    return m_themesCount;
}

void IconsBackend::setThemesCount(int themesCount)
{
    if (m_themesCount == themesCount) {
        return;
    }

    m_themesCount = themesCount;
    emit themesCountChanged(m_themesCount);
}

QVariantList IconsBackend::iconsThemes() const
{
    return m_iconsThemes;
}

void IconsBackend::setIconsThemes(QVariantList iconsThemes)
{
    if (m_iconsThemes == iconsThemes) {
        return;
    }

    m_iconsThemes = iconsThemes;
    emit iconsThemesChanged(m_iconsThemes);
}

QStringList IconsBackend::GetPlasmaStylesFolderList(QString path) const
{
    QDir directory = QDir(path);
    QStringList folders = directory.entryList(QStringList() << "*", QDir::Dirs | QDir::NoDotAndDotDot);

    return folders;
}

void IconsBackend::getThemes()
{
    m_iconsThemes.clear();

    // Obtener valor de estilo plasma seleccionado
    KConfig defaultThemesFile(QDir::homePath()+"/.config/kdeglobals");
    KConfigGroup icons = defaultThemesFile.group("Icons");
    QString selectedTheme = icons.readEntry("Theme", QString());

    qDebug() << "Default icons theme: " << selectedTheme;

    QStringList folderlist1 = GetPlasmaStylesFolderList(QDir::homePath()+"/.local/share/icons");
    QStringList folderlist2 = GetPlasmaStylesFolderList("/usr/share/icons");

    // Leer la totalidad de iconos

    int j = 0;

    for (int i = 0; i < folderlist1.length(); i++) {

        QString indexTheme = QDir::homePath() + "/.local/share/icons/" + folderlist1[i] + "/" + "index.theme";
        QString cursorsFolder = QDir::homePath() + "/.local/share/icons/" + folderlist1[i] + "/" + "cursors";

        QFile file(indexTheme);
        QDir dir;

        if (file.exists(indexTheme) && dir.exists(cursorsFolder)) {

            QString themePath = QDir::homePath() + "/.local/share/icons/" + folderlist1[i];
            QDir directory = QDir(themePath);
            QStringList files = directory.entryList(QStringList() << "*", QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);

            if (files.count() == 2) {

                // Sólo cursores, no iconos. Interrumpe ejecución y continúa iteración de bucle for
                continue;
            }
        }

        QVariantMap item;

        item["name"] = folderlist1[i];
        item["path"] = QDir::homePath() + "/.local/share/icons";

        if (folderlist1[i] == selectedTheme) {
            item["selected"] = true;
            m_selectedThemeIndex = j;
        }
        else {
            item["selected"] = false;
        }

        m_iconsThemes.append(item);

        j++;
    }

    for (int i = 0; i < folderlist2.length(); i++) {

        QString indexTheme = "/usr/share/icons/" + folderlist2[i] + "/" + "index.theme";
        QString cursorsFolder = "/usr/share/icons/" + folderlist2[i] + "/" + "cursors";

        QFile file(indexTheme);
        QDir dir;

        if (file.exists(indexTheme) && dir.exists(cursorsFolder)) {

            QString themePath = "/usr/share/icons/" + folderlist2[i];
            QDir directory = QDir(themePath);
            QStringList files = directory.entryList(QStringList() << "*", QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);

            if (files.count() == 2) {

                // Sólo cursores, no iconos. Interrumpe ejecución y continúa iteración de bucle for
                continue;
            }
        }

        QVariantMap item;

        item["name"] = folderlist2[i];
        item["path"] = "/usr/share/icons";

        if (folderlist2[i] == selectedTheme) {
            item["selected"] = true;
            m_selectedThemeIndex = j;
        }
        else {
            item["selected"] = false;
        }

        m_iconsThemes.append(item);

        j++;
    }

    m_themesCount = j - 1;
}
