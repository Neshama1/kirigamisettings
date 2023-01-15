/****************************************************************************
** Meta object code from reading C++ file 'aboutsystembackend.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.8)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../../src/backend/aboutsystembackend.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'aboutsystembackend.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.8. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_AboutSystemBackend_t {
    QByteArrayData data[11];
    char stringdata0[132];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_AboutSystemBackend_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_AboutSystemBackend_t qt_meta_stringdata_AboutSystemBackend = {
    {
QT_MOC_LITERAL(0, 0, 18), // "AboutSystemBackend"
QT_MOC_LITERAL(1, 19, 7), // "version"
QT_MOC_LITERAL(2, 27, 6), // "osName"
QT_MOC_LITERAL(3, 34, 12), // "architecture"
QT_MOC_LITERAL(4, 47, 13), // "kernelVersion"
QT_MOC_LITERAL(5, 61, 8), // "hostname"
QT_MOC_LITERAL(6, 70, 8), // "userName"
QT_MOC_LITERAL(7, 79, 10), // "memorySize"
QT_MOC_LITERAL(8, 90, 17), // "prettyProductName"
QT_MOC_LITERAL(9, 108, 15), // "internalStorage"
QT_MOC_LITERAL(10, 124, 7) // "cpuInfo"

    },
    "AboutSystemBackend\0version\0osName\0"
    "architecture\0kernelVersion\0hostname\0"
    "userName\0memorySize\0prettyProductName\0"
    "internalStorage\0cpuInfo"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_AboutSystemBackend[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
      10,   14, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // properties: name, type, flags
       1, QMetaType::QString, 0x00095401,
       2, QMetaType::QString, 0x00095401,
       3, QMetaType::QString, 0x00095401,
       4, QMetaType::QString, 0x00095401,
       5, QMetaType::QString, 0x00095401,
       6, QMetaType::QString, 0x00095401,
       7, QMetaType::QString, 0x00095401,
       8, QMetaType::QString, 0x00095401,
       9, QMetaType::QString, 0x00095401,
      10, QMetaType::QString, 0x00095401,

       0        // eod
};

void AboutSystemBackend::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{

#ifndef QT_NO_PROPERTIES
    if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<AboutSystemBackend *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->version(); break;
        case 1: *reinterpret_cast< QString*>(_v) = _t->osName(); break;
        case 2: *reinterpret_cast< QString*>(_v) = _t->architecture(); break;
        case 3: *reinterpret_cast< QString*>(_v) = _t->kernelVersion(); break;
        case 4: *reinterpret_cast< QString*>(_v) = _t->hostname(); break;
        case 5: *reinterpret_cast< QString*>(_v) = _t->userName(); break;
        case 6: *reinterpret_cast< QString*>(_v) = _t->memorySize(); break;
        case 7: *reinterpret_cast< QString*>(_v) = _t->prettyProductName(); break;
        case 8: *reinterpret_cast< QString*>(_v) = _t->internalStorage(); break;
        case 9: *reinterpret_cast< QString*>(_v) = _t->cpuInfo(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
    (void)_o;
    (void)_id;
    (void)_c;
    (void)_a;
}

QT_INIT_METAOBJECT const QMetaObject AboutSystemBackend::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_AboutSystemBackend.data,
    qt_meta_data_AboutSystemBackend,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *AboutSystemBackend::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *AboutSystemBackend::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_AboutSystemBackend.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int AboutSystemBackend::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    
#ifndef QT_NO_PROPERTIES
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 10;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 10;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
