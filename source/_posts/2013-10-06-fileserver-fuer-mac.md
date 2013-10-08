
sudo apt-get install netatalk

/etc/default/netatalk editieren
/etc/netatalk/afpd.conf editieren

- -transall -uamlist uams_randnum.so,uams_dhx.so -nosavepassword -advertise_ssh
... war in der Anleitung vorgeschlagen - funktioniert für mich nicht

- -transall -noddp -uamlist uams_dhx_passwd.so,uams_dhx2_passwd.so -nosavepassword  -advertise_ssh
... funktioniert

sudo apt-get install avahi-daemon

/etc/nsswitch editieren

/etc/avahi/services/afpd.serice anlegen

<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">%h</name>
  <service>
    <type>_afpovertcp._tcp</type>
    <port>548</port>
  </service>
  <service>
    <type>_device-info._tcp</type>
    <port>0</port>
    <txt-record>model=Xserve</txt-record>
  </service>
</service-group>

sudo /etc/init.d/avahi-daemon restart

## Benutzer anlegen

    sudo useradd --home /zfsdata/andi \
      --create-home \
      --comment "Andrea Heller" \
      --user-group \
      --password "meinPasswort" \
      andi
    sudo passwd andi
    New password: meinPasswort
    Retype new password: meinPasswort
    passwd: password updated successfully
