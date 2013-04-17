---
layout: post
title: "Von Github zu Subversion"
date: 2013-04-16 07:07
updated: 2013-04-17 08:00
comments: false
author: Uli Heller
categories: 
- Git
- Subversion
---

Von Github zu Subversion
========================

Den Prototypen unserer Webseite habe ich erstmal von "unterwegs" auf
GitHub angelegt. Dieser Artikel beschreibt, wie die Quelltexte
inklusive Versionshistorie umgezogen
werden können in ein privates Subversion-Repository.

<!-- more -->

Leeres Subversion-Repository anlegen
------------------------------------

Zunächst muß ein leeres Subversion-Repository angelegt werden, welches
nur die Verzeichnisse

* trunk
* branches
* tags

enthält.

Lokal kann man ein Subversion-Repository so anlegen:

{% codeblock Lokales Subversion-Repository anlegen %}
# Repository anlegen
svnadmin create /tmp/dp-octopress.svn

# Grundstruktur anlegen
cd /tmp
svn checkout file:///tmp/dp-octopress.svn dp-octopress
cd dp-octopress
svn mkdir tags branches trunk
svn commit -m "Grundstruktur angelegt"

# Aufraeumen
cd ..
rm -rf dp-octopress
{% endcodeblock %}

Danach kann man das Repository mit

* `svn checkout file:///tmp/dp-octopress.svn/trunk dp-octopress`

auschecken.

Wie dieses Anlegen auf unserem Subversion-Server
genau funktioniert beschreibe ich hier nicht näher. Am Ende hat
man ein Subversion-Repository, das man beispielsweise
mit

* `svn checkout https://83.236.132.107/svn/dp-octopress/trunk dp-octopress`

auschecken kann.

Neues Git-Repository einrichten
-------------------------------

{% codeblock Neues Git-Repository einrichten lang:sh %}
cd ~/git
git svn clone --stdlayout https://83.236.132.107/svn/dp-octopress dp-octopress
#git svn clone --stdlayout file:///tmp/dp-octopress.svn dp-octopress
{% endcodeblock %}

Altes Git-Repository übernehmen
-------------------------------

{% codeblock Altes Git-Repository übernehmen lang:sh %}
cd ~/git/dp-octopress
git pull --no-commit ~/git/octopress     # Pfad zum alten Git-Repository
git commit -m "Pull von ~/git/octopress"
{% endcodeblock %}

Verschmelzen mit dem Subversion-Repository
------------------------------------------

{% codeblock Verschmelzen mit dem Subversion-Repository lang:sh %}
cd ~/git/dp-octopress
git svn fetch
git rebase trunk master
while [ $? -ne 0 ]; do git checkout --theirs .; git add .; git rebase --continue; done
{% endcodeblock %}

Git-Historie in SVN speichern
-----------------------------

{% codeblock Git-Historie in Subversion speichern lang:sh %}
cd ~/git/dp-octopress
git svn dcommit
{% endcodeblock %}

Leider bricht dies ab, weil bei einem Git-Commit wohl
die Verzeichnisse "source" und "sass" wohl gelöscht und gleich
wieder neu angelegt wurden.

Zunächst muß ermittelt werden, bei welchem Commit der Abbruch
erfolgte:

* `git log`
* Suchen nach "svn"
* Commit: 44722bcf55a05200ea7821a60da0749650fd3953 ... hat geklappt
* Commit: 0e154718cdb11eb29b3a6cc91572de365dfece35 ... hat nicht geklappt

Dieser Commit muß nun aufgesplittet werden:

* `git rebase -i 44722bcf55a05200ea7821a60da0749650fd3953`
* 0e15471 mit "edit" markieren, dann abspeichern und Editor beenden
* Commit-Kommentar speichern mit `git log -1 --pretty=%B >commit.txt`
* `git reset HEAD^`
* `git commit -m "Deleted source" source`
* `git commit -m "Deleted sass" sass`
* `git commit -F commit.txt .`
* `rm commit.txt`
* `git rebase --continue`

... und danach die Übertragung Richtung Subversion neu starten mit

* `git svn dcommit`

Diesmal läuft's durch!
