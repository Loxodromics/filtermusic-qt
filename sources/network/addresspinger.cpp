//
//  addresspinger.cpp
//  %PROJECT_NAME%
//
//  Created by philipp2 on 21.11.2017.
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
	  m_timer(nullptr),
	  m_url(url),
	  m_didConnect(false)
{
}

AddressPinger::~AddressPinger()
{
//	this->m_timer->deleteLater();
}

void AddressPinger::run()
{
	qDebug() << "AddressPinger::run";
//	this->m_timer = new QTimer();
//	this->m_timer->setInterval(500);

//	connect( this->m_timer, &QTimer::timeout,
//			 this, &AddressPinger::pingOnce) ;

//	this->m_timer->start();
	this->pingOnce();
//	exec();
}

void AddressPinger::pause(bool isAPause)
{
//	if (isAPause)
//		this->m_timer->stop();
//	else
//		this->m_timer->start();
}

bool AddressPinger::isPaused() const
{
	return false;
}

void AddressPinger::pingOnce()
{
	qDebug() << "AddressPinger::pingOnce";
	auto socket = new QTcpSocket(nullptr);
	socket->connectToHost(this->m_url.host(), this->m_url.port(80));

	if ( socket->waitForConnected(PING_WAIT_TIME) )
	{
//		qDebug() << "Connected!";
		this->setDidConnect(true);
		if (!isPaused())
			emit addressReached(this->m_url.toString(), true);
	}
	else
	{
//		qDebug() << "Not connected" << socket->error();
		this->setDidConnect(false);
		if (!isPaused())
			emit addressReached(this->m_url.toString(), false);
	}

	socket->deleteLater();
}

void AddressPinger::go()
{
	qDebug() << "AddressPinger::go";
	this->run();
}

bool AddressPinger::didConnect() const
{
	return m_didConnect;
}

void AddressPinger::setDidConnect(bool didConnect)
{
	m_didConnect = didConnect;
}

const QUrl AddressPinger::url() const
{
	return this->m_url;
}

} /// namespace filtermusic
