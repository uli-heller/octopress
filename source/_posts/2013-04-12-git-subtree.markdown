---
layout: post
title: "Git Subtree (1/2)"
date: 2013-04-12 07:14
comments: true
external-url: 
categories: 
- Linux
- Ubuntu
- Git
---

Git Subtree - Neues DEB-Paket bereitstellen
===========================================

Einleitung
----------

Kurze Erklärung: Warum will ich's verwenden? Warum kann ich's nicht
direkt verwenden?

Leider ist `git subtree` in den von mir verwendeten Pakete standardmässig
nicht aktiv:

{% codeblock git-subtree fehlt lang:sh %}
$ git subtree
git: 'subtree' is not a git command. See 'git --help'.
{% endcodeblock %}

Entweder wir aktivieren es manuell oder wir bauen neue Pakete, bei denen `git subtree` aktiviert ist.

Manuelles Aktivieren von Git Subtree
------------------------------------

{% codeblock git-subtree manuell installieren lang:sh %}
$ git subtree
git: 'subtree' is not a git command. See 'git --help'.
$ sudo cp /usr/share/doc/git/contrib/subtree/git-subtree.sh /usr/lib/git-core/git-subtree
$ sudo chmod +x  /usr/lib/git-core/git-subtree
$ git subtree
usage: git subtree add   --prefix=<prefix> <commit>
   or: git subtree add   --prefix=<prefix> <repository> <commit>
   or: git subtree merge --prefix=<prefix> <commit>
...
{% endcodeblock %}

Nachteil beim manuellen Aktivieren: Es gibt keine Online-Dokumentation,
d.h. `git help subtree` läuft in's Leere.

Erzeugung neuer DEB-Pakete
--------------------------

* Ausgangspunkt: Build-Verzeichnis für Git-1.8.2.1 liegt vor, d.h. ich
  kann mit `dpkg-buildpackage` neue DEB-Pakete erzeugen
* Sichtung: Wie funktioniert die Einbindung von "subtree"?
    * Die Implementierung liegt unter contrib/subtree
    * Eine Einspielanleitung gibt's dort auch
    * Diese müssen wir "eigentlich" nur noch in debian/rules einbauen
      und fertig!
* Also: Änderungen an debian/changelog und debian/rules durchführen und
  los geht's mit `dpkg-buildpackage` (... das dauert)
* Sichtung: Ist git-subtree in den erstellten Paketen enthalten?
    * `dpkg-deb -c git_1.8.2.1*deb|grep git-core/git-subtree`

### Probleme

#### Falscher Installationspfad

* Verwendet wird: /build/git/git-1.8.2.1/debian/git/usr/libexec/git-core
* Richtig wäre:  /build/git/git-1.8.2.1/debian/git/usr/lib/git-core
* Korrektur durch: Setzen von libexecdir in debian/rules
