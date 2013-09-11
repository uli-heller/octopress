---
layout: post
author: Uli Heller
published: true
title: "SMTP ohne SMTP-Daemon"
date: 2013-09-11 08:00
comments: true
categories:
- Linux
- Ubuntu
- SMTP
---

Bei einem Kunden setze ich [Redmine](http://redmine.org) ein.
Es läuft dort auf meinem Klapprechner in einer lokalen VM.
Die Kunden-Infrastruktur "kennt" diese VM nicht.
Dennoch soll Redmine Email-Benachrichtigungen verschicken.
Mit den üblichen Mechanismen geht das nicht, weil die VM nicht
als "sende-berechtigt" vermerkt ist. Aber ich habe ja einen SSH-Login
auf einen Rechner, der Emails versenden kann. Hier die Beschreibung,
wie man Redmine (... oder auf fast jede andere Applikation) dazu bringt,
die Mails über diesen Zwischenrechner zu versenden.

<!-- more -->

## Aktionen innerhalb der Redmine-VM

### SSH-Schlüssel für den Email-Versand erzeugen

### XINETD installieren 

### XINETD konfigurieren

{% codeblock ./etc/xinet.d/smtp %}
service smtp
{
        socket_type     = stream
        protocol        = tcp
        wait            = no
        user            = root
        disable         = no
        server          = /usr/bin/ssh
        server_args     = -q -T -i /root/.ssh/tunnel_key {user}@{email-server}
        groups          = yes
        bind            = 127.0.0.1
}
{% endcodeblock %}

Hierbei müssen diese Ersetzungen vorgenommen werden:

* {user}
* {email-server}

## Aktionen auf dem Email-Server

### Sicherstellen: netcat ist verfügbar

### SSH-Schlüssel eintragen

{% codeblock .ssh/authorized_keys %}
command="netcat -w 1 localhost smtp",no-X11-forwarding,no-agent-forwarding,no-port-forwarding ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDT+uY0OTjsDDnJFxVVapm+w2Sc4NdJU5cQC/KFqSQ0RplDy4vvtBFSjY4ucGErQxEjpeQj2mr1KV0abpnWMZU9HpBzEA2qGObmjSKvLeceVXWoqHjOCzSywmiA18XJ2/pjKz4cCD/DV2QAO32zWRfWhXCU2XlU+dZJa8kDqwL9VS3/Isg5PNr7f9l026vTcdg3zaT0J8M1N3Ag7jILBbZD2JeeXTINqKXn3QEm/IqicLZnDHumzgMHNnurtsbCsmmDS4BySLQxISOOLnb5s7TsdAKwRWnz5uw7JxRlXHPh1t+lgkr5Qcf8LLU2Hqa5Vik11Xm41yJ9c9l2LcaB98CF
{% endcodeblock %}
