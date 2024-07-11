#!/bin/bash
curl -fsS https://as-repository.openvpn.net/as/install.sh -o openvpn-install.sh
chmod +x openvpn-install.sh
echo y | sudo ./openvpn-install.sh &> openvpn-installation.log
rm openvpn-install.sh

PUBLIC_IP=$(curl -s ifconfig.me)

sudo /usr/local/openvpn_as/scripts/sacli --key "host.name" --value "$PUBLIC_IP" ConfigPut

sudo systemctl restart openvpnas
