---
layout: post
author: Uli Heller
published: true
title: "Langsames SSH"
date: 2014-02-13 08:00
#updated: 2013-02-14 08:00
comments: true
categories: 
- SSH
---

Ich habe bei mir zu Hause einen kleinen Server stehen, auf den
ich mittels SSH zugreife. Der Server hängt "so halb" im Internet.
Meine Beobachtung: Wenn ich mit einem meiner Heimrechner mit SSH
auf den Rechner zugreifen möchte, dann dauert's immer ewig bis der
Kommandozeilenprompt erscheint.

<!-- more -->

Details
-------

Auf dem Server läuft ein Ubuntu-12.04, weitgehend in Standardkonfiguration.
SSH habe ich auch erstmal unverändert belassen. Für meinen Benutzer habe
ich die Anmeldung mittels "public/private key" eingerichtet, die funktioniert
auch - ich muß beim SSH-Zugriff das Benutzerkennwort nicht eingeben und lande
direkt auf der Kommandozeile.

Unschön ist nur die lange Dauer, bis die Kommandozeile erscheint.

Es zeigt sich, dass die Ursache die Wandlung von IP-Adressen nach Hostnamen
ist. Bei der SSH-Anmeldung versucht der Server üblicherweise, die IP-Adresse
des Heimrechners umzuwandeln in den Namen dieses Rechners. Das funktioniert
für mein Heimnetz oftmals nicht richtig und läuft in eine Zeitüberschreitung.
Dies führt zu der Wartezeit.

Abhilfe
-------

Ich schalte die Wandlung von IP-Adressen nach Hostnamen einfach ab.
Dazu modifiziere ich die Datei "/etc/ssh/sshd_config" wie folgt:

```diff
--- sshd_config.orig	2014-01-18 10:07:10.000000000 +0100
+++ sshd_config	2014-02-13 06:58:07.707506337 +0100
@@ -85,3 +85,5 @@
 # PAM authentication, then enable this but set PasswordAuthentication
 # and ChallengeResponseAuthentication to 'no'.
 UsePAM yes
+
+UseDNS no
```

Zur "Sicherheit" starte ich den SSHD noch neu mit `/etc/init.d/ssh restart`
und kontrolliere die SSH-Anmeldegeschwindigkeit: Alles gut!
