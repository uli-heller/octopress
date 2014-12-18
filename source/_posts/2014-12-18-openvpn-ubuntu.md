---
layout: post
author: Uli Heller
published: true
title: "OpenVPN unter Ubuntu nutzen"
date: 2014-12-18 06:00
#updated: 2014-12-18 20:00
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- OpenVPN
---

Installation von OpenVPN
------------------------

{% codeblock Installation von OpenVPN %}
sudo apt-get install openvpn
{% endcodeblock %}

Konfigurationsdateien von OpenVPN einspielen
---------------------------------------------

{% codeblock Konfigurationsdateien von OpenVPN einspielen %}
mkdir ~/openvpn
unzip -d ~/openvpn uheller.zip
{% endcodeblock %}

Es werden Dateien wie diese abgelegt:

* openvpn/2E76.crt        
* openvpn/2E76.key        
* openvpn/ca.crt          
* openvpn/ta.key          
* openvpn/uheller.ovpn    

Konfigurationsdatei anpassen
----------------------------

Die Datei "openvpn/uheller.ovpn" enthält die OpenVPN-Konfiguration
für Windows. Unter Linux kann sie leider nicht direkt verwendet werden,
ein Start scheitert mit dieser Fehlermeldung:

{% codeblock Fehlermeldung beim OpenVPN-Start %}
uli:~/openvpn$ sudo openvpn ~/openvpn/uheller.ovpn
Options error: Unrecognized option or missing parameter(s) in /home/uli/openvpn/uheller.ovpn:25: register-dns (2.3.2)
Use --help for more information.
{% endcodeblock %}

Die Zeile 25 muß auskommentiert werden durch Voranstellen einer Raute '#'.

Mit der vorgenannten Änderung kann OpenVPN gestartet werden, die
Namensauflösung DNS funktioniert aber nicht. Hierzu sind Ergänzungen
an der Konfigurationsdatei erforderlich:

{% codeblock Ergänzungen an uheller.ovpn %}
script-security 2
up /etc/openvpn/update-resolv-conf
down /etc/openvpn/update-resolv-conf
{% endcodeblock %}

OpenVPN starten
---------------

{% codeblock OpenVPN starten %}
$ sudo openvpn ~/openvpn/uheller.ovpn
Enter Auth Username: uheller
Enter Auth Password: xxxx
{% endcodeblock %}
