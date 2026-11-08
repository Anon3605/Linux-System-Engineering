#!/usr/bin/bash
mkdir -p ~/pkglab && cd ~/pkglab
apt-get download passwd
ls passwd_*.deb
ar t passwd_*.deb
dpkg-deb -I passwd_*.deb
dpkg-deb -c passwd_*.deb | awk '$1 ~ /[sS]/'
mkdir x && dpkg-deb -R passwd_*.deb x && ls -l x/DEBIAN
# Bash Script 01
for f in x/DEBIAN/*inst x/DEBIAN/*rm; do echo "== $f"; cat "$f"; done 2>/dev/null
diff <(sort x/DEBIAN/md5sums) <(sort /var/lib/dpkg/info/passwd.md5sums) && echo "db copy matches"
sed -n '/^Package: passwd$/,/^$/p' /var/lib/dpkg/status
apt-get download iputils-ping && dpkg-deb -e iputils-ping_*.deb ping-ctl
grep -n -A3 setcap ping-ctl/postinst