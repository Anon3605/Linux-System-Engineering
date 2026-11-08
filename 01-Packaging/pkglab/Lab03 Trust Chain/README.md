```bash
ubuntu@UbuntuServer:~/pkglab/chain$ verify_chain() 
{                              
  local S=1P=2 A M K want fn sha
  A=$(dpkg --print-architecture)
  case $A in amd64|i386) M=http://archive.ubuntu.com/ubuntu ;; *) M=http://ports.ubuntu.com/ubuntu-ports ;; esac
  K=/usr/share/keyrings/ubuntu-archive-keyring.gpg
  curl -fsS -O "M/dists/S/Release" -O "M/dists/S/Release.gpg" || return 1
  # link 1: OpenPGP signature over the exact bytes of Release
  gpgv --status-fd 1 --keyring "$K" Release.gpg Release > gpgv.out 2>&1
  grep -E 'GOODSIG|VALIDSIG|BADSIG|NO_PUBKEY|EXPKEYSIG' gpgv.out
  grep -q '^
GNUPG:
GOODSIG' gpgv.out || { echo 'LINK 1 FAILED'; return 1; }
  # link 2: index hash, as listed in the signed Release
  want=(awk-vf="main/binary-A/Packages.xz" '/^SHA256:/{s=1;next} /^[^ ]/{s=0} s && $3==f {print $1}' Release)
  curl -fsS -o Packages.xz "M/dists/S/main/binary-$A/Packages.xz" || return 1
  echo "$want  Packages.xz" | sha256sum -c - || { echo 'LINK 2 FAILED'; return 1; }
  # link 3: package hash, as listed in the verified index
  xz -dkf Packages.xz
  sed -n "/^Package: $P\$/,/^\$/p" Packages > "$P.stanza"
  fn=$(awk '/^Filename:/{print $2}' "$P.stanza"); sha=$(awk '/^SHA256:/{print $2}' "$P.stanza")
  [ -n "$fn" ] || { echo "$P not in $S/main"; return 1; }
  curl -fsS -o "fn##*/""M/$fn" || return 1
  echo "$sha  ${fn##*/}" | sha256sum -c - || { echo 'LINK 3 FAILED'; return 1; }
}
```

```bash
ubuntu@UbuntuServer:~/pkglab/chain$ . /etc/os-release
```

```bash
ubuntu@UbuntuServer:~/pkglab/chain$ verify_chain "$VERSION_CODENAME" passwd
[GNUPG:] GOODSIG 871920D1991BC93C Ubuntu Archive Automatic Signing Key (2018) <ftpmaster@ubuntu.com>
[GNUPG:] VALIDSIG F6ECB3762474EDA9D21B7022871920D1991BC93C 2024-04-25 1714057881 0 4 0 1 10 00 F6ECB3762474EDA9D21B7022871920D1991BC93C

Packages.xz: OK
passwd_4.13+dfsg1-4ubuntu3_amd64.deb: OK
```

```bash
ubuntu@UbuntuServer:~/pkglab/chain$ 
```

```bash
ubuntu@UbuntuServer:~/pkglab/chain$ sed -n '1,/^MD5Sum:/p' Release 
Origin: Ubuntu
Label: Ubuntu
Suite: noble
Version: 24.04
Codename: noble
Date: Thu, 25 Apr 2024 15:10:33 UTC
Architectures: amd64 arm64 armhf i386 ppc64el riscv64 s390x
Components: main restricted universe multiverse
Description: Ubuntu Noble 24.04
MD5Sum:
```

```bash
ubuntu@UbuntuServer:~/pkglab/chain$ gpg --show-keys /usr/share/keyrings/ubuntu-archive-keyring.gpg 
pub   rsa4096 2012-05-11 [SC]
      790BC7277767219C42C86F933B4FE6ACC0B21F32
uid                      Ubuntu Archive Automatic Signing Key (2012) <ftpmaster@ubuntu.com>

pub   rsa4096 2012-05-11 [SC]
      843938DF228D22F7B3742BC0D94AA3F0EFE21092
uid                      Ubuntu CD Image Automatic Signing Key (2012) <cdimage@ubuntu.com>

pub   rsa4096 2018-09-17 [SC]
      F6ECB3762474EDA9D21B7022871920D1991BC93C
uid                      Ubuntu Archive Automatic Signing Key (2018) <ftpmaster@ubuntu.com>

```

```bash
ubuntu@UbuntuServer:~/pkglab/chain$ apt-cache policy passwd  
passwd:
  Installed: 1:4.13+dfsg1-4ubuntu3.2
  Candidate: 1:4.13+dfsg1-4ubuntu3.2
  Version table:
 *** 1:4.13+dfsg1-4ubuntu3.2 500
        500 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages
        100 /var/lib/dpkg/status
     1:4.13+dfsg1-4ubuntu3 500
        500 http://archive.ubuntu.com/ubuntu noble/main amd64 Packages
```

```bash
ubuntu@UbuntuServer:~/pkglab/chain$ verify_chain "$VERSION_CODENAME-updates" passwd
[GNUPG:] GOODSIG 871920D1991BC93C Ubuntu Archive Automatic Signing Key (2018) <ftpmaster@ubuntu.com>
[GNUPG:] VALIDSIG F6ECB3762474EDA9D21B7022871920D1991BC93C 2026-11-08 1794124226 0 4 0 1 10 00 F6ECB3762474EDA9D21B7022871920D1991BC93C
Packages.xz: OK
passwd_4.13+dfsg1-4ubuntu3.2_amd64.deb: OK
```

```bash
ubuntu@UbuntuServer:~/pkglab/chain$ sha256sum passwd_*.deb ../passwd_*.deb  
139b51228c8065eefa3051f649d8480eb986f1cf629448e49d2eaf9813318412  passwd_4.13+dfsg1-4ubuntu3.2_amd64.deb
48c36fd38b43a074d746d88eb34808fc06129b9a8864a65f869fbf17639c42c9  passwd_4.13+dfsg1-4ubuntu3_amd64.deb
139b51228c8065eefa3051f649d8480eb986f1cf629448e49d2eaf9813318412  ../passwd_1%3a4.13+dfsg1-4ubuntu3.2_amd64.deb
```