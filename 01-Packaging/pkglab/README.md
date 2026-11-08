<h1 align="center"> <span style="color:green">The Package Lab or pkglab</span></h1>

Please use a dedicated directory like I did or else there will be a mess, trust me.

```bash
ubuntu@UbuntuServer:~$ mkdir -p ~/pkglab && cd ~/pkglab
ubuntu@UbuntuServer:~/pkglab$ 
```

So, here is the whole roadmap, there is two part:
1. Lab dirs
2. pkglab.zip

## 01. Lab dirs

|**Serial**|**Lab Name**|**Objective**|
|--------|---------|----|
|01|Dissect|Breakdown a real package and see the internal structure|
|02|Iteration|Build, break, fix, upgrade and purge my own package|
|03|Trust Chain|See the integrity chain, independent of apt|
|04|Red-Team Auditor|Audit apt and dpkg the way an attacker would use them|
|05|Core Approach|Rebuild pkglab as a proper source package|

## 02. pkglab.zip

This is the folder where I did the package dissect, whole interation, observing the trust chain, auditing like hacker and creating the package in debian way (not the toy way).

The password for the zip archive: <span style="color:red">anon3605</span>
```
dpkglab
├── build
│   ├── pkglab_1.0-1
│   │   ├── DEBIAN
│   │   │   ├── conffiles
│   │   │   ├── control
│   │   │   ├── postinst
│   │   │   ├── postrm
│   │   │   ├── preinst
│   │   │   └── prerm
│   │   ├── etc/pkglab/pkglab.conf
│   │   └── usr/bin/pkglab
│   ├── pkglab_1.0-1_all.deb
│   ├── pkglab_1.1-1/                           (same layout as 1.0-1)
│   └── pkglab_1.1-1_all.deb
├── chain
│   ├── gpgv.out
│   ├── Packages
│   ├── Packages.xz
│   ├── passwd_4.13+dfsg1-4ubuntu3.2_amd64.deb
│   ├── passwd_4.13+dfsg1-4ubuntu3_amd64.deb
│   ├── passwd.stanza
│   ├── Release
│   └── Release.gpg
├── iputils-ping_3%3a20240117-1ubuntu0.1_amd64.deb
├── passwd_1%3a4.13+dfsg1-4ubuntu3.2_amd64.deb
├── ping-ctl
│   ├── control
│   ├── md5sums
│   └── postinst
├── src
│   ├── pkglab-2.0
│   │   ├── debian
│   │   │   ├── changelog
│   │   │   ├── control
│   │   │   ├── copyright
│   │   │   ├── install
│   │   │   ├── man/pkglab.1
│   │   │   ├── rules
│   │   │   └── source/format
│   │   ├── pkglab
│   │   └── pkglab.conf
│   ├── pkglab_2.0_all.deb
│   ├── pkglab_2.0_amd64.buildinfo
│   ├── pkglab_2.0_amd64.changes
│   ├── pkglab_2.0.dsc
│   └── pkglab_2.0.tar.xz
└── x                                           (passwd, extracted with dpkg-deb -R)
    ├── DEBIAN
    │   ├── conffiles
    │   ├── control
    │   ├── md5sums
    │   ├── postinst
    │   ├── postrm
    │   ├── preinst
    │   └── prerm
    ├── etc
    │   ├── default/useradd
    │   └── pam.d/ (chfn, chpasswd, chsh, newusers, passwd)
    └── usr
        ├── bin/                                (all six setuid/setgid: chage, chfn, chsh, expiry, gpasswd, passwd)
        ├── lib/tmpfiles.d/passwd.conf
        ├── sbin/                               (21 entries: useradd, usermod, groupadd, vipw, …)
        └── share/                              (docs, a lintian override, man pages in English + 18 locales)
```


Inspect it as much as you want.
I know the names are poetic for the labs, right? RIGHT? You should agree on that.

I hope this small intro will help, so?

Happy Packaging.

... I hope?

*Thank You for Learning.*\
*Md. Arafat Sarkar*\