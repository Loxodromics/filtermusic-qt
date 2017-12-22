//
//  constants.h
//  Filtermusic
//
//  Created by philipp on 12.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#ifndef FILTERMUSIC_CONSTANTS_H
#define FILTERMUSIC_CONSTANTS_H

#include <QObject>

namespace filtermusic {

class QmlConstants : public QObject
{
	Q_OBJECT
public:
	explicit QmlConstants(QObject* parent = nullptr);

};

#ifndef RELEASE_DEV
const QString		CLIENT_NAME						= QString("filtermusic Qt");
#else
const QString		CLIENT_NAME						= QString("filtermusic Qt Dev");
#endif
const unsigned long	VERSION_MAJOR					= 0;
const unsigned long	VERSION_MINOR					= 1;
const unsigned long	VERSION_PATCH					= 0;
const QString		CLIENT_DESIGNATION				= CLIENT_NAME + " " + QString::number(VERSION_MAJOR) + "." + QString::number(VERSION_MINOR) + "." + QString::number(VERSION_PATCH);
const unsigned long	API_VERSION						= 1;
const unsigned long LOCAL_DB_VERSION_NUMBER			= 1;

/// Networking
const QByteArray	HEADER_API_VERSION				= QByteArray("api_version");
const QByteArray	HEADER_CUSTOM_USER_AGENT		= QByteArray("X-Custom-User-Agent");
const QByteArray	HEADER_USER_AGENT				= QByteArray("User-Agent");
const QString		URL_STATIONS_FEED				= QString("https://filtermusic.net/json_radios");
const QString		URL_GENRES_FEED					= QString("https://filtermusic.net/json_categories");
const QString		URL_SETTINGS					= QString("http://www.quatur.net/~philipp/filtermusic/settings.json");
const qint32		PING_WAIT_TIME					= 5000;

/// JSON parsing
const QString		GENRE_KEY_ID					= QString("id");
const QString		GENRE_KEY_NAME					= QString("name");
const QString		GENRE_KEY_POSITION				= QString("position");
const QString		STATION_KEY_DESCRIPTION			= QString("description");
const QString		STATION_KEY_GENRE				= QString("category");
const QString		STATION_KEY_ID					= QString("id");
const QString		STATION_KEY_LOGO				= QString("logo");
const QString		STATION_KEY_LOGO_ALT			= QString("alt");
const QString		STATION_KEY_LOGO_SRC			= QString("src");
const QString		STATION_KEY_NAME				= QString("name");
const QString		STATION_KEY_POSTION				= QString("position");
const QString		STATION_KEY_RADIO				= QString("radio");
const QString		STATION_KEY_TYPE				= QString("type");
const QString		STATION_KEY_URL					= QString("server");

/// Settings
const QString		SETTINGS_KEY_VERSION				= QString("version");
const QString		SETTINGS_VALUE_VERSION				= QString("0.1");
const QString		SETTINGS_KEY_ACTIVE					= QString("active");
const QString		SETTINGS_VALUE_ACTIVE				= QString("active");
const QString		SETTINGS_KEY_MAINTENANCE			= QString("maintenance");
const QString		SETTINGS_VALUE_MAINTENANCE			= QString("maintenance");
const QString		SETTINGS_KEY_URLS					= QString("urls");
const QString		SETTINGS_KEY_URLS_STATIONS_FEED		= QString("urls/stations_feed");
const QString		SETTINGS_VALUE_URLS_STATIONS_FEED	= QString("https://filtermusic.net/json_radios");
const QString		SETTINGS_KEY_URLS_CATEGORIES_FEED	= QString("urls/categories_feed");
const QString		SETTINGS_VALUE_URLS_CATEGORIES_FEED	= QString("https://filtermusic.net/json_categories");
const QString		SETTINGS_KEY_STRINGS				= QString("strings");

const QString		DATABASE_FILENAME				= QString("cacheddata.sq3");

const qint32		QUERY_TIME_REACHABILITY			= 1800;

} /// namespace filtermusic

#endif /// FILTERMUSIC_CONSTANTS_H
