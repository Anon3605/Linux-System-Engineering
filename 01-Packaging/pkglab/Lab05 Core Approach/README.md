```bash
ubuntu@UbuntuServer:~/pkglab$ mkdir -p ~/pkglab/src/pkglab-2.0/debian/source
ubuntu@UbuntuServer:~/pkglab$ cd ~/pkglab/src/pkglab-2.0
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ printf '#!/bin/sh\nexec /usr/games/cowsay "pkglab 2.0"\n' > pkglab
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ chmod 755 pkglab
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ echo 'mode=strict' > pkglab.conf
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ echo '3.0 (native)' > debian/source/format
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ printf '#!/usr/bin/make -f\n%%:\n\tdh $@\n' > debian/rules
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ chmod 755 debian/rules
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ printf 'pkglab usr/bin\npkglab.conf etc/pkglab\n' > debian/install
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ cat > debian/control <<'EOF'
Source: pkglab
Section: utils
Priority: optional
Maintainer: Lab <pkglab@test.test>
Build-Depends: debhelper-compat (= 13)
Standards-Version: 4.6.2
Rules-Requires-Root: no

Package: pkglab
Architecture: all
Depends: ${misc:Depends}, cowsay
Description: packaging lab
 Rebuilt the distro way, as a source package.
EOF
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ cat > debian/changelog <<EOF
pkglab (2.0) (./etc/os-release;echo"VERSION_CODENAME"); urgency=medium

  * Rebuild as a source package with debhelper.

 -- Lab <pkglab@test.test>  $(date -R)
EOF          
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ dpkg-buildpackage -us -uc
dpkg-buildpackage: info: source package pkglab
dpkg-buildpackage: info: source version 2.0
dpkg-buildpackage: info: source distribution noble
dpkg-buildpackage: info: source changed by Lab <pkglab@test.test>
dpkg-buildpackage: info: host architecture amd64
 dpkg-source --before-build .
 debian/rules clean
dh clean
   dh_clean
 dpkg-source -b .
dpkg-source: info: using source format '3.0 (native)'
dpkg-source: info: building pkglab in pkglab_2.0.tar.xz
dpkg-source: info: building pkglab in pkglab_2.0.dsc
 debian/rules binary
dh binary
   dh_update_autotools_config
   dh_autoreconf
   create-stamp debian/debhelper-build-stamp
   dh_prep
   dh_auto_install --destdir=debian/pkglab/
   dh_install
   dh_installdocs
   dh_installchangelogs
   dh_perl
   dh_link
   dh_strip_nondeterminism
   dh_compress
   dh_fixperms
   dh_missing
   dh_installdeb
   dh_gencontrol
   dh_md5sums
   dh_builddeb
dpkg-deb: building package 'pkglab' in '../pkglab_2.0_all.deb'.
 dpkg-genbuildinfo -O../pkglab_2.0_amd64.buildinfo
 dpkg-genchanges -O../pkglab_2.0_amd64.changes
dpkg-genchanges: info: including full source code in upload
 dpkg-source --after-build .
dpkg-buildpackage: info: full upload; Debian-native package (full source is included)
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ ls ..
pkglab-2.0          pkglab_2.0_amd64.buildinfo  pkglab_2.0.dsc
pkglab_2.0_all.deb  pkglab_2.0_amd64.changes    pkglab_2.0.tar.xz
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ dpkg-deb -R ../pkglab_2.0_all.deb ../x2
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ ls ../x2/DEBIAN
conffiles  control  md5sums
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ lintian -i ../pkglab_2.0_*.changes
N:
E: pkglab: no-copyright-file
N: 
N:   Each binary package has to include a plain file /usr/share/doc/*pkg*/copyright
N: 
N:   Please refer to Copyright information (Section 12.5) in the Debian Policy Manual for details.
N: 
N:   Visibility: error
N:   Show-Always: no
N:   Check: debian/copyright
N: 
N:
W: pkglab source: no-debian-copyright-in-source
N: 
N:   Every package must include the file /usr/share/doc/*pkg*/copyright. A copy of this file should be in
N:   debian/copyright in the source package.
N: 
N:   Please refer to Copyright information (Section 12.5) in the Debian Policy Manual for details.
N: 
N:   Visibility: warning
N:   Show-Always: no
N:   Check: debian/copyright
N:   Renamed from: no-debian-copyright
N: 
N:
W: pkglab: no-manual-page [usr/bin/pkglab]
N: 
N:   Each binary in /usr/bin, /usr/sbin, /bin, /sbin or /usr/games should have a manual page
N:   
N:   Note that though the man program has the capability to check for several program names in the NAMES section,
N:   each of these programs should have its own manual page (a symbolic link to the appropriate manual page is
N:   sufficient) because other manual page viewers such as xman or tkman don't support this.
N:   
N:   If the name of the manual page differs from the binary by case, man may be able to find it anyway; however, it
N:   is still best practice to match the exact capitalization of the executable in the manual page.
N:   
N:   If the manual pages are provided by another package on which this package depends, Lintian may not be able to
N:   determine that manual pages are available. In this case, after confirming that all binaries do have manual pages
N:   after this package and its dependencies are installed, please add a Lintian override.
N: 
N:   Please refer to Manual pages (Section 12.1) in the Debian Policy Manual for details.
N: 
N:   Visibility: warning
N:   Show-Always: no
N:   Check: documentation/manual
N:   Renamed from: binary-without-manpage
N: 
 2 ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ cd ~/pkglab/src/pkglab-2.0
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ nano debian/copyright
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ mkdir -p debian/man
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ nano debian/man/pkglab.1
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ nano debian/changelog
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ . /etc/os-release && echo "Anon3605"
Anon3605
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ dpkg-buildpackage -us -uc
dpkg-buildpackage: info: source package pkglab
dpkg-buildpackage: info: source version 2.0
dpkg-buildpackage: info: source distribution noble
dpkg-buildpackage: info: source changed by Lab <pkglab@test.test>
dpkg-buildpackage: info: host architecture amd64
 dpkg-source --before-build .
 debian/rules clean
dh clean
   dh_clean
 dpkg-source -b .
dpkg-source: info: using source format '3.0 (native)'
dpkg-source: info: building pkglab in pkglab_2.0.tar.xz
dpkg-source: info: building pkglab in pkglab_2.0.dsc
 debian/rules binary
dh binary
   dh_update_autotools_config
   dh_autoreconf
   create-stamp debian/debhelper-build-stamp
   dh_prep
   dh_auto_install --destdir=debian/pkglab/
   dh_install
   dh_installdocs
   dh_installchangelogs
   dh_perl
   dh_link
   dh_strip_nondeterminism
   dh_compress
   dh_fixperms
   dh_missing
   dh_installdeb
   dh_gencontrol
   dh_md5sums
   dh_builddeb
dpkg-deb: building package 'pkglab' in '../pkglab_2.0_all.deb'.
 dpkg-genbuildinfo -O../pkglab_2.0_amd64.buildinfo
 dpkg-genchanges -O../pkglab_2.0_amd64.changes
dpkg-genchanges: info: including full source code in upload
 dpkg-source --after-build .
dpkg-buildpackage: info: full upload; Debian-native package (full source is included)
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ lintian -i ../pkglab_2.0_*.changes
N:
W: pkglab: no-manual-page [usr/bin/pkglab]
N: 
N:   Each binary in /usr/bin, /usr/sbin, /bin, /sbin or /usr/games should have a manual page
N:   
N:   Note that though the man program has the capability to check for several program names in the NAMES section,
N:   each of these programs should have its own manual page (a symbolic link to the appropriate manual page is
N:   sufficient) because other manual page viewers such as xman or tkman don't support this.
N:   
N:   If the name of the manual page differs from the binary by case, man may be able to find it anyway; however, it
N:   is still best practice to match the exact capitalization of the executable in the manual page.
N:   
N:   If the manual pages are provided by another package on which this package depends, Lintian may not be able to
N:   determine that manual pages are available. In this case, after confirming that all binaries do have manual pages
N:   after this package and its dependencies are installed, please add a Lintian override.
N: 
N:   Please refer to Manual pages (Section 12.1) in the Debian Policy Manual for details.
N: 
N:   Visibility: warning
N:   Show-Always: no
N:   Check: documentation/manual
N:   Renamed from: binary-without-manpage
N: 
ubuntu@UbuntuServer:~/pkglab/src/pkglab-2.0$ 
```