---
layout: post
author: Uli Heller
published: true
title: "Probleme mit Thunderbird-Profile korrigieren"
date: 2013-10-08 10:00
# updated: 2013-07-20 08:00
comments: true
categories:
- Linux
- Ubuntu
- Precise
- Thunderbird
- Truecrypt
---

Heute war's mal wieder so weit: Thunderbird wollte nicht starten.
Erst meckert er, weil das Profil in Benutzung ist. Später dann erkennt
er das Profil nicht mehr.

<!-- more -->

## Truecrypt

Ich verwende Thunderbird zusammen mit Truecrypt. Ich habe eine USB-Stick.
Auf dem liegt eine Truecrypt-Partition. Von dieser wird Thunderbird gestartet.

### Die Partition wird im "Nur-Lesen"-Modus eingebunden!

{% codeblock Auszug aus ./var/log/syslog %}
Oct  8 08:13:22 uli-hp-ssd kernel: [49292.410648] sd 7:0:0:0: [sdh] Attached SCSI disk
Oct  8 08:13:22 uli-hp-ssd kernel: [49292.754705] FAT-fs (sdh1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
Oct  8 08:13:22 uli-hp-ssd ntfs-3g[9249]: Version 2012.1.15AR.1 external FUSE 28
Oct  8 08:13:22 uli-hp-ssd ntfs-3g[9249]: Mounted /dev/sdh2 (Read-Write, label "SanNTFS", NTFS 3.1)
Oct  8 08:13:22 uli-hp-ssd ntfs-3g[9249]: Cmdline options: rw,nosuid,nodev,uhelper=udisks,uid=1000,gid=1000,dmask=0077,fmask=0177
Oct  8 08:13:22 uli-hp-ssd ntfs-3g[9249]: Mount options: rw,nosuid,nodev,uhelper=udisks,allow_other,nonempty,relatime,default_permissions,fsname=/dev/sdh2,blkdev,blksize=4096
Oct  8 08:13:22 uli-hp-ssd ntfs-3g[9249]: Global ownership and permissions enforced, configuration type 7
Oct  8 08:13:42 uli-hp-ssd kernel: [49312.757964] FAT-fs (dm-8): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
Oct  8 08:14:00 uli-hp-ssd kernel: [49331.213542] FAT-fs (dm-8): error, fat_free_clusters: deleting FAT entry beyond EOF
Oct  8 08:14:00 uli-hp-ssd kernel: [49331.213550] FAT-fs (dm-8): Filesystem has been set read-only
{% endcodeblock %}

### Freigeben der Truecrypt-Partition

Zunächst muß die Truecrypt-Partition ausgehängt werden, damit sie für
Korrekturen frei ist.

{% codeblock Truecrypt-Partition freigeben %}
sudo -s
umount /media/truecrypt1
{% endcodeblock %}

### Fsck ohne Zusatzoptionen

Erster Versuch: Ausführung von fsck.vfat. Leider kein Erfolg,
das Dateisystem wird nicht korrigiert!

{% codeblock fsck ohne Zusatzoptionen %}
# fsck.vfat /dev/mapper/truecrypt1
dosfsck 3.0.12, 29 Oct 2011, FAT32, LFN
There are differences between boot sector and its backup.
Differences: (offset:original/backup)
  65:01/00
1) Copy original to backup
2) Copy backup to original
3) No action
? 3
/thunderbird-uli/TestPilotErrorLog.log
  File size is 527203 bytes, cluster chain length is > 528384 bytes.
  Truncating file to 527203 bytes.
...
/thunderbird-uli/ImapMail/localhost/INBOX
  File size is 270166754 bytes, cluster chain length is 266158080 bytes.
  Truncating file to 266158080 bytes.
Reclaimed 779 unused clusters (3190784 bytes).
Free cluster summary wrong (1189209 vs. really 1190739)
1) Correct
2) Don't correct
? 1
Leaving file system unchanged.
/dev/mapper/truecrypt1: 4473 files, 1245896/2436635 clusters
{% endcodeblock %}

### Fsck mit Option '-a'

Mit der Option '-a' sollte es eigentlich klappen. Leider gibt's am
Ende die Fehlermeldung "Unable to create unique name".

{% codeblock fsck mit Option -a %}
root@uli-hp-ssd:/var/log# fsck.vfat -y /dev/mapper/truecrypt1 
dosfsck 3.0.12, 29 Oct 2011, FAT32, LFN
There are differences between boot sector and its backup.
Differences: (offset:original/backup)
  65:01/00
  Not automatically fixing this.
/thunderbird-uli/TestPilotErrorLog.log
  File size is 527203 bytes, cluster chain length is > 528384 bytes.
  Truncating file to 527203 bytes.
