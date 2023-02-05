// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "backend/cursorsbackend.h"

CursorsBackend::CursorsBackend()
{
}

CursorsBackend::~CursorsBackend()
{
}

QVariantList CursorsBackend::cursorsThemes() const
{
    return m_cursorsThemes;
}

void CursorsBackend::setCursorsThemes(QVariantList cursorsThemes)
{
    if (m_cursorsThemes == cursorsThemes) {
        return;
    }

    m_cursorsThemes = cursorsThemes;
    emit cursorsThemesChanged(m_cursorsThemes);
}

int CursorsBackend::themesCount() const
{
    return m_themesCount;
}

void CursorsBackend::setThemesCount(int themesCount)
{
    if (m_themesCount == themesCount) {
        return;
    }

    m_themesCount = themesCount;
    emit themesCountChanged(m_themesCount);
}

int CursorsBackend::selectedTheme() const
{
    return m_selectedTheme;
}

void CursorsBackend::setSelectedTheme(int selectedTheme)
{
    if (m_selectedTheme == selectedTheme) {
        return;
    }

    for (int i=0; i<themesCount(); i++) {
        QVariantMap cursorTheme = m_cursorsThemes[i].toMap();
        cursorTheme["selected"] = false;
    }

    QVariantMap cursorTheme = m_cursorsThemes[selectedTheme].toMap();
    cursorTheme["selected"] = true;
    QString selectedCursorTheme = cursorTheme["folderName"].toString();

    QProcess *blendEffectProcess = new QProcess(this->parent());
    QStringList blendEffectArguments;
    blendEffectArguments << "org.kde.KWin" << "/org/kde/KWin/BlendChanges" << "start" << "100";
    blendEffectProcess->execute("qdbus-qt5",blendEffectArguments);

    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << selectedCursorTheme;
    process->execute("plasma-apply-cursortheme",arguments);

    m_selectedTheme = selectedTheme;
    emit selectedThemeChanged(m_selectedTheme);
}

QStringList CursorsBackend::GetCursorsThemesFolderList(QString path) const
{
    QDir directory = QDir(path);
    QStringList folders = directory.entryList(QStringList() << "*", QDir::Dirs | QDir::NoDotAndDotDot);

    return folders;
}

void CursorsBackend::getThemes()
{
    m_cursorsThemes.clear();

    // Idioma del sistema:

    QFile inputFile(QString(QDir::homePath() + "/.config/user-dirs.locale"));
    inputFile.open(QIODevice::ReadOnly);
    if (!inputFile.isOpen())
        return;

    QTextStream stream(&inputFile);
    QString line = stream.readLine();

    QString locale = line;
    QString shortLocale = locale.mid(0,2);

    // Obtener valor de estilo plasma seleccionado

    KConfig defaultThemesFile(QDir::homePath()+"/.config/kcminputrc");
    KConfigGroup cursors = defaultThemesFile.group("Mouse");
    QString selectedTheme = cursors.readEntry("cursorTheme", QString());

    QStringList folderlist1 = GetCursorsThemesFolderList(QDir::homePath()+"/.local/share/icons");
    QStringList folderlist2 = GetCursorsThemesFolderList("/usr/share/icons");

    // Leer la totalidad de iconos

    int j = 0;

    for (int i = 0; i < folderlist1.length(); i++) {

        QString indexTheme = QDir::homePath() + "/.local/share/icons/" + folderlist1[i] + "/" + "index.theme";
        QString cursorsFolder = QDir::homePath() + "/.local/share/icons/" + folderlist1[i] + "/" + "cursors";
        QDir dir;

        if (dir.exists(cursorsFolder)) {

            // Sólo cursores

            QVariantMap item;

            KConfig indexFile(indexTheme);
            KConfigGroup desktopEntry = indexFile.group("Icon Theme");

            item["name"] = desktopEntry.readEntry("Name", QString());
            item["folderName"] = folderlist1[i];
            item["path"] = QDir::homePath() + "/.local/share/icons";

            if (folderlist1[i] == selectedTheme) {
                item["selected"] = true;
                m_selectedTheme = j;
            }
            else {
                item["selected"] = false;
            }

            m_cursorsThemes.append(item);

            j++;
        }
    }

    for (int i = 0; i < folderlist2.length(); i++) {

        QString indexTheme = "/usr/share/icons/" + folderlist2[i] + "/" + "index.theme";
        QString cursorsFolder = "/usr/share/icons/" + folderlist2[i] + "/" + "cursors";
        QDir dir;

        if (dir.exists(cursorsFolder)) {

            // Sólo cursores

            QVariantMap item;

            KConfig indexFile(indexTheme);
            KConfigGroup desktopEntry = indexFile.group("Icon Theme");

            item["name"] = desktopEntry.readEntry("Name", QString());
            item["folderName"] = folderlist2[i];
            item["path"] = "/usr/share/icons";

            if (folderlist2[i] == selectedTheme) {
                item["selected"] = true;
                m_selectedTheme = j;
            }
            else {
                item["selected"] = false;
            }

            m_cursorsThemes.append(item);

            j++;
        }
    }

    m_themesCount = j;
}
