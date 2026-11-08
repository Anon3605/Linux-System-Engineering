#!/usr/bin/bash
mkdir -p ~/pkglab/chain && cd ~/pkglab/chain
verify_chain() {                              
  local S=$1 P=$2 A M K want fn sha
  A=$(dpkg --print-architecture)
  case $A in amd64|i386) M=http://archive.ubuntu.com/ubuntu ;; *) M=http://ports.ubuntu.com/ubuntu-ports ;; esac
  K=/usr/share/keyrings/ubuntu-archive-keyring.gpg
  curl -fsS -O "$M/dists/$S/Release" -O "$M/dists/$S/Release.gpg" || return 1
  # link 1
  gpgv --status-fd 1 --keyring "$K" Release.gpg Release > gpgv.out 2>&1
  grep -E 'GOODSIG|VALIDSIG|BADSIG|NO_PUBKEY|EXPKEYSIG' gpgv.out
  grep -q '^\[GNUPG:\] GOODSIG' gpgv.out || { echo 'LINK 1 FAILED'; return 1; }
  # link 2
  want=$(awk -v f="main/binary-$A/Packages.xz" '/^SHA256:/{s=1;next} /^[^ ]/{s=0} s && $3==f {print $1}' Release)
  curl -fsS -o Packages.xz "$M/dists/$S/main/binary-$A/Packages.xz" || return 1
  echo "$want  Packages.xz" | sha256sum -c - || { echo 'LINK 2 FAILED'; return 1; }
  # link 3
  xz -dkf Packages.xz
  sed -n "/^Package: $P\$/,/^\$/p" Packages > "$P.stanza"
  fn=$(awk '/^Filename:/{print $2}' "$P.stanza"); sha=$(awk '/^SHA256:/{print $2}' "$P.stanza")
  [ -n "$fn" ] || { echo "$P not in $S/main"; return 1; }
  curl -fsS -o "${fn##*/}" "$M/$fn" || return 1
  echo "$sha  ${fn##*/}" | sha256sum -c - || { echo 'LINK 3 FAILED'; return 1; }
}
. /etc/os-release
verify_chain "$VERSION_CODENAME" passwd
sed -n '1,/^MD5Sum:/p' Release
gpg --show-keys /usr/share/keyrings/ubuntu-archive-keyring.gpg
apt-cache policy passwd
verify_chain "$VERSION_CODENAME-updates" passwd
sha256sum passwd_*.deb ../passwd_*.deb