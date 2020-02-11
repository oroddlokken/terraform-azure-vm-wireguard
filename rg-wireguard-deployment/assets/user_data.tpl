#!/usr/bin/env bash

## Install required packages
apt-get -y update
apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg unbound jq

## Install WireGuard
add-apt-repository "ppa:wireguard/wireguard"
apt-get update -y
apt-get upgrade -y
apt-get install -y --no-install-recommends wireguard-dkms wireguard-tools

## Install az
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
apt-get -y update
apt-get -y install azure-cli

# Login in Azure
az login --identity -u ${vm_identity_id}

## Wireguard config
EXT_NIC=$(route | grep '^default' | grep -o '[^ ]*$')

cat > /etc/wireguard/wg0.conf <<- EOF
[Interface]
Address = ${wg_server_address_with_cidr}
PrivateKey = WG_PRIV_KEY
ListenPort = ${wg_server_port}
PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $EXT_NIC -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $EXT_NIC -j MASQUERADE
${peers}
EOF

WG_PRIV_KEY=$(az keyvault secret show --vault-name ${vault_name} --name ${kv_secret_name} | jq -r '.value')
sed -i "s|WG_PRIV_KEY|$WG_PRIV_KEY|g" /etc/wireguard/wg0.conf 

chown -R root:root /etc/wireguard/
chmod -R og-rwx /etc/wireguard/*
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p


## Unbound config
curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache

cat > /etc/unbound/unbound.conf <<- EOF
server: 
num-threads: 4

verbosity: 1

root-hints: "/var/lib/unbound/root.hints"

interface: ${wg_server_address}

max-udp-size: 3072

port: 53
do-ip4: yes
do-udp: yes

access-control: 127.0.0.1 allow
access-control: ${wg_server_network_cidr} allow
access-control: 0.0.0.0/0 refuse

private-address: ${wg_server_network_cidr}

hide-identity: yes
hide-version: yes

harden-glue: yes
harden-dnssec-stripped: yes
harden-referral-path: yes

unwanted-reply-threshold: 10000000

val-log-level: 1

cache-min-ttl: 1800

cache-max-ttl: 14400
prefetch: yes
prefetch-key: yes
EOF


## Firewall config to allow for traffic from clients

ufw allow ssh
ufw allow ${wg_server_port}/udp
ufw allow from ${wg_server_network_cidr} to ${wg_server_address} port 53
ufw --force enable


## Start services

systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service

systemctl enable unbound.service
systemctl restart unbound.service