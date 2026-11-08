#!/usr/bin/bash
grep -rnE 'Invoke|Pre-Install-Pkgs' /etc/apt/apt.conf.d/
systemctl list-timers 'apt-*'
dpkg-divert --list
grep -n debsig /etc/dpkg/dpkg.cfg
ls -l /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/ 2>&1
grep -rn -i signed-by /etc/apt/sources.list.d/ /etc/apt/sources.list 2>/dev/null
apt-config dump | grep -i pubkey-algo