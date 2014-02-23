---
layout: post
author: Uli Heller
published: true
title: "Linux - Zugriffsrechte mit ACL"
date: 2014-02-23 08:00
#updated: 2014-02-15 07:00
comments: true
categories: 
- Linux
---

Dieser Artikel basiert auf
<http://itsprite.com/3-acl-samples-for-linux-user-permission-management/>.

Für einen meiner Kunden betreue ich eine Anwendung namens "DUPL".
Die Anwendung besteht aus verschiedenen Teilen, u.a.

* einer Webanwendung basierend auf TOMCAT
* einem Datenbank-Teil basierend auf ORACLE 11g

Für die Betreuung brauche ich 

* Schreib- und Lesezugriff auf das Arbeitsverzeichnis des TOMCATs
* Lesezugriff auf die Log-Dateien von ORACLE 11g

Bislang wurde das durch eine Mischung aus Standard-Unix-Zugriffsrechte
und Cronjobs erledigt. Mit ACLs müßte das wesentlich eleganter umzusetzen
sein.

<!-- more -->

Tomcat-Arbeitsverzeichnis
-------------------------

Der Tomcat von DUPL läuft unter einem eigenen Benutzer "tomcat-dupl" in
einer eigenen Gruppe "tomcat-dupl".
Er hat ein Arbeitsverzeichnis /data/dupl.
In diesem Arbeitsverzeichnis legt er Dateien und Verzeichnisstrukturen
an. Die Struktur unterhalb des Arbeitsverzeichnisses sieht dann beispielsweise
so aus:

* dupl.log
* dupl.log.2014-02-22
* dupl.log.2014-02-21
* ...
* 2014-02-22-statistics/00-06/access.log
* 2014-02-22-statistics/06-12/access.log
* 2014-02-22-statistics/12-18/access.log
* 2014-02-22-statistics/18-24/access.log
* 2014-02-21-statistics/00-06/access.log
* 2014-02-21-statistics/06-12/access.log
* 2014-02-21-statistics/12-18/access.log
* 2014-02-21-statistics/18-24/access.log
* ...

Mein Wartungsbenutzer ist unabhängig vom Tomcat-Benutzer: Er hat den
Namen "uli" und gehört nicht der Tomcat-Gruppe an, sondern nur der Gruppe
"staff".

Die Wartungstätigkeiten erfordern die Möglichkeit:

* Sichten aller Dateien im Arbeitsverzeichnis und aller Unterverzeichnisse
* Editieren aller Dateien im Arbeitsverzeichnis und aller Unterverzeichnisse
* Löschen alter Dateien und alter Unterverzeichnisse

### Traditioneller Ansatz

Beim bisher verwendeten traditionellen Ansatz wird:

* Das Arbeitsverzeichnis /data/dupl dem Benutzer "tomcat-dupl" und der
  Gruppe "staff" zugeordnet:

    * `chown tomcat-dupl.staff /data/dupl`

* Die Zugriffsrechte so geändert, dass sowohl der Benutzer als auch die
  Gruppe vollen Lese- und Schreibzugriff hat:

    * `chmod 775 /data/dupl`

* Zusätzlich wird noch das "SETGID"-Bit gesetzt, so dass alle Dateien und
  Verzeichnisse der Gruppe "staff" zugeordnet werden:

    * `chmod g+s /data/dupl`

* Die UMASK für den Tomcat-Benutzer und meinen Wartungsbenutzer wird auf
  "002" gesetzt, so dass neu angelegte Dateien und Verzeichnisse per
  Standard für die Gruppe beschreibbar sind:

    * `umask 002`

Mit diesen Einstellungen kann ich alle Dateien, die der Tomcat unterhalb
von /data/dup anlegt, problemlos lesen und schreiben. Das ganze funktioniert
auch für alle Unterverzeichnisse und darin enthaltene Dateien.

Blöd wird's, wenn ich mit meinem Benutzer darin rumwerkle und den
UMASK-Eintrag nicht richtig gesetzt habe. Wenn ich bspw. um `umask 022`
in /data/dup neue Dateien oder Verzeichnisse anlege, dann hat
der Tomcat nur Lesezugriff und keinen Schreibzugriff.

### Neuer Ansatz mit ACL

Mit ACLs kann man die Sache zuverlässiger in den Griff bekommen,
die Rechte hängen dann nicht mehr von der UMASK ab.

* Zunächst: ACL für das Arbeitsverzeichnis festlegen:
    * Benutzer der Gruppe "staff": rwx auf alles:
        * `setfacl -m g:staff:rwx /data/dupl`
    * Benutzer der Gruppe "tomcat-dupl": rwx auf alles
        * `setfacl -m g:tomcat-dupl:rwx /data/dupl`
    * Die beiden vorgenannten Rechte sollen per Standard auch
      für alle darin angelegten Verzeichnisse und Dateien gelten:
        * `setfacl -d -m g:staff:rwx /data/dupl`
        * `setfacl -d -m g:tomcat-dupl:rwx /data/dupl`
* Dann: Test, ob das alles so funktioniert
    * Tomcat: Datei und Verzeichnis innerhalb von /data/dupl anlegen,
      modifizieren, löschen -> klappt
    * Benutzer der Gruppe "staff": Datei und Verzeichnis innerhalb
      von /data/dupl anlegen, modifizieren, löschen -> klappt
    * Tomcat: Verzeichnis anlegen, "staff": Datei darin anlegen,
      Tomcat: Datei modifizieren -> klappt
* Zuletzt: Rechte auf das gesamte Arbeitsverzeichnis anwenden:
    * `setfacl -R -m g:staff:rwx /data/dupl`
    * `setfacl -R -m g:tomcat-dupl:rwx /data/dupl`
    * `setfacl -R -d -m g:staff:rwx /data/dupl`
    * `setfacl -R -d -m g:tomcat-dupl:rwx /data/dupl`

...

