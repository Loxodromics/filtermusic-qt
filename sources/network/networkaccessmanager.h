//
//  networkaccessmanager.h
//  Filtermusic
//
//  Created by philipp on 13.10.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#ifndef FILTERMUSIC_NETWORKACCESSMANAGER_H
#define FILTERMUSIC_NETWORKACCESSMANAGER_H

#include <QNetworkAccessManager>
#include <QNetworkReply>

namespace filtermusic {

class NetworkAccessManager : public QNetworkAccessManager
{
	Q_OBJECT

public:
	static NetworkAccessManager& getInstance()
	{
		static NetworkAccessManager instance;
		return instance;
	}

	static NetworkAccessManager* instancePointer();

	Q_INVOKABLE void fetchAll();
	Q_INVOKABLE void fetchSettings();
	Q_INVOKABLE void fetchRadioStation();
	Q_INVOKABLE void fetchRadioGenres();
	Q_INVOKABLE void pingUrl(const QString urlString);
//	Q_INVOKABLE void pingUrlThread(const QString urlString);

signals:
	void urlReached(QString urlString, bool reached);

private slots:
	void handleFetchSettings();
	void handleFetchRadioStation();
	void handleFetchRadioGenres();
	void handleAddressPinger_old(QString urlString, bool reached);
	void handleAddressPinger();

protected:
	QNetworkRequest getRequest();

private:
	NetworkAccessManager(QObject* parent = 0);

	NetworkAccessManager(NetworkAccessManager const&);
	void operator =(NetworkAccessManager const&);
};

} /// namespace filtermusic

#endif /// FILTERMUSIC_NETWORKACCESSMANAGER_H
