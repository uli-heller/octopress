---
layout: post
author: Uli Heller
published: true
title: "WLAN-Konfiguration beim Ubuntu-Server"
date: 2013-06-14 12:00
#updated: 2013-06-14 19:00
comments: true
categories: 
- Linux
- Ubuntu
- Server
- Precise
---

Meinen alten EEEPC würde ich gerne als DHCP-Server weiterverwenden.
Also: Ubuntu-12.04-Server drauf und los geht's. Dumm nur:
Aktuell ist unklar, wie ich die WLAN-Konfiguration hinbekomme.
Auf Desktop-Systemen macht man das ja mit dem NetworkManager,
was auf dem Server ohne graphische Benutzerschnittstelle schwierig ist.

<!-- more -->

## Vorbereitungen

Auf dem EEEPC habe ich diese Grundinstallation vorgenommen:

* Ubuntu-12.04.2 Server, 32 bit
* Raring-Kernel
* Alle Aktualisierungen vom heutigen Tage (2013-06-14)

## Grundtests

Die Grundtests habe ich von hier: <http://ubuntuforums.org/showthread.php?t=1094204>

{% codeblock Grundtests %}
$ sudo -s
# ifconfig wlan0 up
# iwlist scan
wlan0     Scan completed :
          Cell 01 - Address: 00:3f:c6:3c:dd:a2
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=37/70  Signal level=-73 dBm  
                    Encryption key:on
                    ESSID:"SiegfriedUndRoy"
...
{% endcodeblock %}

## Konfiguration als WLAN-Client

Die Konfiguration habe ich hierher:
<http://ubuntuforums.org/showthread.php?t=2007475>.
Sie ist gegenüber der Vorlage leicht abgewandelt.

{% codeblock /etc/network/interfaces %}
...
auto wlan0
iface wlan0 inet dhcp
  wpa-ssid SiegfriedUndRoy
  wpa-psk  SharpTiger
{% endcodeblock %}

Hierbei muß nach "wpa-ssid" der Name des zu verwendenden Funknetzwerkes
eingetragen werden und bei "wpa-psk" das dabei zu verwendende Kennwort.
Bevor Fragen aufkommen: "SiegfriedUndRoy" und "SharpTiger" sind erfundene
Werte.

Nun muß nur noch das WLAN-Interface aktiviert werden.

{% codeblock WLAN-Interface aktivieren lang:sh %}
# ifdown wlan0 # Fehlermeldung ignorieren
# ifup wlan0   # Hier darf keine Fehlermeldung erscheinen
ssh stop/waiting
ssh start/running, process 1202
# ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:3f:c6:3c:dd:a2
          inet addr:192.168.178.27  Bcast:192.168.178.255  Mask:255.255.255.0
          inet6 addr: fe80::215:afff:fe88:ab6d/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:696 errors:0 dropped:0 overruns:0 frame:0
          TX packets:496 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:526709 (526.7 KB)  TX bytes:66404 (66.4 KB)
{% endcodeblock %}

Wichtig ist, dass bei "inet addr:" eine IP-Adresse ähnlich der bei
mir angezeigten 192.168.178.27 steht. Wie's aussieht funktioniert's schon!

## Konfiguration als Access-Point

Grob gehe ich nach dieser Anleitung vor: <http://wiki.ubuntuusers.de/WLAN_Router>

### Zusatzpakete installieren

{% codeblock Zusatzpakete installieren lang:sh %}
$ sudo apt-get install -y hostapd dnsmasq
Paketlisten werden gelesen... Fertig
Abhängigkeitsbaum wird aufgebaut       
Statusinformationen werden eingelesen... Fertig
Die folgenden Pakete wurden automatisch installiert und werden nicht mehr benötigt:
  crda wireless-regdb
Verwenden Sie »apt-get autoremove«, um sie zu entfernen.
Die folgenden zusätzlichen Pakete werden installiert:
  dnsmasq-base libnetfilter-conntrack3
Die folgenden NEUEN Pakete werden installiert:
  dnsmasq dnsmasq-base hostapd libnetfilter-conntrack3
...
hostapd (1:0.7.3-4ubuntu1) wird eingerichtet ...
Trigger für libc-bin werden verarbeitet ...
ldconfig deferred processing now taking place
{% endcodeblock %}

### Konfiguration von hostapd

