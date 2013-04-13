---
layout: post
title: "Installation"
date: 2013-04-13 07:07
comments: false
author: Uli Heller
categories: 
---

Installation
============

In diesem Artikel beschreibe ich, wie man ein Linux-System so aufsetzt,
dass man damit Änderungen an unseren Webseiten vornehmen kann.
Die Beschreibung verwendet Ubuntu-12.04.2 als Basis.

<!-- more -->

Ausgangspunkt: Ubuntu-12.04.2
-----------------------------

Für die nachfolgende Beschreibung gehe ich davon aus, dass ein aktuelles
Ubuntu-12.04 als Basis vorliegt. Zum Zeitpunkt der Erstellung dieser Anleitung
meldet sich dieses beim Anmelden dann als "Ubuntu-12.04.2".

{% codeblock Anmeldeprompt %}
Ubuntu 12.04.2 LTS uli-desktop tty0
Login:
{% endcodeblock %}

Zunächst führen wir eine Systemaktualisierung durch:

{% codeblock Systemaktualisierung lang:sh %}
sudo apt-get update
sudo apt-get dist-upgrade
{% endcodeblock %}

Zusatzpakete einspielen
-----------------------

Nach der Systemaktualisierung haben wir nun sichergestellt, dass die aktuellen
Pakete auf unserem Rechner verfügbar sind. Nun müssen diverse Zusatzpakete
eingespielt werden:

{% codeblock Zusatzpakete einspielen lang:sh %}
sudo apt-get install gcc build-essential
sudo apt-get install libyaml-dev libz-dev libssl-dev
sudo apt-get install curl
sudo apt-get install git git-core
{% endcodeblock %}

Ruby installieren via RVM
-------------------------

{% codeblock Ruby installieren via RVM lang:sh %}
# curl -L https://get.rvm.io | bash -s stable --ruby
# --> meckert über einige fehlende Pakete, die installieren wir zuerst
echo "libreadline6-dev, libsqlite3-dev, sqlite3, libxml2-dev, libxslt1-dev, autoconf, libgdbm-dev, libncurses5-dev, automake, libtool, bison, pkg-config, libffi-dev"\
|tr -d ","\
|xargs sudo apt-get install -y
# Jetzt die eigentliche Ruby-Installation
curl -L https://get.rvm.io | bash -s stable --ruby # ... installiert ruby-2.0.0-p0
. ./.rvm/scripts/rvm
rvm rubygems latest # rubygems-2.0.3
ruby --version      # ruby 2.0.0p0 (2013-02-24 revision 39474) [i686-linux]
{% endcodeblock %}

DP-Webseite auschecken und Abhängigkeiten einspielen
----------------------------------------------------

Nachfolgender Schritt geht davon aus, dass die DP-Webseite in der
Versionsverwaltung GIT auf GITHUB abgespeichert ist. Dies ändert sich
möglicherweise demnächst!

{% codeblock DP-Webseite auschecken lang:sh %}
mkdir ~/git
cd ~/git
git clone git://github.com/uli-heller/octopress.git
{% endcodeblock %}

Als nächstes müssen die innerhalb der DP-Webseite festgelegten
Abhängigkeiten einspielt werden. Dies sind in erster Linie diverse
Ruby-Gems.

{% codeblock Abhängigkeiten einspielen lang:sh %}
cd ~/git/octopress    # wechseln in's Auscheck-Verzeichnis
gem install bundler # bundler-1.3.5
bundle install      # rake-0.9.2.2, ...
{% endcodeblock %}

Zuletzt noch ein Test. Beim letzten Schritt sollte im Browser die
DP-Webseite angezeigt werden!

{% codeblock Test der Installation lang:sh %}
cd ~/git/octopress    # wechseln in's Auscheck-Verzeichnis
rake generate         # "Successfully generated..."
rake preview          # "Compass is polling..."
# Nun manuell den Browser öffnen auf "http://localhost:4000"
{% endcodeblock %}

Hier der Link für den Browser: [http://localhost:4000](http://localhost:4000)
