---
layout: post
title: "Maven/Gradle: Betrieb hinter einer Enterprise-Firewall"
date: 2013-10-06 08:00
#updated: 2013-09-16 09:00
comments: true
external-url: 
categories: 
- Linux
- Ubuntu
- Proxy
---

Einer meiner Kunden setzt eine Firewall kombiniert mit einem
Proxy-Server ein, um das interne Netz vom Internet abzukoppeln.
Der Zugriff vom internen Netz in's Internet ist dadurch stark eingeschränkt.

* Manche Web-Seiten werden generell geblockt ... ist bislang kein Problem für mich
* Zugriff auf's Internet ist generell nur mit bestimmten Browsern möglich - der HTTP Header "User-Agent" muß bestimmte Werte haben ... dadurch werden Build-Tools wie Gradle und Maven geblockt
* Zugriff auf's Internet geht generell nur, wenn man sich am Proxy-Server angemeldet hat ... dadurch funktioniert bei mir der Zugriff von Eclipse aus nicht, man kann Eclipse-Plugins nur sehr umständlich installieren

Zur Lösung der letzten beiden Probleme gibt es nun die Idee, einen eigenen
Proxy-Server zu betreiben, der dann die Anmeldung am
"richtigen" Proxy-Server übernimmt und der den User-Agent auf geeignete Werte
setzt.

<!-- more -->

## Das GitHub-Projekt

Den Proxy-Server habe ich in Java implementiert und im Rahmen meiner "Mini-Tools" auf GitHub
abgelegt. Zu finden ist der Proxy-Server hier: [Forward-Proxy](https://github.com/uli-heller/uli-mini-tools/blob/master/forward-proxy/README.md).

## Die Zutaten

Der eigentliche Kern des Proxy-Servers ist recht klein - die meisten Zutaten liefert das Projekt
[Jetty](http://www.eclipse.org/jetty/). Konkret habe ich hiervon verwendet:

* [ProxyServlet](http://www.eclipse.org/jetty/documentation/current/proxy-servlet.html)
* [ProxyServer](http://git.eclipse.org/c/jetty/org.eclipse.jetty.project.git/tree/examples/embedded/src/main/java/org/eclipse/jetty/embedded/ProxyServer.java?id=jetty-9.0.6.v20130930)

Zur Kompilierung des Projektes verwende ich [Gradle](http://gradle.org). Von mir selbst stammen ein paar Ergänzungen,
die

* diverse Einstellungen aus Properties-Dateien lesen
* die Anmeldung am Enterprise-Proxy-Server vornehmen
* das Programm paketieren und einfach ausführbar machen auf Kommandozeilenebene

## Das Bauen

Das Bauen des Projektes ist denkbar einfach, sofern ein JDK7 installiert und im PATH verfügbar ist:

* Shell-Fenster öffnen
* In den Ordner "uli-mini-tools/forward-proxy" wechseln
* Ausführen: `../gradlew` (... oder unter Windows: `..\gradlew`)

Danach gibt es die beiden Dateien

* forward-proxy-{version}.sh ... für Unix/Linux
* forward-proxy-{version}.bat ... für Windows

Sie können direkt von der Shell aus ausgeführt werden.

## Der Test

Getestet habe ich den neuen Proxy-Server mit einem einfachen Gradle-Projekt:

* Konfigurationsdatei "forward-proxy.properties" für den Forward-Proxy:

      proxyPort           = 8888
      parentProxyHost     = 192.168.178.47
      parentProxyPort     = 3128
      parentProxyUser     = uli
      parentProxyPassword = xxxxxx
      replaceHeaders      = User-Agent
      User-Agent          = InternetExploder

* Start vom Forward-Proxy:

      ./forward-proxy*.sh

* gradle.properties:

      systemProp.http.proxyHost=localhost
      systemProp.http.proxyPort=8888

* [Gradle-Projekt](/downloads/code/simple-gradle-project.zip) auspacken und neu bauen mit

      ./gradlew --refresh-dependencies
      # Windows: .\gradlew --refresh-dependencies
