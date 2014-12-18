---
layout: post
author: Uli Heller
published: true
title: "Subversion: Probleme mit Zertifikaten"
date: 2014-10-18 08:00
#updated: 2014-02-15 07:00
comments: true
categories: 
- Linux
- Ubuntu
---

Seit einigen Wochen beobachte ich Probleme in Zusammenhang mit den
SSL-Zertifikaten und Subversion. Aus irgendeinem Grund kann ich das
Zertifikat nicht mehr permanent akzeptieren. Das ist sehr lästig, weil
man immer wieder mit Fehlermeldungen belästigt wird und diese mit "t"
wegdrücken muß.

Beobachtet habe ich das Problem mit Ubuntu-12.04. Mit 14.04 geht's
wie gewohnt ohne Probleme.

<!-- more -->

Fehlermeldung
-------------

### Deutsch

```
$ svn update
Aktualisiere ».«:
Fehler bei der Validierung des Serverzertifikats für »https://83.236.132.107:443«:
 - Das Zertifikat ist nicht von einer vertrauenswürdigen Instanz ausgestellt
   Überprüfen Sie den Fingerabdruck, um das Zertifikat zu validieren!
Zertifikats-Informationen:
 - Hostname: 83.236.132.107
 - Gültig: von Oct 13 08:37:37 2014 GMT bis Oct 13 08:37:37 2015 GMT
 - Aussteller: daemons point GmbH, Stuttgart, BW, DE(uli.heller@daemons-point.com)
 - Fingerabdruck: 7C:34:E3:6A:17:C2:12:C7:EC:9F:51:3D:D0:37:0B:71:D5:4C:89:70
Ve(r)werfen, (t)emporär akzeptieren oder (p)ermanent akzeptieren? p
Fehler bei der Validierung des Serverzertifikats für »https://83.236.132.107:443«:
 - Das Zertifikat hat einen unbekannten Fehler.
Zertifikats-Informationen:
 - Hostname: 83.236.132.107
 - Gültig: von Oct 13 08:37:37 2014 GMT bis Oct 13 08:37:37 2015 GMT
 - Aussteller: daemons point GmbH, Stuttgart, BW, DE(uli.heller@daemons-point.com)
 - Fingerabdruck: 7C:34:E3:6A:17:C2:12:C7:EC:9F:51:3D:D0:37:0B:71:D5:4C:89:70
Ve(r)werfen oder (t)emporär akzeptieren? t
Fehler bei der Validierung des Serverzertifikats für »https://83.236.132.107:443«:
 - Das Zertifikat hat einen unbekannten Fehler.
Zertifikats-Informationen:
 - Hostname: 83.236.132.107
 - Gültig: von Oct 13 08:37:37 2014 GMT bis Oct 13 08:37:37 2015 GMT
 - Aussteller: daemons point GmbH, Stuttgart, BW, DE(uli.heller@daemons-point.com)
 - Fingerabdruck: 7C:34:E3:6A:17:C2:12:C7:EC:9F:51:3D:D0:37:0B:71:D5:4C:89:70
Ve(r)werfen oder (t)emporär akzeptieren? t
Revision 235.
```

### Englisch

```
$ svn update
Updating '.':
Error validating server certificate for 'https://83.236.132.107:443':
 - The certificate is not issued by a trusted authority. Use the
   fingerprint to validate the certificate manually!
Certificate information:
 - Hostname: 83.236.132.107
 - Valid: from Oct 13 08:37:37 2014 GMT until Oct 13 08:37:37 2015 GMT
 - Issuer: daemons point GmbH, Stuttgart, BW, DE(uli.heller@daemons-point.com)
 - Fingerprint: 7C:34:E3:6A:17:C2:12:C7:EC:9F:51:3D:D0:37:0B:71:D5:4C:89:70
(R)eject, accept (t)emporarily or accept (p)ermanently? p
Error validating server certificate for 'https://83.236.132.107:443':
 - The certificate has an unknown error.
Certificate information:
 - Hostname: 83.236.132.107
 - Valid: from Oct 13 08:37:37 2014 GMT until Oct 13 08:37:37 2015 GMT
 - Issuer: daemons point GmbH, Stuttgart, BW, DE(uli.heller@daemons-point.com)
 - Fingerprint: 7C:34:E3:6A:17:C2:12:C7:EC:9F:51:3D:D0:37:0B:71:D5:4C:89:70
(R)eject or accept (t)emporarily? t
Error validating server certificate for 'https://83.236.132.107:443':
 - The certificate has an unknown error.
Certificate information:
 - Hostname: 83.236.132.107
 - Valid: from Oct 13 08:37:37 2014 GMT until Oct 13 08:37:37 2015 GMT
 - Issuer: daemons point GmbH, Stuttgart, BW, DE(uli.heller@daemons-point.com)
 - Fingerprint: 7C:34:E3:6A:17:C2:12:C7:EC:9F:51:3D:D0:37:0B:71:D5:4C:89:70
(R)eject or accept (t)emporarily? t
At revision 235.
```
