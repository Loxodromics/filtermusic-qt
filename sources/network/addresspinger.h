//
//  addresspinger.h
//  Filtermusic
//
//  Created by philipp on 21.11.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#ifndef FILTERMUSIC_ADDRESSPINGER_H
#define FILTERMUSIC_ADDRESSPINGER_H

#include <QThread>
#include <QTimer>
#include <QUrl>

namespace filtermusic {

class AddressPinger : public QThread
{
	Q_OBJECT

public:
	explicit AddressPinger(QUrl url);
	~AddressPinger();

	virtual void run() override;
	bool isPaused() const;

	const QUrl url() const;

	bool didConnect() const;
	void setDidConnect(bool didConnect);

signals:
	void addressReached(QString url, bool reached);

public slots:
	void pingOnce();

protected:
	const QUrl m_url;
	bool m_didConnect;
};

} /// namespace filtermusic

#endif /// FILTERMUSIC_ADDRESSPINGER_H
