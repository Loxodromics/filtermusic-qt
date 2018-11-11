//
//  main.cpp
//  Filtermusic
//
//  Created by philipp on 09.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "sources/commons/constants.h"
#include "sources/data/persistancemanager.h"
#include "sources/data/radiostation.h"
#include "sources/data/radiostationmanager.h"
#include "sources/models/radiogenremodel.h"
#include "sources/models/radiostationmodel.h"
#include "sources/network/networkaccessmanager.h"
#include "thirdparty/LFDMobileAudioPlayer/src/lfdaudioplayer.h"
#include "thirdparty/LFDMobileAudioPlayer/src/genericQt/genericqtaudioplayer.h"
#include "thirdparty/qt-google-analytics/ganalytics.h"

#ifdef Q_OS_IOS
#include "thirdparty/LFDMobileAudioPlayer/src/ios/iosaudioplayer.h"
#endif /// Q_OS_IOS

#ifdef Q_OS_ANDROID
#include <jni.h>
#include "thirdparty/LFDMobileAudioPlayer/src/android/androidaudioplayer.h"
LFD::AndroidAudioPlayer* audioPlayer = nullptr;
#endif

#ifdef Q_OS_ANDROID




void setFocus(JNIEnv */*env*/, jobject /*obj*/, jint n)
{
	qDebug() << "setFocus" << n;
	if ( audioPlayer != nullptr)
		audioPlayer->setFocus(n);
}

void setTitle(JNIEnv* env, jobject, jstring title)
{
	const char* nativeString = env->GetStringUTFChars(title, 0);

	qDebug() << "setTitle:" << QString(nativeString);
	if ( audioPlayer != nullptr)
		audioPlayer->setTitle( QString(nativeString) );
}

static JNINativeMethod methods[] = {
	{ "sendSetFocus", // const char* function name;
		"(I)V", // const char* function signature
		(void *)setFocus // function pointer
	},
	{ "sendSetTitle", // const char* function name;
		"(Ljava/lang/String;)V", // const char* function signature
		(void *)setTitle // function pointer
	}
};

// this method is called automatically by Java VM
// after the .so file is loaded
JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* /*reserved*/)
{
	JNIEnv* env;
	// get the JNIEnv pointer.
	if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6)
		   != JNI_OK) {
		return JNI_ERR;
	}

	// step 3
	// search for Java class which declares the native methods
	jclass javaClass = env->FindClass("net/quatur/QAndroidResultReceiver/jniExport/jniExport");
	if (!javaClass)
		return JNI_ERR;

	// step 4
	// register our native methods
	if (env->RegisterNatives(javaClass, methods,
							sizeof(methods) / sizeof(methods[0])) < 0) {
		return JNI_ERR;
	}
	return JNI_VERSION_1_6;
}



JNIEXPORT jint JNICALL Java_net_quatur_QAndroidResultReceiver_jniExport_jniExport_intMethod(JNIEnv*, jobject, jint focusChange)
{
	/// TODO
//	static int lastfocus = 0;
//	rootObject->setProperty("command", focusChange);
	qDebug() << "yyy_Java_net_quatur_QAndroidResultReceiver_jniExport_jniExport_intMethod " << focusChange;
	audioPlayer->setFocus(focusChange);

	return 1;
}

JNIEXPORT jint JNICALL Java_net_quatur_QAndroidResultReceiver_jniExport_jniExport_titleReporter(JNIEnv* env, jobject, jstring title)
{
	const char* nativeString = env->GetStringUTFChars(title, 0);

//	qDebug() << "ccc_title:" << QString(nativeString);
	audioPlayer->setTitle( QString(nativeString) );

	return 1;
}

#endif ///Q_OS_ANDROID

QString determineResourcePath(QQmlApplicationEngine* engine)
{
	/// set resource path for all OSes
	QString resourcePath;
#ifdef Q_OS_MAC
	resourcePath = qApp->applicationDirPath() + "/../Resources/res/";
	engine->rootContext()->setContextProperty("resourcePath", "file://" + resourcePath);
//	qmlPath.append("/../Resources/");
#endif

#ifdef Q_OS_IOS
	resourcePath = qApp->applicationDirPath() + "/";
	engine->rootContext()->setContextProperty("resourcePath", "file://" + resourcePath);
#endif

#ifdef Q_OS_WIN32
	resourcePath = qApp->applicationDirPath() + "/";
	engine->rootContext()->setContextProperty("resourcePath", resourcePath);
#endif

#ifdef Q_OS_ANDROID
	resourcePath = "assets:/res/";
	engine->rootContext()->setContextProperty("resourcePath", resourcePath);
//	qmlPath = QStringLiteral("assets:");
#endif

#ifdef Q_OS_WINRT
	resourcePath = qApp->applicationDirPath() + "/resources/";
	engine->rootContext()->setContextProperty("resourcePath", "file:///" + resourcePath);
	engine->rootContext()->setContextProperty("resourcePathWin", qApp->applicationDirPath() + "/resources/");
#endif
	return resourcePath;
}


