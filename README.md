# Unencrypted L2TP Server Auto Setup Scripts

This is a fork of https://github.com/hwdsl2/setup-ipsec-vpn with the IPSec component removed.

Set up your own Unencrypted L2TP server in just a few minutes, on Ubuntu or Debian. All you need to do is provide your own VPN credentials, and let the scripts handle the rest.

An L2TP tunnel does not encrypt your traffic but will allow you to bypass cgNAT if you are on a LTE connection.

We will use <a href="https://github.com/xelerance/xl2tpd" target="_blank">xl2tpd</a> as the L2TP provider.


#### Table of Contents

- [Quick start](#quick-start)
- [Requirements](#requirements)
- [Installation](#installation)
- [Next steps](#next-steps)
- [Important notes](#important-notes)
- [Upgrade Libreswan](#upgrade-libreswan)
- [Bugs & Questions](#bugs--questions)
- [Uninstallation](#uninstallation)
- [See also](#see-also)
- [License](#license)

## Quick start

First, prepare your Linux server[\*](#quick-start-note) with a fresh install of Ubuntu LTS, Debian or CentOS.

Use this one-liner to set up an IPsec VPN server:

```bash
wget https://raw.githubusercontent.com/piratebriggs/setup-ipsec-vpn/master/vpnsetup.sh -O vpnsetup.sh && sudo sh vpnsetup.sh
```

Your VPN login details will be randomly generated, and displayed on the screen when finished.

For other installation options and how to set up VPN clients, read the sections below.

<a name="quick-start-note"></a>
\* A dedicated server or virtual private server (VPS). OpenVZ VPS is not supported.


## Requirements

A newly created <a href="https://aws.amazon.com/ec2/" target="_blank">Amazon EC2</a> instance, from one of these images:
- <a href="https://cloud-images.ubuntu.com/locator/" target="_blank">Ubuntu 18.04 (Bionic) or 16.04 (Xenial)</a>
- <a href="https://wiki.debian.org/Cloud/AmazonEC2Image" target="_blank">Debian 10 (Buster)</a>[\*](#debian-10-note)<a href="https://wiki.debian.org/Cloud/AmazonEC2Image" target="_blank">, 9 (Stretch) or 8 (Jessie)</a>

Please see <a href="https://blog.ls20.com/ipsec-l2tp-vpn-auto-setup-for-ubuntu-12-04-on-amazon-ec2/#vpnsetup" target="_blank">detailed instructions</a> and <a href="https://aws.amazon.com/ec2/pricing/" target="_blank">EC2 pricing</a>.

**-OR-**

A dedicated server or KVM/Xen-based virtual private server (VPS), freshly installed with one of the above OS. OpenVZ VPS is not supported, users could instead try <a href="https://github.com/Nyr/openvpn-install" target="_blank">OpenVPN</a>.

This also includes Linux VMs in public clouds, such as <a href="https://blog.ls20.com/digitalocean" target="_blank">DigitalOcean</a>, <a href="https://blog.ls20.com/vultr" target="_blank">Vultr</a>, <a href="https://blog.ls20.com/linode" target="_blank">Linode</a>, <a href="https://cloud.google.com/compute/" target="_blank">Google Compute Engine</a>, <a href="https://aws.amazon.com/lightsail/" target="_blank">Amazon Lightsail</a>, <a href="https://azure.microsoft.com" target="_blank">Microsoft Azure</a>, <a href="https://www.ibm.com/cloud/virtual-servers" target="_blank">IBM Cloud</a>, <a href="https://www.ovh.com/world/vps/" target="_blank">OVH</a> and <a href="https://www.rackspace.com" target="_blank">Rackspace</a>.

<a href="azure/README.md" target="_blank"><img src="docs/images/azure-deploy-button.png" alt="Deploy to Azure" /></a> 


:warning: **DO NOT** run these scripts on your PC or Mac! They should only be used on a server!

## Installation

### Ubuntu & Debian

First, update your system with `apt-get update && apt-get dist-upgrade` and reboot. This is optional, but recommended.

To install the VPN, please choose one of the following options:

**Option 1:** Have the script generate random VPN credentials for you (will be displayed when finished):

```bash
wget https://git.io/vpnsetup -O vpnsetup.sh && sudo sh vpnsetup.sh
```

**Option 2:** Edit the script and provide your own VPN credentials:

```bash
wget https://git.io/vpnsetup -O vpnsetup.sh
nano -w vpnsetup.sh
[Replace with your own values: YOUR_IPSEC_PSK, YOUR_USERNAME and YOUR_PASSWORD]
sudo sh vpnsetup.sh
```

**Note:** A secure IPsec PSK should consist of at least 20 random characters.

**Option 3:** Define your VPN credentials as environment variables:

```bash
# All values MUST be placed inside 'single quotes'
# DO NOT use these special characters within values: \ " '
wget https://git.io/vpnsetup -O vpnsetup.sh && sudo \
VPN_USER='your_vpn_username' \
VPN_PASSWORD='your_vpn_password' \
sh vpnsetup.sh
```

**Note:** If unable to download via `wget`, you may also open <a href="vpnsetup.sh" target="_blank">vpnsetup.sh</a> (or <a href="vpnsetup_centos.sh" target="_blank">vpnsetup_centos.sh</a>) and click the **`Raw`** button. Press `Ctrl-A` to select all, `Ctrl-C` to copy, then paste into your favorite editor.

## Next steps

Get your computer or device to use the VPN. Please refer to:

<a href="docs/clients.md" target="_blank">**Configure IPsec/L2TP VPN Clients**</a>

<a href="docs/clients-xauth.md" target="_blank">**Configure IPsec/XAuth ("Cisco IPsec") VPN Clients**</a>

<a href="docs/ikev2-howto.md" target="_blank">**Step-by-Step Guide: How to Set Up IKEv2 VPN**</a>

If you get an error when trying to connect, see <a href="docs/clients.md#troubleshooting" target="_blank">Troubleshooting</a>.

Enjoy your very own VPN! :sparkles::tada::rocket::sparkles:


For servers with an external firewall (e.g. <a href="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html" target="_blank">EC2</a>/<a href="https://cloud.google.com/vpc/docs/firewalls" target="_blank">GCE</a>), open UDP ports 500 and 4500 for the VPN. Aliyun users, see [#433](https://github.com/hwdsl2/setup-ipsec-vpn/issues/433).

If you wish to add, edit or remove VPN user accounts, see <a href="docs/manage-users.md" target="_blank">Manage VPN Users</a>. Helper scripts are included for convenience.

Clients are set to use <a href="https://developers.google.com/speed/public-dns/" target="_blank">Google Public DNS</a> when the VPN is active. If another DNS provider is preferred, replace `8.8.8.8` and `8.8.4.4` in both `/etc/ppp/options.xl2tpd` and `/etc/ipsec.conf`, then reboot your server. Advanced users can define `VPN_DNS_SRV1` and optionally `VPN_DNS_SRV2` when running the VPN setup script.

Using kernel support could improve IPsec/L2TP performance. It is available on Ubuntu 18.04/16.04, Debian 10/9 and CentOS 8/7/6. Ubuntu users: Install `linux-modules-extra-$(uname -r)` (or `linux-image-extra`), then run `service xl2tpd restart`.

To modify the IPTables rules after install, edit `/etc/iptables.rules` and/or `/etc/iptables/rules.v4` (Ubuntu/Debian), or `/etc/sysconfig/iptables` (CentOS/RHEL). Then reboot your server.

When connecting via `IPsec/L2TP`, the VPN server has IP `192.168.42.1` within the VPN subnet `192.168.42.0/24`.

The scripts will backup existing config files before making changes, with `.old-date-time` suffix.


## See also

- <a href="https://github.com/hwdsl2/setup-ipsec-vpn" target="_blank">IPsec VPN Server Auto Setup Scripts</a> - The origin of this fork
- <a href="https://github.com/hwdsl2/docker-ipsec-vpn-server" target="_blank">IPsec VPN Server on Docker</a>
- <a href="https://github.com/trailofbits/algo" target="_blank">Algo VPN</a>
- <a href="https://github.com/StreisandEffect/streisand" target="_blank">Streisand</a>
- <a href="https://github.com/Nyr/openvpn-install" target="_blank">OpenVPN Install</a>

## License

Copyright (C) 2014-2020 <a href="https://www.linkedin.com/in/linsongui" target="_blank">Lin Song</a> <a href="https://www.linkedin.com/in/linsongui" target="_blank"><img src="https://static.licdn.com/scds/common/u/img/webpromo/btn_viewmy_160x25.png" width="160" height="25" border="0" alt="View my profile on LinkedIn"></a>   
Based on <a href="https://github.com/sarfata/voodooprivacy" target="_blank">the work of Thomas Sarlandie</a> (Copyright 2012)

This work is licensed under the <a href="http://creativecommons.org/licenses/by-sa/3.0/" target="_blank">Creative Commons Attribution-ShareAlike 3.0 Unported License</a>  
Attribution required: please include my name in any derivative and let me know how you have improved it!
