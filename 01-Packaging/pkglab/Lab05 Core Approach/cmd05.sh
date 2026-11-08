#!/usr/bin/bash
mkdir -p ~/pkglab/src/pkglab-2.0/debian/source && cd ~/pkglab/src/pkglab-2.0
printf '#!/bin/sh\nexec /usr/games/cowsay "pkglab 2.0"\n' > pkglab && chmod 755 pkglab
echo 'mode=strict' > pkglab.conf
echo '3.0 (native)' > debian/source/format
printf '#!/usr/bin/make -f\n%%:\n\tdh $@\n' > debian/rules && chmod 755 debian/rules
printf 'pkglab usr/bin\npkglab.conf etc/pkglab\n' > debian/install
cat > debian/control <<'EOF'
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
cat > debian/changelog <<EOF
pkglab (2.0) $(. /etc/os-release; echo "$VERSION_CODENAME"); urgency=medium

  * Rebuild as a source package with debhelper.

 -- Lab <pkglab@test.test>  $(date -R)
EOF
dpkg-buildpackage -us -uc && ls ..
dpkg-deb -R ../pkglab_2.0_all.deb ../x2 && ls ../x2/DEBIAN
lintian -i ../pkglab_2.0_*.changes