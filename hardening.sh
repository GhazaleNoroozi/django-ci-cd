#! /bin/bash

DOMAIN=ghazalehnoroozi.com
SSH_PORT=1245
BACK_DIR=/opt/backup/file_$NOW

if [-z $BAC_DIR]; then
  echo "It already exists"
else
  mkdir -p $BAC_DIR
fi
apt update && apt upgrade -y  #update the system, it has security patches that needs to be updated at all times
apt install curl vim fail2ban #put the person who tries multiple time in jail
# Disable and mask ufw
systemctl stop ufw
systemctl disable ufw
systemctl mask ufw
# Change SSH port for fail2ban
cp /etc/fail2ban/fail2ban.conf etc/fail2ban/fail2ban.local
# You should enable this file too I think
sed -i 's/ssh port/ ssh port=''$SSH_PORT/g' /etc/fail2ban/fail2ban.local
systemctl restart fail2ban
systemctl enable fail2ban
fail2ban-client status 
