#!/bin/bash

# script that improves ubuntu (currently 22.04)

# resolving to localhost:
echo "[*] Resolving \"metrics.ubuntu.com\" to localhost"
sleep 1
echo 127.0.0.1 www.metrics.ubuntu.com >>/etc/hosts
echo 127.0.0.1 metrics.ubuntu.com >>/etc/hosts
echo "[*] Resolving \"popcon.ubuntu.com\" to localhost"
echo 127.0.0.1 www.popcon.ubuntu.com >>/etc/hosts
echo 127.0.0.1 popcon.ubuntu.com >>/etc/hosts


# decline telemetry
echo "[*] Declining Ubuntu telemetry..."
sleep 1
ubuntu-report -f send no

# remove telemetry
echo "[*] Removing telemetry..."
sleep 1
apt purge ubuntu-report popularity-contest apport whoopsie apport-symptoms 
apt-mark hold ubuntu-report popularity-contest apport whoopsie apport-symptoms

# delete snaps
#echo "[*] Stopping snaps..."
#sleep 1
#systemctl stop snapd.service
#systemctl stop snapd.socket
#systemctl stop snapd.seeded.service
echo "[*] Disabling snaps..."
sleep 1
systemctl disable snapd.service
systemctl disable snapd.socket
systemctl disable snapd.seeded.service
echo "[*] Removing snap components..."
sleep 1
snap remove firefox
snap remove snap-store
snap remove gtk-common-themes
snap remove gnome-3-38-2004
snap remove core18
snap remove snapd-desktop-integration
echo "[*] Deleting snap cache..."
sleep 1
rm -rf /var/cache/snapd/
apt autoremove -y --purge snapd
rm -rf ~/snap

# stopping firefox from being installed with snaps
echo "[*] no snaps for firefox..."
sleep 1
sudo touch /etc/apt/preferences.d/firefox-no-snap
sudo echo -e "Package: firefox*\nPin: release o=Ubuntu*\nPin-Priority: -1" > /etc/apt/preferences.d/firefox-no-snap
echo "[*] Adding the mozilla team Ubuntu PPA for firefox..."
sleep 1
sudo apt-add -y repository ppa:mozillateam/ppa

echo "[*] reloading and installing firefox..."
sleep 1
apt update && apt install -y firefox


# upgrade apt to nala
echo "[*] Adding nala's repository..."
sleep 1
echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg
echo "[*] Installing nala..."
sleep 1
apt update && apt install nala
echo "[*] Refreshing mirrors..."
sleep 1
sudo nala fetch
echo "[*] Adding useful aliases..."
sleep 1
cat apt2nala.txt >> ~/.bashrc
cat apt2nala.txt >> /root/.bashrc
echo "alias sudo='sudo '" >> ~/.bashrc
echo "alias sudo=' sudo '" >> /root/.bashrc

echo "Alright, all done."



