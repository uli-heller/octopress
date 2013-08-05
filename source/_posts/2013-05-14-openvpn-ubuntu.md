---
layout: post
author: Uli Heller
published: true
title: "OpenVPN unter Ubuntu nutzen"
date: 2013-05-14 06:00
updated: 2013-05-16 20:00
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

OpenVPN starten
---------------

{% codeblock OpenVPN starten %}
$ sudo openvpn ~/openvpn/uheller.ovpn
Enter Auth Username: uheller
Enter Auth Password: xxxx
{% endcodeblock %}

VPN-Rechner nutzen
------------------

Das Hauptproblem ist nun die Namensauflösung.
Meine VPN-Gegenstelle nennt mir keinen NameServer, also
muß ich

* entweder immer via IP-Adresse "arbeiten"
* oder die Hosts selbst bei mir in /etc/hosts eintragen

Zunächst verfolge ich mal den ersten Ansatz:

* <https://10.157.1.20/owa> ... öffnet den Webmailer,
  hier kann ich mich anmelden mit "uheller"/"xxxx".

SUPER!
