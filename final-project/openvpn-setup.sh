#!/bin/bash
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh 
chmod +x openvpn-install.sh
export AUTO_INSTALL=y
./openvpn-install.sh