---
layout: post
title: "Von Github zu Subversion"
date: 2013-04-16 07:07
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

enthält. Wie dieses Anlegen genau funktioniert beschreibe ich hier nicht
näher. Am Ende hat man ein Subversion-Repository, das man beispielsweise
mit

* `svn checkout https://83.236.132.107/svn/dp-octopress/trunk dp-octopress`

auschecken kann.

Git-Repository übernehmen
-------------------------

* `cd dp-octopress`
* `git subtree pull --prefix="." $(pwd)/../octopress master`

Beim letzten Kommando treten leider einige Konflikte auf. Diese habe ich
jeweils korrigiert mit

* `git checkout --theirs ...`
* `git add ...`
* `git rebase --continue`

Git-Historie in SVN speichern
-----------------------------

* `git svn dcommit`

Leider bricht dies ab, weil bei einem Git-Commit wohl
die Verzeichnisse "source" und "sass" wohl gelöscht und gleich
wieder neu angelegt wurden.

* `git rebase -i ...`
* Betreffenden COMMIT mit EDIT markieren
* `git reset HEAD^`
* `git commit -m "Deleted source" source`
* `git commit -m "Deleted sass" sass`
* `git commit -m "Original commit" .`
* `git rebase --continue`

... und danach die Übertragung Richtung SVN neu starten mit

* `git svn dcommit`

Diesmal läuft's durch!
