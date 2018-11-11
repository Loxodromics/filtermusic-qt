QT += quick sql
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += sources/main.cpp \
    sources/data/radiostation.cpp \
    sources/commons/constants.cpp \
    sources/network/networkaccessmanager.cpp \
    sources/data/radiostationmanager.cpp \
    sources/data/radiogenre.cpp \
    sources/data/persistancemanager.cpp \
    sources/models/radiogenremodel.cpp \
    sources/models/radiostationmodel.cpp \
    sources/network/addresspinger.cpp

HEADERS += \
    sources/data/radiostation.h \
    sources/commons/constants.h \
    sources/network/networkaccessmanager.h \
    sources/data/radiostationmanager.h \
    sources/data/radiogenre.h \
    sources/data/persistancemanager.h \
    sources/models/radiogenremodel.h \
    sources/models/radiostationmodel.h \
    sources/network/addresspinger.h

include(thirdparty/LFDMobileAudioPlayer/LfdMobileAudioPlayer.pri)
include(thirdparty/qt-google-analytics/qt-google-analytics.pri)

RESOURCES += qml.qrc \
    icons.qrc

unix:mac {
    QMAKE_CXXFLAGS += -fobjc-arc
    QMAKE_INFO_PLIST = platforms/mac/Info.plist

    deployment.files += \
        resources/cacheddata.sq3
    deployment.path = Contents/Resources/res

    QMAKE_BUNDLE_DATA += deployment
} #unix:mac

ios {
    QMAKE_CXXFLAGS += -fobjc-arc
    QMAKE_INFO_PLIST = platforms/ios/Info.plist

    resourceFiles.files += resources/cacheddata.sq3
    resourceFiles.path = res
    QMAKE_BUNDLE_DATA += resourceFiles

} #ios


android {
    QT += androidextras

    QMAKE_CXXFLAGS += -g

    TARGET = $$ANDROID_TARGET_ARCH/filtermusicQt

    DISTFILES += \
        platforms/android/AndroidManifest.xml
#        ANDROID_PACKAGE_SOURCE_DIR = $$PWD/platforms/android

    include(thirdparty/android-openssl/android-openssl.pri)

    deployment.files += \
        resources/cacheddata.sq3

    deployment.path = /assets/res
    INSTALLS += deployment
    message("Androd Resources" $$deployment.files)

#    uploadCrashlytics.depends += all

    # Upload crashlytics symbols
    message($$OUT_PWD)
    uploadCrashlytics.commands += $$OUT_PWD/android-build/gradlew crashlyticsUploadSymbolsRelease
#    uploadCrashlytics.commands += && ping quatur.net

#    QMAKE_EXTRA_TARGETS += uploadCrashlytics
#    POST_TARGETDEPS += uploadCrashlytics

#    QMAKE_POST_LINK += $$uploadCrashlytics.commands #$$quote(ping quatur.net) # "heelo" $$ANDROID_PACKAGE_SOURCE_DIR/gradlew crashlyticsUploadSymbolsRelease)
#    message("QMAKE_POST_LINK: " $$QMAKE_POST_LINK)

} #android

DISTFILES += \
    resources/cacheddata.sq3 \
    thirdparty/LFDMobileAudioPlayer/android/AndroidManifest.xml \
    thirdparty/LFDMobileAudioPlayer/android/gradle/wrapper/gradle-wrapper.jar \
    thirdparty/LFDMobileAudioPlayer/android/gradlew \
    thirdparty/LFDMobileAudioPlayer/android/res/values/libs.xml \
    thirdparty/LFDMobileAudioPlayer/android/build.gradle \
    thirdparty/LFDMobileAudioPlayer/android/gradle/wrapper/gradle-wrapper.properties \
    thirdparty/LFDMobileAudioPlayer/android/gradlew.bat \
    settings.json
