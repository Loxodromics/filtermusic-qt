//
//  networkaccessmanager.cpp
//  Filtermusic
//
//  Created by philipp on 13.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrlQuery>
#include "networkaccessmanager.h"
#include "addresspinger.h"
#include "sources/commons/constants.h"
#include "sources/data/radiostationmanager.h"
#include "sources/data/persistancemanager.h"

namespace filtermusic {

NetworkAccessManager::NetworkAccessManager(QObject* parent)
	: QNetworkAccessManager(parent)
{

}

NetworkAccessManager* NetworkAccessManager::instancePointer()
{
	return &NetworkAccessManager::getInstance();
}

void NetworkAccessManager::fetchAll()
{
	this->fetchRadioGenres();
	this->fetchRadioStation();
}

QNetworkRequest NetworkAccessManager::getRequest()
{

	QNetworkRequest request;
	request.setRawHeader(HEADER_USER_AGENT, CLIENT_DESIGNATION.toUtf8());
	request.setRawHeader(HEADER_CUSTOM_USER_AGENT, CLIENT_DESIGNATION.toUtf8());
	request.setRawHeader(HEADER_API_VERSION, QString::number(API_VERSION).toUtf8());
	request.setRawHeader(HEADER_SETTINGS_VERSION, SETTINGS_VERSION.toUtf8());

	return request;
}

void NetworkAccessManager::fetchSettings()
{
	qDebug() << "NetworkAccessManager::fetchSettings";

	QNetworkRequest request = this->getRequest();

	QUrl url = URL_SETTINGS;
	QUrlQuery* urlQuery = new QUrlQuery(url);
	url.setQuery(*urlQuery);
	request.setUrl(url);
	QNetworkReply* reply = this->get(request);

	connect( reply, SIGNAL(finished()),
			 this, SLOT(handleFetchSettings()) );
}

void NetworkAccessManager::fetchRadioStation()
{
	qDebug() << "NetworkAccessManager::fetchRadioStation";

	QNetworkRequest request = this->getRequest();

	const QString urlString = PersistanceManager::getInstance().getSetting( SETTINGS_KEY_URLS + QStringLiteral("/") + SETTINGS_KEY_URLS_STATIONS_FEED,
																			SETTINGS_VALUE_URLS_STATIONS_FEED );

	QUrl url(urlString);
	QUrlQuery* urlQuery = new QUrlQuery(url);
	url.setQuery(*urlQuery);
	request.setUrl(url);
	QNetworkReply* reply = this->get(request);

	connect( reply, SIGNAL(finished()),
			 this, SLOT(handleFetchRadioStation()) );
}

void NetworkAccessManager::fetchRadioGenres()
{
	qDebug() << "NetworkAccessManager::fetchRadioGenres";

	QNetworkRequest request = this->getRequest();

	const QString urlString = PersistanceManager::getInstance().getSetting( SETTINGS_KEY_URLS + QStringLiteral("/") + SETTINGS_KEY_URLS_CATEGORIES_FEED,
																			SETTINGS_VALUE_URLS_CATEGORIES_FEED );

	QUrl url(urlString);
	QUrlQuery* urlQuery = new QUrlQuery(url);
	url.setQuery(*urlQuery);
	request.setUrl(url);
	QNetworkReply* reply = this->get(request);

	connect( reply, SIGNAL(finished()),
			 this, SLOT(handleFetchRadioGenres()) );
}

void NetworkAccessManager::handleFetchRadioStation()
{
	QNetworkReply* reply = (QNetworkReply*)sender();

	disconnect( reply, SIGNAL(finished()),
				this, SLOT(handleFetchRadioStation()) );

	if ( reply->error() == QNetworkReply::NoError )
	{
		QString replyString = QString(reply->readAll() );

		qDebug() << "handleFetchRadioStation: success:\n"; //<< replyString;

		QJsonParseError* error = new QJsonParseError();
		QJsonDocument jsonDocument = QJsonDocument::fromJson(replyString.toUtf8(), error);

		if ( error->error != QJsonParseError::NoError )
		{
			qDebug() << "QJsonParseError error in handleFetchRadioStation: " << error->errorString();
		}

		if ( jsonDocument.isArray() )
		{
			QJsonArray stationJson = jsonDocument.array();
			RadioStationManager::getInstance().parseRadioStationsJson(stationJson);
		}
		else
		{
			qDebug() << "handleFetchRadioStation: failed";
		}
	}
	else
	{
		qDebug() << "handleFetchRadioStation: failed";
		qDebug() << "handleFetchRadioStation error: " << reply->errorString();
		qDebug() << "handleFetchRadioStation error message: " << reply->readAll();
	}

//	RadioStationManager::getInstance().printStations();
	PersistanceManager::getInstance().signalStationsChanged();
	PersistanceManager::getInstance().saveToLocalDb();

	reply->deleteLater();
}

void NetworkAccessManager::handleFetchRadioGenres()
{
	QNetworkReply* reply = (QNetworkReply*)sender();

	disconnect( reply, SIGNAL(finished()),
				this, SLOT(handleFetchRadioGenres()) );

	if ( reply->error() == QNetworkReply::NoError )
	{
		QString replyString = QString(reply->readAll() );

		qDebug() << "handleFetchRadioGenres: success:\n";// << replyString;

		QJsonParseError* error = new QJsonParseError();
		QJsonDocument jsonDocument = QJsonDocument::fromJson(replyString.toUtf8(), error);

		if ( error->error != QJsonParseError::NoError )
		{
			qDebug() << "QJsonParseError error in handleFetchRadioGenres: " << error->errorString();
		}

		if ( jsonDocument.isArray() )
		{
			QJsonArray radioGenresJson = jsonDocument.array();
			RadioStationManager::getInstance().parseRadioGenresJson(radioGenresJson);
		}
		else
		{
			qDebug() << "handleFetchRadioGenres: failed";
		}
	}
	else
	{
		qDebug() << "handleFetchRadioGenres: failed";
		qDebug() << "handleFetchRadioGenres error: " << reply->errorString();
		qDebug() << "handleFetchRadioGenres error message: " << reply->readAll();
	}

	PersistanceManager::getInstance().signalCategoriesChanged();

	reply->deleteLater();
}

void NetworkAccessManager::pingUrl( const QString urlString )
{
//	qDebug() << "NetworkAccessManager::pingUrl";
	AddressPinger* addressPinger = new AddressPinger( QUrl(urlString) );

//	connect( addressPinger, SIGNAL(addressReached(QString, bool)),
//			 this, SLOT(handleAddressPinger(QString, bool)) );
	connect( addressPinger, SIGNAL(finished()),
			 this, SLOT(handleAddressPinger()) );

	addressPinger->start(QThread::LowPriority);

}

void NetworkAccessManager::handleFetchSettings()
{
	QNetworkReply* reply = (QNetworkReply*)sender();

	disconnect( reply, SIGNAL(finished()),
				this, SLOT(handleFetchSettings()) );

	if ( reply->error() == QNetworkReply::NoError )
	{
		QString replyString = QString(reply->readAll() );

		qDebug() << "handleFetchSettings: success:\n";// << replyString;

		QJsonParseError* error = new QJsonParseError();
		QJsonDocument jsonDocument = QJsonDocument::fromJson(replyString.toUtf8(), error);

		if ( error->error != QJsonParseError::NoError )
		{
			qDebug() << "QJsonParseError error in handleFetchSettings: " << error->errorString();
		}

		PersistanceManager::getInstance().parseSettings(jsonDocument);
	}
	else
	{
		qDebug() << "handleFetchSettings: failed";
		qDebug() << "handleFetchSettings error: " << reply->errorString();
		qDebug() << "handleFetchSettings error message: " << reply->readAll();
	}

	PersistanceManager::getInstance().signalCategoriesChanged();

	reply->deleteLater();
}

void NetworkAccessManager::handleAddressPinger_old(QString urlString, bool reached)
{
//	never called
	AddressPinger* addressPinger = (AddressPinger*)sender();

	if ( !reached )
		emit urlReached(urlString, reached);

	emit urlReached(urlString, false);

	addressPinger->deleteLater();
}

void NetworkAccessManager::handleAddressPinger()
{
	AddressPinger* addressPinger = (AddressPinger*)sender();
//	qDebug() << "handleAddressPinger" << addressPinger->didConnect();

	RadioStationManager::getInstance().stationReachable( addressPinger->url().toString(), addressPinger->didConnect() );
	emit urlReached( addressPinger->url().toString(), addressPinger->didConnect() );

	addressPinger->deleteLater();
}

} /// namespace filtermusic
