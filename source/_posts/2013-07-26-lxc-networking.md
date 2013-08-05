---
layout: post
author: Uli Heller
published: true
title: "LXC: Probleme bei der Initialisierung des Netzwerkes"
date: 2013-07-26 15:00
#updated: 2013-06-10 17:30
comments: true
categories: 
- Linux
- Ubuntu
- Precise
- Lxc
---

Seit einiger Zeit verwende ich LXC als Ergänzung zu VirtualBox.
Bislang läuft das weitgehend problemlos.
Merkwürdigerweise habe einige LXC-Container seit heute ein
Problem beim Start: Es dauert endlos, bis der Login-Prompt erscheint
und das Netzwerk funktioniert nicht. Betroffen sind auch Container,
die früher anstandslos gelaufen sind.

<!-- more -->

## Logs

### Host: /var/Log/syslog

{% codeblock Host:/var/log/syslog %}
Jul 26 13:12:53 uli-hp-ssd dnsmasq-dhcp[1571]: DHCPDISCOVER(lxcbr0) 00:16:3e:84:7a:82 
Jul 26 13:12:53 uli-hp-ssd dnsmasq-dhcp[1571]: DHCPOFFER(lxcbr0) 10.0.3.14 00:16:3e:84:7a:82 
Jul 26 13:13:13 uli-hp-ssd dnsmasq-dhcp[1571]: DHCPDISCOVER(lxcbr0) 00:16:3e:84:7a:82 
Jul 26 13:13:13 uli-hp-ssd dnsmasq-dhcp[1571]: DHCPOFFER(lxcbr0) 10.0.3.14 00:16:3e:84:7a:82 
Jul 26 13:13:24 uli-hp-ssd dnsmasq-dhcp[1571]: DHCPDISCOVER(lxcbr0) 00:16:3e:84:7a:82 
Jul 26 13:13:24 uli-hp-ssd dnsmasq-dhcp[1571]: DHCPOFFER(lxcbr0) 10.0.3.14 00:16:3e:84:7a:82 
Jul 26 13:13:35 uli-hp-ssd dnsmasq-dhcp[1571]: DHCPDISCOVER(lxcbr0) 00:16:3e:84:7a:82 
Jul 26 13:13:35 uli-hp-ssd dnsmasq-dhcp[1571]: DHCPOFFER(lxcbr0) 10.0.3.14 00:16:3e:84:7a:82 
Jul 26 13:13:53 uli-hp-ssd dnsmasq-dhcp[1571]: DHCPDISCOVER(lxcbr0) 00:16:3e:84:7a:82 
{% endcodeblock %}


### Container: /var/log/syslog

{% codeblock Container:/var/log/syslog %}
Jul 26 11:12:53 localhost dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 17
Jul 26 11:12:53 localhost dhclient: 5 bad udp checksums in 5 packets
Jul 26 11:13:10 localhost dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 14
Jul 26 11:13:24 localhost dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 11
Jul 26 11:13:35 localhost dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 15
Jul 26 11:13:50 localhost dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 11
Jul 26 11:14:01 localhost dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 10
Jul 26 11:14:01 localhost dhclient: 5 bad udp checksums in 5 packets
Jul 26 11:14:11 localhost dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 15
Jul 26 11:14:26 localhost dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port
{% endcodeblock %}

## Abhilfe

### Temporäre Abhilfe

Abhilfe schafft die Ausführung vom nachfolgenden Befehl auf dem Host:

```
sudo iptables -A POSTROUTING -t mangle -p udp --dport bootpc -j CHECKSUM --checksum-fill
```

Die Abhilfe ist hier beschrieben: <https://bugs.launchpad.net/ubuntu/+source/isc-dhcp/+bug/930962/comments/14>

### Dauerhafte Abhilfe

Eine dauerhafte Abhilfe schafft die Aktualisierung des Paketes
"isc-dhcp-client" auf Version 4.1.ESV-R4-0ubuntu5.8 oder neuer.
Das geht ganz normal mit `apt-get update; apt-get upgrade`.
Ich hatte zuvor 4.1.ESV-R4-0ubuntu5.5 im Container.

## Nachtrag: Ursache

Das Problem wurde ziemlich sicher verursacht durch den Einsatz von
einem 3.10-er Kernel auf dem Host. Nach dem "Runterschalten" auf 3.8
laufen die Container auch wieder ohne Aktualisierung von
"isc-dhcp-client".

