// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2022 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "backend/colorschemesbackend.h"

ColorSchemesBackend::ColorSchemesBackend()
{
    // Obtener valor de esquema seleccionado
    KConfig defaultThemesFile(QDir::homePath()+"/.config/kdeglobals");
    KConfigGroup general = defaultThemesFile.group("General");
    QString selectedScheme = general.readEntry("ColorScheme", QString());

    m_selectedScheme = selectedScheme;
    qDebug() << "Selected Scheme: " << selectedScheme;

    // Obtener cuenta de esquemas de color
    QStringList filelist1 = GetColorSchemesFileList(QDir::homePath()+"/.local/share/color-schemes");
    QStringList filelist2 = GetColorSchemesFileList("/usr/share/color-schemes");
    int count = filelist1.length() + filelist2.length();

    m_filesCount = count;
    qDebug() << "Schemes number: " << count;

    // Leer la totalidad de esquemas de color
    for (int i = 0; i < filelist1.length(); i++) {

        QVariantMap item;

        item["fileName"] = filelist1[i];
        item["path"] = QDir::homePath() + "/.local/share/color-schemes";
        item["selected"] = filelist1[i].contains(m_selectedScheme);

        KConfig colorScheme(QDir::homePath() + "/.local/share/color-schemes/" + filelist1[i]);

        KConfigGroup general = colorScheme.group("General");
        item["name"] = general.readEntry("Name", QString());

        KConfigGroup WM = colorScheme.group("WM");
        item["titleBarColor"] = WM.readEntry("activeBackground", QColor(Qt::white)).name();

        KConfigGroup ColorsWindow = colorScheme.group("Colors:Window");
        item["windowColor"] = ColorsWindow.readEntry("BackgroundNormal", QColor(Qt::white)).name();

        KConfigGroup ColorsView = colorScheme.group("Colors:View");
        item["selectionColor"] = ColorsView.readEntry("DecorationFocus", QColor(Qt::white)).name();

        m_colorSchemes.append(item);
    }

    for (int i = 0; i < filelist2.length(); i++) {

        QVariantMap item;

        item["fileName"] = filelist2[i];
        item["path"] = "/usr/share/color-schemes";
        item["selected"] = filelist2[i].contains(m_selectedScheme);

        KConfig colorScheme("/usr/share/color-schemes/" + filelist2[i]);

        KConfigGroup general = colorScheme.group("General");
        item["name"] = general.readEntry("Name", QString());

        KConfigGroup WM = colorScheme.group("WM");
        item["titleBarColor"] = WM.readEntry("activeBackground", QColor(Qt::white)).name();

        KConfigGroup ColorsWindow = colorScheme.group("Colors:Window");
        item["windowColor"] = ColorsWindow.readEntry("BackgroundNormal", QColor(Qt::white)).name();

        KConfigGroup ColorsView = colorScheme.group("Colors:View");
        item["selectionColor"] = ColorsView.readEntry("DecorationFocus", QColor(Qt::white)).name();

        m_colorSchemes.append(item);
    }
}

ColorSchemesBackend::~ColorSchemesBackend()
{

}

QVariantList ColorSchemesBackend::colorSchemes() const
{
    return m_colorSchemes;
}

void ColorSchemesBackend::setColorSchemes(QVariantList colorSchemes)
{
    if (m_colorSchemes == colorSchemes) {
        return;
    }

    m_colorSchemes = colorSchemes;
    emit colorSchemesChanged(m_colorSchemes);
}

QStringList ColorSchemesBackend::GetColorSchemesFileList(QString path) const
{
    QDir directory = QDir(path);
    QStringList files = directory.entryList(QStringList() << "*.colors", QDir::Files);

    return files;
}

int ColorSchemesBackend::filesCount() const
{
    return m_filesCount;
}

void ColorSchemesBackend::setFilesCount(int filesCount)
{
    if (m_filesCount == filesCount) {
        return;
    }

    m_filesCount = filesCount;
    emit filesCountChanged(m_filesCount);
}

QString ColorSchemesBackend::selectedScheme() const
{
    return m_selectedScheme;
}

void ColorSchemesBackend::setSelectedScheme(const QString& selectedScheme)
{
    if (m_selectedScheme == selectedScheme) {
        return;
    }

    QString& file = const_cast<QString&>(selectedScheme);
    QString cleanName = file.replace(".colors","",Qt::CaseInsensitive);

    QProcess *blendEffectProcess = new QProcess(this->parent());
    QStringList blendEffectArguments;
    blendEffectArguments << "call" << "--session" << "--dest=org.kde.KWin" << "--object-path=/org/kde/KWin/BlendChanges" << "--method=org.kde.KWin.BlendChanges.start" << "300";
    blendEffectProcess->execute("gdbus",blendEffectArguments);

    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << cleanName;
    process->execute("plasma-apply-colorscheme",arguments);

    m_selectedScheme = selectedScheme;
    emit selectedSchemeChanged(m_selectedScheme);
}