int main(int argc, char *argv[])
{
	QCoreApplication::setOrganizationName("filtermusic.net");
	QCoreApplication::setOrganizationDomain("net.filtermusic");
	QCoreApplication::setApplicationName(filtermusic::CLIENT_NAME);
	QCoreApplication::setApplicationVersion(QString::number(filtermusic::VERSION_MAJOR) + "." +
											QString::number(filtermusic::VERSION_MINOR) + "." +
											QString::number(filtermusic::VERSION_PATCH));
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	QGuiApplication app(argc, argv);
	QQmlApplicationEngine engine;

	/// init random seed
	QTime time = QTime::currentTime();
	qsrand((uint)time.msec());

	GAnalytics tracker(filtermusic::GOOGLE_ANALYTICS_ID);
	tracker.startSession();

	/// for Android back button
	bool isAndroid = false;

	filtermusic::PersistanceManager::getInstance().setResourcePath( determineResourcePath( &engine ) );
	filtermusic::PersistanceManager::getInstance().loadLocalSettings();
	filtermusic::NetworkAccessManager::getInstance().fetchSettings();

	engine.rootContext()->setContextProperty( QStringLiteral("NetworkAccessManager"),
											  filtermusic::NetworkAccessManager::instancePointer() );

	engine.rootContext()->setContextProperty( QStringLiteral("RadioStationManager"),
											  &filtermusic::RadioStationManager::getInstance() );

	engine.rootContext()->setContextProperty( QStringLiteral("PersistanceManager"),
											  &filtermusic::PersistanceManager::getInstance() );

	engine.rootContext()->setContextProperty( QStringLiteral("GTracker"),
											  &tracker );

	engine.rootContext()->setContextProperty(QStringLiteral("Constants"),
											 new filtermusic::QmlConstants(&app));

	filtermusic::RadioGenreModel radioGenreModel;
	engine.rootContext()->setContextProperty(QStringLiteral("radioGenreModel"),
											 &radioGenreModel);
	QObject::connect( &filtermusic::PersistanceManager::getInstance(), SIGNAL(categoriesChanged()),
					  &radioGenreModel, SLOT(update()) );
//	QObject::connect( &filtermusic::RadioStationManager::getInstance(), SIGNAL(radioStationsChanged()),
//					  &radioGenreModel, SLOT(update()) );

	filtermusic::RadioStationModel radioStationModel;
	radioStationModel.setType(filtermusic::RadioStationModel::CategoryType);
	engine.rootContext()->setContextProperty(QStringLiteral("radioStationModel"),
											 &radioStationModel);
	QObject::connect( &filtermusic::PersistanceManager::getInstance(), SIGNAL(radioStationsChanged()),
					  &radioStationModel, SLOT(update()) );
	QObject::connect( &filtermusic::RadioStationManager::getInstance(), SIGNAL(radioStationsChanged()),
					  &radioStationModel, SLOT(update()) );
	QObject::connect( &filtermusic::NetworkAccessManager::getInstance(), SIGNAL(urlReached(QString,bool)),
					  &radioStationModel, SLOT(deferredUpdate()) );

	filtermusic::RadioStationModel favoritesStationModel;
	favoritesStationModel.setType(filtermusic::RadioStationModel::FavoritesType);
	engine.rootContext()->setContextProperty(QStringLiteral("favoritesStationModel"),
											 &favoritesStationModel);
	QObject::connect( &filtermusic::PersistanceManager::getInstance(), SIGNAL(radioStationsChanged()),
					  &favoritesStationModel, SLOT(update()) );
	QObject::connect( &filtermusic::RadioStationManager::getInstance(), SIGNAL(radioStationsChanged()),
					  &favoritesStationModel, SLOT(update()) );
	QObject::connect( &filtermusic::RadioStationManager::getInstance(), SIGNAL(likedChanged(bool)),
					  &favoritesStationModel, SLOT(update()) );

	filtermusic::RadioStationModel recentStationModel;
	recentStationModel.setType(filtermusic::RadioStationModel::RecentType);
	engine.rootContext()->setContextProperty(QStringLiteral("recentStationModel"),
											 &recentStationModel);
	QObject::connect( &filtermusic::PersistanceManager::getInstance(), SIGNAL(radioStationsChanged()),
					  &recentStationModel, SLOT(update()) );
	QObject::connect( &filtermusic::RadioStationManager::getInstance(), SIGNAL(radioStationsChanged()),
					  &recentStationModel, SLOT(update()) );

#ifdef Q_OS_IOS
	LFD::IosAudioPlayer audioPlayer;
	QObject::connect( &filtermusic::RadioStationManager::getInstance(), SIGNAL(currentAudioMediaChanged(LFD::AudioMedia*) ),
					  &audioPlayer, SLOT(setMedia(LFD::AudioMedia*)) );
	QObject::connect( &audioPlayer, SIGNAL(playingChanged(bool)),
					  &filtermusic::RadioStationManager::getInstance(), SLOT(startedPlayingStation()) );
	QObject::connect( &audioPlayer, SIGNAL(playingChanged(bool)),
					  &filtermusic::RadioStationManager::getInstance(), SLOT(startedPlayingStation()) );
	engine.rootContext()->setContextProperty("AudioPlayer", &audioPlayer);
//	audioPlayer.setMedia(filtermusic::RadioStationManager::getInstance().currentAudioMedia());
#endif

#ifdef Q_OS_ANDROID
	audioPlayer = new LFD::AndroidAudioPlayer();
	QObject::connect( &filtermusic::RadioStationManager::getInstance(), SIGNAL(currentAudioMediaChanged(LFD::AudioMedia*) ),
					  audioPlayer, SLOT(setMedia(LFD::AudioMedia*)) ); ///FIXME: seems not to work
	QObject::connect( audioPlayer, SIGNAL(playingChanged(bool)),
					  &filtermusic::RadioStationManager::getInstance(), SLOT(startedPlayingStation()) );
	QObject::connect( audioPlayer, SIGNAL(playingChanged(bool)),
					  &filtermusic::RadioStationManager::getInstance(), SLOT(startedPlayingStation()) );
	QObject::connect( audioPlayer, SIGNAL(playingChanged(bool)),
					  &filtermusic::PersistanceManager::getInstance(), SLOT(saveToLocalDb()) );
	engine.rootContext()->setContextProperty("AudioPlayer", audioPlayer);

	isAndroid = true;

#endif ///Q_OS_ANDROID

#ifdef Q_OS_MACOS
    LFD::GenericQtAudioPlayer audioPlayer;
	QObject::connect( &filtermusic::RadioStationManager::getInstance(), SIGNAL(currentAudioMediaChanged(LFD::AudioMedia*) ),
					  &audioPlayer, SLOT(setMedia(LFD::AudioMedia*)) );
	QObject::connect( &audioPlayer, SIGNAL(playingChanged(bool)),
					  &filtermusic::RadioStationManager::getInstance(), SLOT(startedPlayingStation()) );
	QObject::connect( &audioPlayer, SIGNAL(playingChanged(bool)),
					  &filtermusic::RadioStationManager::getInstance(), SLOT(startedPlayingStation()) );
	engine.rootContext()->setContextProperty("AudioPlayer", &audioPlayer);
//	audioPlayer.setMedia(filtermusic::RadioStationManager::getInstance().currentAudioMedia());
#endif

	QObject::connect ( &app, SIGNAL(aboutToQuit()),
					   &filtermusic::PersistanceManager::getInstance(), SLOT(saveToLocalDb()) );

	engine.rootContext()->setContextProperty("isAndroid", isAndroid);

	/// local database
	if (!QSqlDatabase::drivers().contains("QSQLITE"))
	{
		qDebug() << "Unable to load database! This program needs the SQLITE driver";
	}
	filtermusic::PersistanceManager::getInstance().initFromLocalDb();
	filtermusic::NetworkAccessManager::instancePointer()->fetchAll();

	qmlRegisterType<LFD::AudioPlayer>("Lfd", 0, 1, "LfdAudioPlayer");
	qRegisterMetaType<LFD::AudioPlayer::PlayingState>("PlayingState");

	engine.load(QUrl(QLatin1String("qrc:/sources/qml/main.qml")));
	if (engine.rootObjects().isEmpty())
		return -1;

	return app.exec();
}
