# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

add_executable(kirigamisettings
    main.cpp
    about.cpp
    app.cpp
    backend/colorschemesbackend.cpp
    backend/plasmastylebackend.cpp
    backend/wallpapersbackend.cpp
    backend/aboutsystembackend.cpp
    resources.qrc)

target_link_libraries(kirigamisettings
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::Svg
    KF5::I18n
    KF5::CoreAddons
    KF5::ConfigCore
    KF5::ConfigGui)

if (ANDROID)
    kirigami_package_breeze_icons(ICONS
        list-add
        help-about
        application-exit
        applications-graphics
    )
endif()

kconfig_add_kcfg_files(kirigamisettings GENERATE_MOC kirigamisettingsconfig.kcfgc)
install(TARGETS kirigamisettings ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
