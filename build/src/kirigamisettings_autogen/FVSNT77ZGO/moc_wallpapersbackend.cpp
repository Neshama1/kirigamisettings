/****************************************************************************
** Meta object code from reading C++ file 'wallpapersbackend.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.8)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../../src/backend/wallpapersbackend.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'wallpapersbackend.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.8. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_WallpapersBackend_t {
    QByteArrayData data[13];
    char stringdata0[202];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_WallpapersBackend_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_WallpapersBackend_t qt_meta_stringdata_WallpapersBackend = {
    {
QT_MOC_LITERAL(0, 0, 17), // "WallpapersBackend"
QT_MOC_LITERAL(1, 18, 24), // "selectedWallpaperChanged"
QT_MOC_LITERAL(2, 43, 0), // ""
QT_MOC_LITERAL(3, 44, 22), // "selectedWallpaperIndex"
QT_MOC_LITERAL(4, 67, 17), // "filesCountChanged"
QT_MOC_LITERAL(5, 85, 10), // "filesCount"
QT_MOC_LITERAL(6, 96, 17), // "wallpapersChanged"
QT_MOC_LITERAL(7, 114, 10), // "wallpapers"
QT_MOC_LITERAL(8, 125, 20), // "setSelectedWallpaper"
QT_MOC_LITERAL(9, 146, 13), // "setFilesCount"
QT_MOC_LITERAL(10, 160, 13), // "setWallpapers"
QT_MOC_LITERAL(11, 174, 9), // "getThemes"
QT_MOC_LITERAL(12, 184, 17) // "selectedWallpaper"

    },
    "WallpapersBackend\0selectedWallpaperChanged\0"
    "\0selectedWallpaperIndex\0filesCountChanged\0"
    "filesCount\0wallpapersChanged\0wallpapers\0"
    "setSelectedWallpaper\0setFilesCount\0"
    "setWallpapers\0getThemes\0selectedWallpaper"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_WallpapersBackend[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       3,   68, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   49,    2, 0x06 /* Public */,
       4,    1,   52,    2, 0x06 /* Public */,
       6,    1,   55,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       8,    1,   58,    2, 0x0a /* Public */,
       9,    1,   61,    2, 0x0a /* Public */,
      10,    1,   64,    2, 0x0a /* Public */,

 // methods: name, argc, parameters, tag, flags
      11,    0,   67,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::Int,    5,
    QMetaType::Void, QMetaType::QVariantList,    7,

 // slots: parameters
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::Int,    5,
    QMetaType::Void, QMetaType::QVariantList,    7,

 // methods: parameters
    QMetaType::Void,

 // properties: name, type, flags
      12, QMetaType::Int, 0x00495103,
       5, QMetaType::Int, 0x00495103,
       7, QMetaType::QVariantList, 0x00495103,

 // properties: notify_signal_id
       0,
       1,
       2,

       0        // eod
};

void WallpapersBackend::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<WallpapersBackend *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->selectedWallpaperChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: _t->filesCountChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 2: _t->wallpapersChanged((*reinterpret_cast< QVariantList(*)>(_a[1]))); break;
        case 3: _t->setSelectedWallpaper((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 4: _t->setFilesCount((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 5: _t->setWallpapers((*reinterpret_cast< QVariantList(*)>(_a[1]))); break;
        case 6: _t->getThemes(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (WallpapersBackend::*)(int );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&WallpapersBackend::selectedWallpaperChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (WallpapersBackend::*)(int );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&WallpapersBackend::filesCountChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (WallpapersBackend::*)(QVariantList );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&WallpapersBackend::wallpapersChanged)) {
                *result = 2;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<WallpapersBackend *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< int*>(_v) = _t->selectedWallpaper(); break;
        case 1: *reinterpret_cast< int*>(_v) = _t->filesCount(); break;
        case 2: *reinterpret_cast< QVariantList*>(_v) = _t->wallpapers(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<WallpapersBackend *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setSelectedWallpaper(*reinterpret_cast< int*>(_v)); break;
        case 1: _t->setFilesCount(*reinterpret_cast< int*>(_v)); break;
        case 2: _t->setWallpapers(*reinterpret_cast< QVariantList*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject WallpapersBackend::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_WallpapersBackend.data,
    qt_meta_data_WallpapersBackend,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *WallpapersBackend::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *WallpapersBackend::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_WallpapersBackend.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int WallpapersBackend::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 7;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 3;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void WallpapersBackend::selectedWallpaperChanged(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void WallpapersBackend::filesCountChanged(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void WallpapersBackend::wallpapersChanged(QVariantList _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
