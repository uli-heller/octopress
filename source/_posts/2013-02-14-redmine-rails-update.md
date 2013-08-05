---
layout: post
author: Uli Heller
published: true
title: "Rails-2.3.17"
date: 2013-02-14 06:10
updated: 2013-02-14 06:10
comments: true
categories: 
- Linux
- Ubuntu
- Lucid
- Ruby
- Redmine
---

Rails-Update für Redmine-1.2
============================

Leider ist schon wieder eine [Sicherheitslücke](http://www.heise.de/security/meldung/Neues-Sicherheits-Update-fuer-Ruby-on-Rails-1802557.html) in Rails
entdeckt worden.

Analog zur Aktualisierung auf 2.3.15 erfolgt nun die auf 2.3.17:

* Gems runterladen und auf Redmine-Rechner kopieren
* Betriebssystem aktualisieren
* Gems einspielen
* Alte Gems löschen

Gems herunterladen und zum Redmine-Server übertragen
----------------------------------------------------

Der Redmine-Server hat keinen Zugang zum Internet. Deshalb müssen die Gems
auf einem anderen Rechner heruntergeladen und zum Redmine-Server übertragen
werden.

{% include_code get-2.3.17.sh %}

Die Dateien werden danach mit SCP auf den Redmine-Server übertragen.

Basissystem aktualisieren
-------------------------

{% codeblock Basissystem aktualisieren lang:sh %}
apt-get update
apt-get upgrade
apt-get dist-upgrade
{% endcodeblock %}

Gems einspielen
---------------

{% codeblock Gems einspielen lang:sh %}
gem install rails-2.3.17.gem
{% endcodeblock %}

Alte Gems deininstallieren
--------------------------

{% include_code uninstall-2.3.15.sh %}
