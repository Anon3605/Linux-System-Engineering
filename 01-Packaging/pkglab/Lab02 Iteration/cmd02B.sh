#!/usr/bin/bash
sudo dpkg -i pkglab_1.0-1_all.debthem -> fails
dpkg -l pkglab
sudo apt -f install
configures pkglab
pkglab && apt-mark showauto | grep cowsay
echo 'mode=permissive' | sudo tee -a /etc/pkglab/pkglab.conf
sudo dpkg -i pkglab_1.1-1_all.deb
sudo apt remove pkglab
dpkg -l pkglab
ls /etc/pkglab
sudo apt purge pkglab
ls /etc/pkglab
sudo apt autoremove
grep pkglab /var/log/dpkg.log | tail -20; tail -25 /var/log/apt/history.log