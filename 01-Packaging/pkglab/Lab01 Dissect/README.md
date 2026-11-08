```bash
ubuntu@UbuntuServer:~/pkglab$ apt-get download passwd 
Get:1 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 passwd amd64 1:4.13+dfsg1-4ubuntu3.2 [845 kB]
Fetched 845 kB in 1s (1,085 kB/s)
```

```bash
ubuntu@UbuntuServer:~/pkglab$ ls -la passwd_*.deb 
-rw-r--r-- 1 ubuntu ubuntu 844580 Jun 14  2024 passwd_1%3a4.13+dfsg1-4ubuntu3.2_amd64.deb
```

```bash
ubuntu@UbuntuServer:~/pkglab$ ar t passwd_*.deb
debian-binary
control.tar.zst
data.tar.zst
```

```bash
ubuntu@UbuntuServer:~/pkglab$ dpkg-deb -I passwd_*.deb
 new Debian package, version 2.0.
 size 844580 bytes: control archive=7915 bytes.
     111 bytes,     6 lines      conffiles
     799 bytes,    18 lines      control
   19917 bytes,   297 lines      md5sums
    1148 bytes,    40 lines   *  postinst             #!/bin/sh
     182 bytes,     5 lines   *  postrm               #!/bin/sh
     182 bytes,     5 lines   *  preinst              #!/bin/sh
     182 bytes,     5 lines   *  prerm                #!/bin/sh
 Package: passwd
 Source: shadow
 Version: 1:4.13+dfsg1-4ubuntu3.2
 Architecture: amd64
 Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
 Installed-Size: 2419
 Depends: libaudit1 (>= 1:2.2.1), libc6 (>= 2.38), libcrypt1 (>= 1:4.1.0), libpam0g (>= 0.99.7.1), libselinux1 (>= 3.1~), libsemanage2 (>= 2.0.32), libpam-modules
 Recommends: sensible-utils
 Section: admin
 Priority: required
 Multi-Arch: foreign
 Homepage: https://github.com/shadow-maint/shadow
 Description: change and administer password and group data
  This package includes passwd, chsh, chfn, and many other programs to
  maintain password and group data.
  .
  Shadow passwords are supported.  See /usr/share/doc/passwd/README.Debian
 Original-Maintainer: Shadow package maintainers <pkg-shadow-devel@lists.alioth.debian.org>
```

```bash
ubuntu@UbuntuServer:~/pkglab$ dpkg-deb -c passwd_*.deb | awk '$1 ~ /[sS]/'
-rwxr-sr-x root/shadow   72184 2024-05-30 14:52 ./usr/bin/chage
-rwsr-xr-x root/root     72792 2024-05-30 14:52 ./usr/bin/chfn
-rwsr-xr-x root/root     44760 2024-05-30 14:52 ./usr/bin/chsh
-rwxr-sr-x root/shadow   27152 2024-05-30 14:52 ./usr/bin/expiry
-rwsr-xr-x root/root     76248 2024-05-30 14:52 ./usr/bin/gpasswd
-rwsr-xr-x root/root     64152 2024-05-30 14:52 ./usr/bin/passwd
```

```bash
ubuntu@UbuntuServer:~/pkglab$ mkdir x && dpkg-deb -R passwd_*.deb x && ls -l x/DEBIAN
total 44
-rw-r--r-- 1 ubuntu ubuntu   111 May 30  2024 conffiles
-rw-r--r-- 1 ubuntu ubuntu   799 May 30  2024 control
-rw-r--r-- 1 ubuntu ubuntu 19917 May 30  2024 md5sums
-rwxr-xr-x 1 ubuntu ubuntu  1148 May 30  2024 postinst
-rwxr-xr-x 1 ubuntu ubuntu   182 May 30  2024 postrm
-rwxr-xr-x 1 ubuntu ubuntu   182 May 30  2024 preinst
-rwxr-xr-x 1 ubuntu ubuntu   182 May 30  2024 prerm
```