Zunächst muß die Datei /etc/default/hostapd
wie folgt modifiziert werden:

{% codeblock /etc/default/hostapd lang:diff %}
# diff -u /etc/default/hostapd.orig /etc/default/hostapd
--- hostapd.orig	2013-06-14 13:26:20.390584872 +0200
+++ hostapd	2013-06-14 13:27:14.698854220 +0200
@@ -7,7 +7,8 @@
 # file and hostapd will be started during system boot. An example configuration
 # file can be found at /usr/share/doc/hostapd/examples/hostapd.conf.gz
 #
-#DAEMON_CONF=""
+DAEMON_CONF="/etc/hostapd.conf"
+RUN_DAEMON=yes
 
 # Additional daemon options to be appended to hostapd command:-
 # 	-d   show more debug messages (-dd for even more)
{% endcodeblock %}

Dann brauchen wir zusätzlich noch die Konfigurationsdatei
/etc/hostapd.conf. Das Grundgerüst habe ich von hier:
<http://wiki.ubuntuusers.de/WLAN_Router>

{% codeblock /etc/hostapd.conf lang:text %}
# Schnittstelle und Treiber
interface=wlan0
driver=nl80211

# WLAN-Konfiguration
ssid=HaeberleUndPfleiderer
channel=1

# ESSID sichtbar
ignore_broadcast_ssid=0

# Ländereinstellungen
country_code=DE
ieee80211d=1

# Übertragungsmodus
hw_mode=g

# Optionale Einstellungen
# supported_rates=10 20 55 110 60 90 120 180 240 360 480 540

# Draft-N Modus aktivieren / optional nur für entsprechende Karten
# ieee80211n=1

# Übertragungsmodus / Bandbreite 40MHz
# ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40]

# Beacons
beacon_int=100
dtim_period=2

# MAC-Authentifizierung
macaddr_acl=0

# max. Anzahl der Clients
max_num_sta=20

# Größe der Datenpakete/Begrenzung
rts_threshold=2347
fragm_threshold=2346

# hostapd Log Einstellungen
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2

# temporäre Konfigurationsdateien
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0

# Authentifizierungsoptionen 
auth_algs=3

# wmm-Funktionalität
wmm_enabled=0

# Verschlüsselung / hier rein WPA2
wpa=2
rsn_preauth=1
rsn_preauth_interfaces=wlan0
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP

# Schlüsselintervalle / Standardkonfiguration
wpa_group_rekey=600
wpa_ptk_rekey=600
wpa_gmk_rekey=86400

# Zugangsschlüssel (PSK) / hier in Klartext (ASCII)
wpa_passphrase=ScharfesTigerle
{% endcodeblock %}

### Konfiguration der Netzwerkschnittstelle

{% codeblock /etc/network/interfaces %}
...
auto wlan0
iface wlan0 inet static
  address 192.168.3.1
  netmask 255.255.255.0
  broadcast 192.168.3.255

# hostap und dnsmasq neu starten
up /etc/init.d/hostapd restart
up /etc/init.d/dnsmasq restart
{% endcodeblock %}

### Konfiguration von dnsmasq

{% codeblock /etc/dnsmasq.conf lang:diff %}
# diff -u /etc/dnsmasq.conf.orig /etc/dnsmasq.conf
--- /etc/dnsmasq.conf.orig	2013-06-14 13:57:34.856639712 +0200
+++ /etc/dnsmasq.conf	2013-06-14 13:58:18.400855636 +0200
@@ -142,7 +142,7 @@
 # a lease time. If you have more than one network, you will need to
 # repeat this for each network on which you want to supply DHCP
 # service.
-#dhcp-range=192.168.0.50,192.168.0.150,12h
+dhcp-range=192.168.3.50,192.168.3.150,12h
 
 # This is an example of a DHCP range where the netmask is given. This
 # is needed for networks we reach the dnsmasq DHCP server via a relay
{% endcodeblock %}

### Test

Nach der Konfiguration erfolgt ein Neustart mit `sudo reboot`. Danach
kann man sich am WLAN "HaeberleUndPfleiderer" mit
dem Kennwort "ScharfesTigerle" anmelden.

* IP-Adresse: `ifconfig wlan0` - 192.168.3.115
* SSH-Zugriff: `ssh 192.168.3.1` - klappt
