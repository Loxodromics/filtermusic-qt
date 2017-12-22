//
//  addresspinger.cpp
//  Filtermusic
//
//  Created by philipp on 21.11.2017.
//  Copyright (c) 2017 Philipp Engelhard. All rights reserved.
//
#include "addresspinger.h"
#include "sources/commons/constants.h"
#include <QtNetwork/QTcpSocket>
#include <QDebug>
#include <QTimer>

namespace filtermusic {

AddressPinger::AddressPinger(QUrl url)
	: QThread(),
	  m_url(url),
	  m_didConnect(false)
{
}

AddressPinger::~AddressPinger()
{
}

void AddressPinger::run()
{
//	qDebug() << "AddressPinger::run";
	this->pingOnce();
}

void AddressPinger::pingOnce()
{
//	qDebug() << "AddressPinger::pingOnce";
	auto socket = new QTcpSocket(nullptr);
	socket->connectToHost(this->m_url.host(), this->m_url.port(80));

	if ( socket->waitForConnected(PING_WAIT_TIME) )
	{
//		qDebug() << "Connected!";
		this->setDidConnect(true);
		emit addressReached(this->m_url.toString(), true);
	}
	else
	{
//		qDebug() << "Not connected" << socket->error();
		this->setDidConnect(false);
		emit addressReached(this->m_url.toString(), false);
	}

	socket->deleteLater();
}

bool AddressPinger::didConnect() const
{
	return this->m_didConnect;
}

void AddressPinger::setDidConnect(bool didConnect)
{
	this->m_didConnect = didConnect;
}

const QUrl AddressPinger::url() const
{
	return this->m_url;
}

} /// namespace filtermusic