```bash
ubuntu@UbuntuServer:~/pkglab$ for f in x/DEBIAN/*inst x/DEBIAN/*rm; do echo "== f";cat"f"; done 2>/dev/null
== x/DEBIAN/postinst
#!/bin/sh

set -e

case "$1" in
configure)
    if ! getent group shadow | grep -q '^shadow:[^:]*:42'
    then
        groupadd -g 42 shadow || (
                cat <<EOF
Group ID 42 has been allocated for the shadow group.  You have either
used 42 yourself or created a shadow group with a different ID.
Please correct this problem and reconfigure with ``dpkg --configure passwd''.

Note that both user and group IDs in the range 0-99 are globally
allocated by the Debian project and must be the same on every Debian
system.
EOF
                exit 1
        )
    fi
    ;;
esac

# Run shadowconfig only on new installs
[ -z "$2" ] && shadowconfig on

# Automatically added by dh_installtmpfiles/13.14.1ubuntu5
if [ "1"="configure"]||["1" = "abort-upgrade" ] || [ "1"="abort-deconfigure"]||["1" = "abort-remove" ] ; then
    if [ -x "$(command -v systemd-tmpfiles)" ]; then
        systemd-tmpfiles ${DPKG_ROOT:+--root="$DPKG_ROOT"} --create passwd.conf || true
    fi
fi
# End automatically added section
# Automatically added by dh_installdeb/13.14.1ubuntu5
dpkg-maintscript-helper rm_conffile /etc/cron.daily/passwd 1:4.7-2\~ -- "$@"
# End automatically added section


exit 0
== x/DEBIAN/preinst
#!/bin/sh
set -e
# Automatically added by dh_installdeb/13.14.1ubuntu5
dpkg-maintscript-helper rm_conffile /etc/cron.daily/passwd 1:4.7-2\~ -- "$@"
# End automatically added section
== x/DEBIAN/postrm
#!/bin/sh
set -e
# Automatically added by dh_installdeb/13.14.1ubuntu5
dpkg-maintscript-helper rm_conffile /etc/cron.daily/passwd 1:4.7-2\~ -- "$@"
# End automatically added section
== x/DEBIAN/prerm
#!/bin/sh
set -e
# Automatically added by dh_installdeb/13.14.1ubuntu5
dpkg-maintscript-helper rm_conffile /etc/cron.daily/passwd 1:4.7-2\~ -- "$@"
# End automatically added section
```

```bash
ubuntu@UbuntuServer:~/pkglab$ diff <(sort x/DEBIAN/md5sums) <(sort /var/lib/dpkg/info/passwd.md5sums) && echo "db copy matches"
db copy matches
```

```bash
ubuntu@UbuntuServer:~/pkglab$ sed -n '/^Package: passwd$/,/^$/p' /var/lib/dpkg/status 
Package: passwd
Status: install ok installed
Priority: required
Section: admin
Installed-Size: 2419
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Architecture: amd64
Multi-Arch: foreign
Source: shadow
Version: 1:4.13+dfsg1-4ubuntu3.2
Depends: libaudit1 (>= 1:2.2.1), libc6 (>= 2.38), libcrypt1 (>= 1:4.1.0), libpam0g (>= 0.99.7.1), libselinux1 (>= 3.1~), libsemanage2 (>= 2.0.32), libpam-modules
Recommends: sensible-utils
Conffiles:
 /etc/default/useradd e03965d134c26725cbc51a57969da6c9
 /etc/pam.d/chfn 4d466e00a348ba426130664d795e8afa
 /etc/pam.d/chpasswd 9900720564cb4ee98b7da29e2d183cb2
 /etc/pam.d/chsh a6e9b589e90009334ffd030d819290a6
 /etc/pam.d/newusers 1454e29bfa9f2a10836563e76936cea5
 /etc/pam.d/passwd eaf2ad85b5ccd06cceb19a3e75f40c63
Description: change and administer password and group data
 This package includes passwd, chsh, chfn, and many other programs to
 maintain password and group data.
 .
 Shadow passwords are supported.  See /usr/share/doc/passwd/README.Debian
Homepage: https://github.com/shadow-maint/shadow
Original-Maintainer: Shadow package maintainers <pkg-shadow-devel@lists.alioth.debian.org>
```

```bash
ubuntu@UbuntuServer:~/pkglab$ apt-get download iputils-ping
Get:1 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 iputils-ping amd64 3:20240117-1ubuntu0.1 [44.6 kB]
Fetched 44.6 kB in 2s (27.0 kB/s)                   
```

```bash
ubuntu@UbuntuServer:~/pkglab$ ls
iputils-ping_3%3a20240117-1ubuntu0.1_amd64.deb  passwd_1%3a4.13+dfsg1-4ubuntu3.2_amd64.deb  x
```

```bash
ubuntu@UbuntuServer:~/pkglab$ dpkg-deb -e iputils-ping_*.deb ping-ctl
```

```bash
ubuntu@UbuntuServer:~/pkglab$ grep -n -A3 setcap ping-ctl/postinst
8:    if setcap cap_net_raw+ep $PROGRAM; then
9-        chmod u-s $PROGRAM
10-    fi
11-fi

```

```bash
ubuntu@UbuntuServer:~/pkglab$ ls -la
total 888
drwxrwxr-x  4 ubuntu ubuntu   4096 Nov  8 09:04 .
drwxr-x--- 17 ubuntu ubuntu   4096 Nov  8 08:59 ..
-rw-r--r--  1 ubuntu ubuntu  44584 Jul 24  2025 iputils-ping_3%3a20240117-1ubuntu0.1_amd64.deb
-rw-r--r--  1 ubuntu ubuntu 844580 Jun 14  2024 passwd_1%3a4.13+dfsg1-4ubuntu3.2_amd64.deb
drwxr-xr-x  2 ubuntu ubuntu   4096 Jul 24  2025 ping-ctl
drwxr-xr-x  5 ubuntu ubuntu   4096 Nov  8 09:01 x
```