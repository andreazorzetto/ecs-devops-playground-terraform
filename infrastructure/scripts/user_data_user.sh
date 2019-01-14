#!/bin/bash

# Basic software
yum install -y epel-release
yum install -y curl wget make gcc-c++ git htop vim
yum groupinstall -y 'Development Tools'

# SSH User
echo '${ssh_pass}' | sudo passwd centos --stdin
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# Node and wetty
curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
yum install -y nodejs

npm install -g yarn
npm install -g aye-spy

yarn global add wetty


cat << EOF > /etc/systemd/system/wetty.service
[Unit]
Description=Wetty terminal on Web
After=network.target

[Service]
Type=simple
User=centos
WorkingDirectory=/home/centos
ExecStart=/usr/local/bin/wetty -p 3000 --sshuser centos
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable wetty.service
systemctl start wetty.service