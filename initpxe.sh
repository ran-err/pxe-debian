#!/bin/bash
apt install -y isc-dhcp-server tftpd-hpa
fileserver='http://192.168.56.1:8000/pxefiles'
mkdir pxe/
cd pxe/
wget --no-check-certificate https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz
tar -zxf syslinux-6.03.tar.gz
wget https://mirrors.ustc.edu.cn/debian/dists/bullseye/main/installer-amd64/current/images/netboot/netboot.tar.gz
mkdir netboot
tar -zxf netboot.tar.gz -C netboot/
mkdir -p /srv/tftp/lib/
mkdir -p /srv/tftp/pxelinux.cfg/
mkdir -p /srv/www/debian11/
cp syslinux-6.03/bios/com32/elflink/ldlinux/ldlinux.c32 /srv/tftp/
cp syslinux-6.03/bios/com32/libutil/libutil.c32 /srv/tftp/lib/
cp syslinux-6.03/bios/com32/menu/menu.c32 /srv/tftp/lib/
cp syslinux-6.03/bios/core/lpxelinux.0 /srv/tftp/
cp netboot/version.info /srv/www/debian11/
cp netboot/debian-installer/amd64/initrd.gz /srv/www/debian11/
cp netboot/debian-installer/amd64/linux /srv/www/debian11/
wget -P /srv/tftp/pxelinux.cfg/ ${fileserver}/default
wget -P /srv/www/ ${fileserver}/hosts
wget -P /srv/www/ ${fileserver}/interfaces
wget -P /srv/www/ ${fileserver}/preseed-vm-20220501.cfg
wget -P /srv/www/ ${fileserver}/uuids
sed -i 's/INTERFACESv4=""/INTERFACESv4="enp0s3"/' /etc/default/isc-dhcp-server
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$(date +%Y%m%d%H%M%S).$(whoami)
wget -P /etc/dhcp/ ${fileserver}/dhcpd.conf
systemctl restart isc-dhcp-server tftpd-hpa
