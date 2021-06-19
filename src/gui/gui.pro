#-------------------------------------------------
#
# Project created by QtCreator 2013-04-18T21:48:11
#
#-------------------------------------------------

QT       += core gui webkit

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = gui
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    controller.cpp \
    pageview.cpp \
    scriptrunner.cpp

HEADERS  += mainwindow.h \
    controller.h \
    pageview.h \
    scriptrunner.h

FORMS    += mainwindow.ui \
    pageview.ui

OTHER_FILES +=
