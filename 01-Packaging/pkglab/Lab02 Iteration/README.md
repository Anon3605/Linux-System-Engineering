```bash
buntu@UbuntuServer:~/pkglab$ mkdir -p ~/pkglab/build && cd ~/pkglab/build
ubuntu@UbuntuServer:~/pkglab/build$ mkpkg()
{                                                                
  local v=$1 d=pkglab_$1 s
  rm -rf "d";mkdir-p"d/DEBIAN" "d/usr/bin""d/etc/pkglab"
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
  printf '%s\n' "2">"d/etc/pkglab/pkglab.conf"
  printf '#!/bin/sh\nexec /usr/games/cowsay "pkglab %s"\n' "v">"d/usr/bin/pkglab"
  for s in preinst postinst prerm postrm; do
    printf '#!/bin/sh\nset -e\necho "[trace] $0 $*"\n' > "$d/DEBIAN/$s"
  done
  chmod 0755 "d"/DEBIAN/*inst"d"/DEBIAN/*rm "$d/usr/bin/pkglab"
  dpkg-deb --build --root-owner-group "$d" .
}
ubuntu@UbuntuServer:~/pkglab/build$ mkpkg 1.0-1 'mode=strict'
dpkg-deb: building package 'pkglab' in './pkglab_1.0-1_all.deb'.
ubuntu@UbuntuServer:~/pkglab/build$ mkpkg 1.1-1 'mode=strict log=verbose'
dpkg-deb: building package 'pkglab' in './pkglab_1.1-1_all.deb'.
ubuntu@UbuntuServer:~/pkglab/build$ sudo dpkg -i pkglab_1.0-1_all.deb
Selecting previously unselected package pkglab.
(Reading database ... 211710 files and directories currently installed.)
Preparing to unpack pkglab_1.0-1_all.deb ...
[trace] /var/lib/dpkg/tmp.ci/preinst install
Unpacking pkglab (1.0-1) ...
dpkg: dependency problems prevent configuration of pkglab:
 pkglab depends on cowsay; however:
  Package cowsay is not installed.

dpkg: error processing package pkglab (--install):
 dependency problems - leaving unconfigured
Errors were encountered while processing:
 pkglab
 1 ubuntu@UbuntuServer:~/pkglab/build$ dpkg -l pkglab
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version      Architecture Description
+++-==============-============-============-=================================
iU  pkglab         1.0-1        all          packaging lab
ubuntu@UbuntuServer:~/pkglab/build$ sudo apt -f install
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Correcting dependencies... Done
The following additional packages will be installed:
  cowsay
Suggested packages:
  filters cowsay-off
The following NEW packages will be installed:
  cowsay
0 upgraded, 1 newly installed, 0 to remove and 69 not upgraded.
1 not fully installed or removed.
Need to get 18.6 kB of archives.
After this operation, 93.2 kB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://archive.ubuntu.com/ubuntu noble/universe amd64 cowsay all 3.03+dfsg2-8 [18.6 kB]
Fetched 18.6 kB in 1s (21.0 kB/s) 
Selecting previously unselected package cowsay.
(Reading database ... 211713 files and directories currently installed.)
Preparing to unpack .../cowsay_3.03+dfsg2-8_all.deb ...
Unpacking cowsay (3.03+dfsg2-8) ...
Setting up cowsay (3.03+dfsg2-8) ...
Setting up pkglab (1.0-1) ...
[trace] /var/lib/dpkg/info/pkglab.postinst configure 
Processing triggers for man-db (2.12.0-4build2) ...
needrestart is being skipped since dpkg has failed
ubuntu@UbuntuServer:~/pkglab/build$ pkglab && apt-mark showauto | grep cowsay echo 'mode=permissive' | sudo tee -a /etc/pkglab/pkglab.conf                                        
 ______________
< pkglab 1.0-1 >
 --------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
grep: echo: No such file or directory
grep: mode=permissive: No such file or directory
ubuntu@UbuntuServer:~/pkglab/build$ sudo dpkg -i pkglab_1.1-1_all.deb
(Reading database ... 211773 files and directories currently installed.)
Preparing to unpack pkglab_1.1-1_all.deb ...
[trace] /var/lib/dpkg/info/pkglab.prerm upgrade 1.1-1
[trace] /var/lib/dpkg/tmp.ci/preinst upgrade 1.0-1 1.1-1
Unpacking pkglab (1.1-1) over (1.0-1) ...
[trace] /var/lib/dpkg/info/pkglab.postrm upgrade 1.1-1
Setting up pkglab (1.1-1) ...
Installing new version of config file /etc/pkglab/pkglab.conf ...
[trace] /var/lib/dpkg/info/pkglab.postinst configure 1.0-1
ubuntu@UbuntuServer:~/pkglab/build$ sudo apt remove pkglab
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following package was automatically installed and is no longer required:
  cowsay
Use 'sudo apt autoremove' to remove it.
The following packages will be REMOVED:
  pkglab
0 upgraded, 0 newly installed, 1 to remove and 69 not upgraded.
After this operation, 0 B of additional disk space will be used.
Do you want to continue? [Y/n] Y
(Reading database ... 211773 files and directories currently installed.)
Removing pkglab (1.1-1) ...
[trace] /var/lib/dpkg/info/pkglab.prerm remove
[trace] /var/lib/dpkg/info/pkglab.postrm remove
Scanning processes...                                                                                                 
Scanning linux images...                                                                                              

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
ubuntu@UbuntuServer:~/pkglab/build$ dpkg -l pkglab
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version      Architecture Description
+++-==============-============-============-=================================
rc  pkglab         1.1-1        all          packaging lab
ubuntu@UbuntuServer:~/pkglab/build$ ls /etc/pkglab
pkglab.conf
ubuntu@UbuntuServer:~/pkglab/build$ sudo apt purge pkglab
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following package was automatically installed and is no longer required:
  cowsay
Use 'sudo apt autoremove' to remove it.
The following packages will be REMOVED:
  pkglab*
0 upgraded, 0 newly installed, 1 to remove and 69 not upgraded.
After this operation, 0 B of additional disk space will be used.
Do you want to continue? [Y/n] Y             
(Reading database ... 211772 files and directories currently installed.)
Purging configuration files for pkglab (1.1-1) ...
[trace] /var/lib/dpkg/info/pkglab.postrm purge
ubuntu@UbuntuServer:~/pkglab/build$ ls /etc/pkglab
ls: cannot access '/etc/pkglab': No such file or directory
 2 ubuntu@UbuntuServer:~/pkglab/build$ sudo apt autoremove
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be REMOVED:
  cowsay
0 upgraded, 0 newly installed, 1 to remove and 69 not upgraded.
After this operation, 93.2 kB disk space will be freed.
Do you want to continue? [Y/n] Y
(Reading database ... 211770 files and directories currently installed.)
Removing cowsay (3.03+dfsg2-8) ...
Processing triggers for man-db (2.12.0-4build2) ...
ubuntu@UbuntuServer:~/pkglab/build$ grep pkglab /var/log/dpkg.log | tail -20; tail -25 /var/log/apt/history.log
2026-11-08 09:14:43 configure pkglab:all 1.0-1 <none>
2026-11-08 09:14:43 status unpacked pkglab:all 1.0-1
2026-11-08 09:14:43 status half-configured pkglab:all 1.0-1
2026-11-08 09:14:43 status installed pkglab:all 1.0-1
2026-11-08 09:15:35 upgrade pkglab:all 1.0-1 1.1-1
2026-11-08 09:15:35 status half-configured pkglab:all 1.0-1
2026-11-08 09:15:35 status unpacked pkglab:all 1.0-1
2026-11-08 09:15:35 status half-installed pkglab:all 1.0-1
2026-11-08 09:15:35 status unpacked pkglab:all 1.1-1
2026-11-08 09:15:36 configure pkglab:all 1.1-1 1.1-1
2026-11-08 09:15:36 status half-configured pkglab:all 1.1-1
2026-11-08 09:15:36 status installed pkglab:all 1.1-1
2026-11-08 09:16:02 status installed pkglab:all 1.1-1
2026-11-08 09:16:02 remove pkglab:all 1.1-1 <none>
2026-11-08 09:16:02 status half-configured pkglab:all 1.1-1
2026-11-08 09:16:02 status half-installed pkglab:all 1.1-1
2026-11-08 09:16:02 status config-files pkglab:all 1.1-1
2026-11-08 09:16:30 purge pkglab:all 1.1-1 <none>
2026-11-08 09:16:30 status config-files pkglab:all 1.1-1
2026-11-08 09:16:30 status not-installed pkglab:all <none>
End-Date: 2026-11-08  09:10:36

Start-Date: 2026-11-08  09:14:43
Commandline: apt -f install
Requested-By: ubuntu (1000)
Install: cowsay:amd64 (3.03+dfsg2-8, automatic)
End-Date: 2026-11-08  09:14:44

Start-Date: 2026-11-08  09:16:02
Commandline: apt remove pkglab
Requested-By: ubuntu (1000)
Remove: pkglab:amd64 (1.1-1)
End-Date: 2026-11-08  09:16:02

Start-Date: 2026-11-08  09:16:30
Commandline: apt purge pkglab
Requested-By: ubuntu (1000)
Purge: pkglab:amd64 ()
End-Date: 2026-11-08  09:16:31

Start-Date: 2026-11-08  09:16:57
Commandline: apt autoremove
Requested-By: ubuntu (1000)
Remove: cowsay:amd64 (3.03+dfsg2-8)
End-Date: 2026-11-08  09:16:58
ubuntu@UbuntuServer:~/pkglab/build$ 
```