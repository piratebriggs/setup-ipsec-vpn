#!/bin/sh

export VPN_USER=$1
export VPN_PASSWORD=$2

# Wait 60 seconds for apt/dpkg lock
sleep 60

wget https://raw.githubusercontent.com/piratebriggs/setup-ipsec-vpn/master/vpnsetup.sh -O vpnsetup.sh && sh vpnsetup.sh
