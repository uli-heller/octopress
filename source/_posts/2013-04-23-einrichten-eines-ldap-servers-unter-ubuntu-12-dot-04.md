---
layout: post
title: "Einrichten eines LDAP-Servers unter Ubuntu-12.04"
date: 2013-04-23 15:38
updated: 2013-04-26 08:00
comments: true
external-url: 
categories: 
- Linux
- Ubuntu
- LDAP
---

<!--
Einrichten eines LDAP-Servers unter Ubuntu-12.04
================================================
-->

Rechner aktualisieren
---------------------

Zunächst sollte der Rechner aktualisiert werden.

{% codeblock Rechner aktualisieren lang:sh %}
sudo apt-get update
sudo apt-get dist-upgrade
{% endcodeblock %}

LDAP-Pakete installieren
------------------------

{% codeblock LDAP-Pakete installieren lang:sh %}
sudo apt-get install slapd ldap-utils cpu whois
# LDAP-Administrator-Passwort: uli
{% endcodeblock %}

LDAP-Schemas definieren
-----------------------

Standard-Schemas:

{% codeblock LDAP-Schemas definieren lang:sh %}
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/cosine.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/nis.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/inetorgperson.ldif
{% endcodeblock %}

Zusatz-Schema:

{% codeblock LDAP-Zusatzschema definieren lang:sh %}
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/backend_dp.ldif
{% endcodeblock %}

Das Zusatzschema gibt's [hier](/downloads/code/backend_dp.ldif)

LDAP-Daten importieren
----------------------

Es müssen entweder die Grunddaten importiert werden oder aber
der Datenbestand eines anderen LDAP-Servers.

### Grunddaten importieren

{% codeblock Grunddaten importieren lang:sh %}
sudo service slapd stop
sudo slapadd -c -l /root/base.ldif
sudo service slapd start
{% endcodeblock %}


### Datenbestand importieren

Dieser Schritt ist optional. Er dient primär der Übernahme eines Datenbestandes
von einem bestehenden LDAP-Server.

{% codeblock LDAP-Daten importieren lang:sh %}
sudo service slapd stop
sudo slapadd -c -l 94.out.ldif  # 94.out.ldif ist eine ältere LDAP-Sicherung
sudo service slapd start
{% endcodeblock %}

Hilfsskripte installieren
-------------------------

Wir haben einige Hilfsskripte, die die Arbeit mit dem LDAP-Verzeichnis erleichtern:

* /usr/local/bin/ldap-create-user.sh
  ... legt einen LDAP-Benutzer an (basiert auf "cpu")
* /usr/local/bin/ldap-delete-user.sh
  ... löscht einen LDAP-Benutzer (basiert auf "cpu")
* /usr/local/bin/ldap-modify-slapcat.sh
  ... setzt die LDAP-Kennworte aller Benutzer in einem LDAP-Export auf "keines"
* /etc/cpu/cpu.conf
  ... Konfigurationsdatei für "cpu", enthält u.a. das Admin-Kennwort von LDAP

Web-Anwendung für Kennwort-Änderung installieren
------------------------------------------------

Unsere Web-Anwendung soll mit dem Apache2 betrieben werden,
also spielen wir den Apache2 ein und konfigurieren ihn auch gleich.

{% codeblock Apache2 installieren und konfigurieren lang:sh %}
sudo apt-get install apache2 # Web-Server Apache-2.2.22 einspielen
sudo cp /etc/apache2/sites-available/default /etc/apache2/sites-available/changepass
sudo jmacs  /etc/apache2/sites-available/changepass
# Einige Anpassungen vornehmen...
# - CGI: ldap/cgi-bin -> cgi-bin/ldap
sudo a2dissite default
sudo a2ensite changepass
sudo service apache2 restart
{% endcodeblock %}

Die Web-Anwendung benötigt noch einige Perl-Module.

{% codeblock Perl-Module installieren lang:sh %}
sudo apt-get install libconfig-tiny-perl
sudo apt-get install libnet-ldap-perl
{% endcodeblock %}

Zuletzt: Web-Anwendung einspielen. Folgende Dateien werden dabei benötigt:

* /etc/changepass.conf
* /etc/apache2/sites-available/changepass
* /usr/lib/cgi-bin/ldap/changepass
* /var/www/index.html
* /var/www/ldap/changepass.css

LDAP in Firewall freischalten
-----------------------------

Sofern die UFW-Firewall installiert und aktiviert ist, muß der LDAP-Port
freigeschaltet werden.

{% codeblock LDAP in Firewall freischalten lang:sh %}
sudo ufw allow 389/tcp
sudo ufw allow 80/tcp
sudo ufw status
{% endcodeblock %}

Tipps und Tricks
----------------

### LDAP-Daten sichern und zurückspielen

#### Sichern

{% codeblock LDAP-Daten sichern lang:sh %}
sudo slapcat -l /tmp/slapcat.ldif
{% endcodeblock %}

#### Zurückspielen

{% codeblock LDAP-Daten zurückspielen lang:sh %}
sudo service slapd stop
sudo rm -rf /var/lib/ldap/*
sudo slapadd -c -l /tmp/slapcat.ldif
sudo chown -R openldap.openldap /var/lib/ldap/*
sudo service slapd start
{% endcodeblock %}

#### Neustart mit einem leeren LDAP-Bestand

{% codeblock Neustart mit leerem LDAP-Bestand lang:sh %}
sudo service slapd stop
sudo rm -rf /var/lib/ldap/*
sudo service slapd start
{% endcodeblock %}
