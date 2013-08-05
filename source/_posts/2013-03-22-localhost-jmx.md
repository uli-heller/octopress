---
layout: post
author: Uli Heller
published: true
title: "JMX auf Localhost"
date: 2013-03-22 08:00
comments: true
categories:
- Linux
- Java
- JMX
---

JMX so aktivieren, dass der Zugriff nur via Localhost möglich ist
=================================================================

Im Java-Umfeld gibt es die JMX-Schnittstelle, die u.a. für's Monitoringittels JCONSOLE verwendet werden kann. Für meine eigenen Java-Prozesse ist das schnell erledigt: Einfach den Java-Prozess starten, dann `jconsole` (ohne Zusatzargument). Es wird eine Liste mit allen meinem Java-Prozessen angezeigt und ich kann einfach den gewünschten auswählen. Danach bekomme ich eine Anzeige ähnlich dieser:

{% img /images/java/jconsole.png %}

Dummerweise werden Webanwendungen manchmal mit anderen Benutzern gestartet, die noch dazu recht abgeschottet sind. Da scheitert der vorige Wert für mich - die betreffenden Tomcats erscheinen dann einfach nicht in der Liste. Das ist der Punkt, an dem man gerne die Remote-Schnittstelle über das setzen diverser Java-Properties freischaltet. Dumm dabei: Nun kann netzwerkweit auf die JMX-Schnittstelle zugegriffen werden - sofern man sie nicht zusätzlich abblockt, was auch wieder Aufwand bedeutet.

Ziel: Wir wollen die JMX-Schnittstelle so in Betrieb nehmen, dass nur von "localhost" aus auf sie zugegriffen werden kann!

<!-- more -->

JMX für Netzwerkzugriffe öffnen
-------------------------------

Hier das klassische Vorgehen mittels Java-Properties:

{% codeblock tomcat/bin/setenv.sh %}
CATALINA_OPTS="-Djava.rmi.server.hostname=localhost"
CATALINA_OPTS="-Dcom.sun.management.jmxremote ${CATALINA_OPTS}"
CATALINA_OPTS="-Dcom.sun.management.jmxremote.port=11223 ${CATALINA_OPTS}"
CATALINA_OPTS="-Dcom.sun.management.jmxremote.authenticate=false ${CATALINA_OPTS}"
CATALINA_OPTS="-Dcom.sun.management.jmxremote.ssl=false ${CATALINA_OPTS}"
{% endcodeblock %}

Nachteile:

* Das ist ein Scheunentor - netzwerkweit "jeder" kann nun mittels JMX auf unsere Anwendung zugreifen

* Absichern könnte man's mit Firewall-Regeln, was aber zusätzliche Arbeitslast für die Firewall-Truppe bedeutet

* Oder man aktiviert die Authentifizierung und hängt so eine Art Benutzerverwaltung mit dran - auch doof

Eine Idee ist nun, den JMX-Port nicht netzwerkweit sondern nur über "localhost" erreichbar zu machen. Praktisch bedeutet dies, dass dann nur Leute, die sich auf dem betreffenden Rechner anmelden können, Zugriff auf die JMX-Schnittstelle haben. Die oben aufgeführten Java-Properties bieten leider keine entsprechende Einschränkmöglichkeit, also muß eine andere Lösung her!

JMX über eine eigene RMISocketFactory freigeben
-----------------------------------------------

Die Idee für nachfolgendes Vorgehen stammt von [StackOverflow](http://stackoverflow.com/questions/347056/restricting-jmx-to-localhost). Grob geht's so:

* Eigene RMISocketFactory erstellen und registrieren
* MBeanServer über die Standard-ManagementFactory "holen"
* MBeanServer mit der eigenen RMISocketFactory "verknüpfen" und einen JMXConnectorServer dafür erzeugen und starten

Zusätzlich zu den in der Quelle auf [StackOverflow](http://stackoverflow.com/questions/347056/restricting-jmx-to-localhost) umgesetzten Schritte mußte ich noch das Java-Property "java.rmi.server.hostname" auf "127.0.0.1" setzen. Ohne diesen Zusatzschritt funktioniert später JCONSOLE nicht.

Wenn man das richtig getan hat, dann kann man danach mittels `jconsole localhost:11223` die JCONSOLE starten. "11223" ist dabei die Portnummer, die man bei vorigem Ablauf mit verarbeitet.

Ich habe das ganze noch in ein Servlet verpackt. Nun kann ich durch

* `curl http://localhost-jmx/jmx/start` ... die JMX-Schnittstelle "öffnen"
* `curl http://localhost-jmx/jmx/stop` ... die JMX-Schnittstelle "schließen"

Zur Not geht das auch über einen Browser.

Seitens des Operatings sind keinerlei Eingriffe erforderlich. Auch das lästige Setzen des Java-Properties erübrigt sich.

Den Quelltext zu dem ganzen gibt's auf [GitHub](https://github.com/uli-heller/uli-java-prototypes/tree/master/localhost-jmx)
