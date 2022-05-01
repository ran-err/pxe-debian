#!/bin/bash
fileserver='http://192.168.56.1:8000'
stamp=$(date +%Y%m%d%H%M%S).$(whoami)
sed -i '/#PermitRootLogin/i PermitRootLogin yes' /etc/ssh/sshd_config
systemctl restart sshd
mv /etc/network/interfaces /etc/network/interfaces.${stamp}
wget -P /etc/network/ ${fileserver}/interfaces
mv /etc/resolv.conf /etc/resolv.conf.${stamp}
wget -P /etc/ ${fileserver}/resolv.conf
ifdown --all
ifup --all
mv /etc/apt/sources.list /etc/apt/sources.list.${stamp}
wget -P /etc/apt/ ${fileserver}/sources.list
apt update
