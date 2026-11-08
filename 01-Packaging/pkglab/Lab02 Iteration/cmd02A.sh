#!/usr/bin/bash
mkdir -p ~/pkglab/build && cd ~/pkglab/build
mkpkg() {
  local v=$1 d=pkglab_$1 s
  rm -rf "$d"; mkdir -p "$d/DEBIAN" "$d/usr/bin" "$d/etc/pkglab"
  cat > "$d/DEBIAN/control" <<EOF
Package: pkglab
Version: $v
Architecture: all
Maintainer: Lab <pkglab@test.test>
Depends: cowsay
Description: packaging lab
 Prints every maintainer-script call dpkg makes.
EOF
  echo /etc/pkglab/pkglab.conf > "$d/DEBIAN/conffiles"
  printf '%s\n' "$2" > "$d/etc/pkglab/pkglab.conf"
  printf '#!/bin/sh\nexec /usr/games/cowsay "pkglab %s"\n' "$v" > "$d/usr/bin/pkglab"
  for s in preinst postinst prerm postrm; do
    printf '#!/bin/sh\nset -e\necho "[trace] $0 $*"\n' > "$d/DEBIAN/$s"
  done
  chmod 0755 "$d"/DEBIAN/*inst "$d"/DEBIAN/*rm "$d/usr/bin/pkglab"
  dpkg-deb --build --root-owner-group "$d" .
}
mkpkg 1.0-1 'mode=strict'
mkpkg 1.1-1 'mode=strict
log=verbose'