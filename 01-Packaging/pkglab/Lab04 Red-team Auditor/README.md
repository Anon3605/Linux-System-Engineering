```bash
ubuntu@UbuntuServer:~/pkglab$ grep -rnE 'Invoke|Pre-Install-Pkgs' /etc/apt/apt.conf.d/
/etc/apt/apt.conf.d/15update-stamp:1:APT::Update::Post-Invoke-Success {"touch /var/lib/apt/periodic/update-success-stamp 2>/dev/null || true";};
/etc/apt/apt.conf.d/50appstream:75:APT::Update::Post-Invoke-Success {
/etc/apt/apt.conf.d/70debconf:3:DPkg::Pre-Install-Pkgs {"/usr/sbin/dpkg-preconfigure --apt || true";};
/etc/apt/apt.conf.d/99needrestart:8:DPkg::Post-Invoke {"test -x /usr/lib/needrestart/apt-pinvoke && /usr/lib/needrestart/apt-pinvoke -m u || true"; };
/etc/apt/apt.conf.d/50command-not-found:14:APT::Update::Post-Invoke-Success {
/etc/apt/apt.conf.d/99update-notifier:1:DPkg::Post-Invoke {"if [ -d /var/lib/update-notifier ]; then touch /var/lib/update-notifier/dpkg-run-stamp; fi; /usr/lib/update-notifier/update-motd-updates-available 2>/dev/null || true";};
/etc/apt/apt.conf.d/99update-notifier:2:APT::Update::Post-Invoke-Success {"/usr/lib/update-notifier/update-motd-updates-available 2>/dev/null || true";};
/etc/apt/apt.conf.d/20packagekit:5:DPkg::Post-Invoke {
/etc/apt/apt.conf.d/20packagekit:10:APT::Update::Post-Invoke-Success {
/etc/apt/apt.conf.d/20dbus:2:APT::Update::Post-Invoke-Success { "[ ! -f /var/run/dbus/system_bus_socket ] || /usr/bin/dbus-send --system --dest=org.debian.apt --type=signal /org/debian/apt org.debian.apt.CacheChanged || true"; };
/etc/apt/apt.conf.d/20apt-esm-hook.conf:1:APT::Update::Pre-Invoke {
```

```bash
ubuntu@UbuntuServer:~/pkglab$ systemctl list-timers 'apt-*' 
NEXT                        LEFT LAST                        PASSED UNIT                    ACTIVATES                
Sun 2026-11-08 21:20:50 UTC  11h Sun 2026-11-08 06:42:30 UTC      - apt-daily.timer         apt-daily.service
Mon 2026-11-09 06:10:11 UTC  20h Sun 2026-11-08 06:42:42 UTC      - apt-daily-upgrade.timer apt-daily-upgrade.service

2 timers listed.
Pass --all to see loaded but inactive timers, too.
```

```bash
ubuntu@UbuntuServer:~/pkglab$ dpkg-divert --list 
diversion of /lib/x86_64-linux-gnu/libhistory.so.8.2 to /lib/x86_64-linux-gnu/libhistory.so.8.2.usr-is-merged by libreadline8t64
diversion of /usr/share/dict/words to /usr/share/dict/words.pre-dictionaries-common by dictionaries-common
diversion of /lib/x86_64-linux-gnu/libreadline.so.8 to /lib/x86_64-linux-gnu/libreadline.so.8.usr-is-merged by libreadline8t64
diversion of /lib/x86_64-linux-gnu/libe2p.so.2 to /lib/x86_64-linux-gnu/libe2p.so.2.usr-is-merged by libext2fs2t64
diversion of /lib to /lib.usr-is-merged by base-files
diversion of /usr/share/vim/vim91/doc/help.txt to /usr/share/vim/vim91/doc/help.txt.vim-tiny by vim-runtime
diversion of /lib/x86_64-linux-gnu/libext2fs.so.2.4 to /lib/x86_64-linux-gnu/libext2fs.so.2.4.usr-is-merged by libext2fs2t64
diversion of /sbin to /sbin.usr-is-merged by base-files
diversion of /lib64/ld-linux-x86-64.so.2 to /lib64/ld-linux-x86-64.so.2.usr-is-merged by libc6
diversion of /lib/x86_64-linux-gnu/libext2fs.so.2 to /lib/x86_64-linux-gnu/libext2fs.so.2.usr-is-merged by libext2fs2t64
diversion of /usr/share/vim/vim91/doc/tags to /usr/share/vim/vim91/doc/tags.vim-tiny by vim-runtime
diversion of /lib/x86_64-linux-gnu/libhistory.so.8 to /lib/x86_64-linux-gnu/libhistory.so.8.usr-is-merged by libreadline8t64
diversion of /lib/x86_64-linux-gnu/libreadline.so.8.2 to /lib/x86_64-linux-gnu/libreadline.so.8.2.usr-is-merged by libreadline8t64
diversion of /lib64 to /lib64.usr-is-merged by base-files
diversion of /lib/x86_64-linux-gnu/libe2p.so.2.3 to /lib/x86_64-linux-gnu/libe2p.so.2.3.usr-is-merged by libext2fs2t64
diversion of /bin to /bin.usr-is-merged by base-files
diversion of /lib32 to /lib32.usr-is-merged by base-files
diversion of /libo32 to /libo32.usr-is-merged by base-files
diversion of /lib/x86_64-linux-gnu/libtirpc.so.3 to /lib/x86_64-linux-gnu/libtirpc.so.3.usr-is-merged by libtirpc3t64
diversion of /lib/x86_64-linux-gnu/libtirpc.so.3.0.0 to /lib/x86_64-linux-gnu/libtirpc.so.3.0.0.usr-is-merged by libtirpc3t64
```

```bash
ubuntu@UbuntuServer:~/pkglab$ grep -n debsig /etc/dpkg/dpkg.cfg
8:# Do not enable debsig-verify by default; since the distribution is not using
9:# embedded signatures, debsig-verify would reject all packages.
10:no-debsig
```

```bash
ubuntu@UbuntuServer:~/pkglab$ ls -l /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/ 2>&1
ls: cannot access '/etc/apt/trusted.gpg': No such file or directory
/etc/apt/trusted.gpg.d/:
total 8
-rw-r--r-- 1 root root 1165 Nov 28  2023 ubuntu-keyring-2012-cdimage.gpg
-rw-r--r-- 1 root root 1167 Nov 28  2023 ubuntu-keyring-2018-archive.gpg
 2 
```

```bash
ubuntu@UbuntuServer:~/pkglab$ grep -rn -i signed-by /etc/apt/sources.list.d/ /etc/apt/sources.list 2>/dev/null
/etc/apt/sources.list.d/ubuntu.sources.curtin.orig:36:Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
/etc/apt/sources.list.d/ubuntu.sources.curtin.orig:44:Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
/etc/apt/sources.list.d/ubuntu.sources:5:Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
/etc/apt/sources.list.d/ubuntu.sources:11:Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
```

```bash
ubuntu@UbuntuServer:~/pkglab$ apt-config dump | grep -i pubkey-algo
APT::Key::Assert-Pubkey-Algo ">=rsa1024,ed25519,ed448,nistp256,nistp384,nistp512,brainpoolP256r1,brainpoolP320r1,brainpoolP384r1,brainpoolP512r1,secp256k1";
APT::Key::Assert-Pubkey-Algo::Next ">=rsa2048,ed25519,ed448,nistp256,nistp384,nistp512";
APT::Key::Assert-Pubkey-Algo::Future ">=rsa3072,ed25519,ed448";
```