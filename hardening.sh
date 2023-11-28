#! /bin/bash

DOMAIN=ghazalehnoroozi.com
SSH_PORT=1245
BACK_DIR=/opt/backup/file_$NOW

if [-z $BAC_DIR]; then
  echo "It already exists"
else
  mkdir -p $BAC_DIR
fi

# Update OS
apt update && apt upgrade -y  #update the system, it has security patches that needs to be updated at all times
# Install tools
apt install -y wget git vim nano bash-completion curl htop iftop jq ncdu unzip net-tools dnsutils \
	atop sudo ntp fail2ban software-properties-common apache2-utils tcpdump telnet axel
# Install docker
which docker || { curl -fsSL https://get.docker.com | bash; }
{
	systemctl enable docker
	systemctl restart docker
	systemctl is-active --quiet docker && echo -e "\e[1m \e[96m docker service: \e[30;48;5;82m \e[5mRunning \e[0m" || echo -e "\e[1m \e[96m docker service: \e[30;48;5;196m \e[5mNot Running \e[0m"
}
# Configure docker
if [ -d $DOCKER_DEST ] ; then
   echo "file exist"
else
	   mkdir -p /etc/systemd/system/docker.service.d/
	      touch /etc/systemd/system/docker.service.d/override.conf
fi   

cat <<EOT > /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --registry-mirror $MIRROR_REGISTRY --log-opt max-size=500m --log-opt max-file=5
EOT
cat /etc/systemd/system/docker.service.d/override.conf
{
	systemctl daemon-reload
	systemctl restart docker
	systemctl is-active --quiet docker && echo -e "\e[1m \e[96m docker service: \e[30;48;5;82m \e[5mRunning \e[0m" || echo -e "\e[1m \e[96m docker service: \e[30;48;5;196m \e[5mNot Running \e[0m"
}
# Install docker-compose
echo -e " \e[30;48;5;56m \e[1m \e[38;5;15mdocker-compose Installation\e[0m" 
which docker-compose || { sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose; chmod +x /usr/local/bin/docker-compose; }

{
docker-compose --version
}
# Docker Services WARNING
docker info | grep WARNING

# How to fix "WARNING: No swap limit support"
cat /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/g' /etc/default/grub
cat /etc/default/grub
sudo update-grub

# Remove unused packages
apt autoremove -y

