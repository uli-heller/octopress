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

Ich verwende Thunderbird zusammen mit Truecrypt. Ich habe eine USB-Stick,
auf dem eine Truecrypt-Partition liegt von der dann Thunderbird gestartet
wird.

Erstes Problem: Die Partition wird im "Nur-Lesen"-Modus eingebunden!

{% codeblock Einträge in ./var/log/syslog %}
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


{% codeblock %}
sudo -s
umount /media/truecrypt1
{% endcodeblock %}

Erster Versuch: Ausführung von fsck.vfat

{% codeblock %}
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

{% codeblock %}
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

{% codeblock %}
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

{% codeblock %}
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

{% codeblock %}
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

{% codeblock %}
root@uli-hp-ssd:/var/log# fsck.vfat -a /dev/mapper/truecrypt1 
dosfsck 3.0.12, 29 Oct 2011, FAT32, LFN
There are differences between boot sector and its backup.
Differences: (offset:original/backup)
  65:01/00
  Not automatically fixing this.
/dev/mapper/truecrypt1: 4473 files, 1245896/2436635 clusters
{% endcodeblock %}

{% codeblock %}
mount /dev/mapper/truecrypt1 /media/truecrypt1/
{% endcodeblock %}


Thunderbird

Adressbuch -> OK
prefs.js -> klein
Sicherungskopie: prefs-1.js
