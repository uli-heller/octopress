---
layout: post
title: "Herunterladen des HTTPS-Server-Zertifikats"
date: 2013-04-21 08:20
comments: true
external-url: 
categories: 
- HTTPS
- Zertifikat
---

Herunterladen des HTTPS-Server-Zertifikats über die Kommandozeile
=================================================================

Den Trick habe ich von einem [EclipseSource-Blog](http://eclipsesource.com/blogs/2013/04/19/installing-eclipse-plug-ins-from-an-update-site-with-a-self-signed-certificate/):

{% codeblock Herunterladen eines Server-Zertifikats lang:sh %}
echo -n \
| openssl s_client -connect HOST:PORTNUMBER \
| sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \
> my-custom-cert.cert
{% endcodeblock %}

Prima, das erspart mir künftig einiges an Rumklickerei im Browser.