...
/thunderbird-uli/ImapMail/localhost/INBOX
  File size is 270166754 bytes, cluster chain length is 266158080 bytes.
  Truncating file to 266158080 bytes.
Unable to create unique name
{% endcodeblock %}

### Mehrfache Ausführung mit Option '-r'

Als nächstes führe ich fsck.vfat mehrfach mit der Option '-r' aus.
Bis auf die Sache mit dem Boot Sector bestätige ich einfach jede Änderung.
Auffällig: Beim zweiten Durchlauf werden neue Fehler gefunden und korrigiert.
Erst beim dritten Durchlauf gibt es keinen Fehler mehr.

{% codeblock Erster Versuch %}
root@uli-hp-ssd:/var/log# fsck.vfat -r /dev/mapper/truecrypt1 
dosfsck 3.0.12, 29 Oct 2011, FAT32, LFN
There are differences between boot sector and its backup.
Differences: (offset:original/backup)
  65:01/00
1) Copy original to backup
2) Copy backup to original
3) No action
? 3
/thunderbird-uli/TestPilotErrorLog.log
  File size is 527203 bytes, cluster chain length is > 528384 bytes.
  Truncating file to 527203 bytes.
/thunderbird-uli/virtualFolders.dat
...
/thunderbird-uli/ImapMail/localhost/INBOX
  File size is 270166754 bytes, cluster chain length is 266158080 bytes.
  Truncating file to 266158080 bytes.
Reclaimed 779 unused clusters (3190784 bytes).
Free cluster summary wrong (1189209 vs. really 1190739)
1) Correct
2) Don't correct
? 1
Perform changes ? (y/n) y
/dev/mapper/truecrypt1: 4473 files, 1245896/2436635 clusters
{% endcodeblock %}

{% codeblock Zweiter Versuch %}
root@uli-hp-ssd:/var/log# fsck.vfat -r /dev/mapper/truecrypt1 
dosfsck 3.0.12, 29 Oct 2011, FAT32, LFN
There are differences between boot sector and its backup.
Differences: (offset:original/backup)
  65:01/00
1) Copy original to backup
2) Copy backup to original
3) No action
? 3
Reclaimed 750 unused clusters (3072000 bytes).
Perform changes ? (y/n) y
/dev/mapper/truecrypt1: 4473 files, 1245896/2436635 clusters
{% endcodeblock %}

{% codeblock Dritter Versuch %}
root@uli-hp-ssd:/var/log# fsck.vfat -r /dev/mapper/truecrypt1 
dosfsck 3.0.12, 29 Oct 2011, FAT32, LFN
There are differences between boot sector and its backup.
Differences: (offset:original/backup)
  65:01/00
1) Copy original to backup
2) Copy backup to original
3) No action
? 3
/dev/mapper/truecrypt1: 4473 files, 1245896/2436635 clusters
{% endcodeblock %}

### Nochmals: Fsck mit Option '-a'

Schlußtest nochmal mit der Option '-a': Kein Fehler mehr vorhanden!

{% codeblock Nochmals fsck mit '-a'  %}
root@uli-hp-ssd:/var/log# fsck.vfat -a /dev/mapper/truecrypt1 
dosfsck 3.0.12, 29 Oct 2011, FAT32, LFN
There are differences between boot sector and its backup.
Differences: (offset:original/backup)
  65:01/00
  Not automatically fixing this.
/dev/mapper/truecrypt1: 4473 files, 1245896/2436635 clusters
{% endcodeblock %}

### Truecrypt-Partition wieder einbinden

{% codeblock Truecrypt-Partition einbinden %}
mount /dev/mapper/truecrypt1 /media/truecrypt1/
{% endcodeblock %}

... klappt nun im Schreiblese-Modus!

## Thunderbird

Nach den Korrekturen an der Truecrypt-Partition startet Thunderbird
leider nicht mehr richtig: Ich werde aufgefordert, ein neues Konto
anzulegen.

### Sichtung des Adressbuchs

Wenn ich mir direkt das Adressbuch anzeigen lasse, dann sehe ich dort noch
meine Einträge - gut!

### Sichtung der Datei "prefs.js"

In meinem Profilverzeichnis /media/truecrypt1/thunderbird-uli
gibt es eine Datei "prefs.js". Diese sieht allerdings sehr klein aus.
Sie hat nur eine Größe von grob 3KB.

Ich finde noch eine Datei "prefs-1.js" vom Vortag, die hat eine
Größe von grob 60 KB.

### Restaurieren der Datei "prefs.js"

* Thunderbird stoppen
* `cp prefs-1.js prefs.js`
* Thunderbird starten -> klappt, sieht wieder "normal" aus
