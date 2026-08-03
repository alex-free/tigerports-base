# TigerPorts

Tigerports is not just a fork of MacPorts. It is a recreation of the entire MacPorts infrastructure that is tailored to our favorite OS. TigerPorts provides:

* [Tiger orientated ports tree](https://github.com/alex-free/tigerports-ports) focused on software that works on Tiger. This is a managed snapshot of my fork of powerpc-ports tigerports branch (which tracks upstream powerpc-ports, and changes are submitted to them as well) merged with the MacPorts Ports tree, creating one unified ports tree for tiger.

* [Tiger orientated base](https://github.com/alex-free/tigerports-base), configured in source to use tigerports.com. This is now a fork of PPCPorts-base tiger_upd branch, with plans for tracking more MacPorts-Base/PPCPorts-Base changes and explicit Intel and PowerPC support.

* [Tiger orientated infrastructure](https://github.com/alex-free/tigerports-infrastructure), allows hosting tigerports.com on a Debian VPS rather then a Mac like MacPorts has it. This includes numerous improvements to the sync scripts, adds binary package signing management, and includes a setup script to recreate my server.

* [Tarball releases](#downloads) to install TigerPorts from source on your Mac, same as official MacPorts (PKG installer is WIP).

* The [tigerports.com](http://tigerports.com/) rsync server, which syncs with the [Tiger orientated ports tree](https://github.com/alex-free/tigerports-ports) every 15 minutes, exactly like real MacPorts. Any pull requests merged there will be available in no later then a quarter hour to all TigerPorts users via `sudo port selfupdate`. 

* The tigerports.com http server, which serves distfiles and compiled port binaries ([list of binaries](http://tigerports.com/macports/packages)).

* Security is kept the same, just not managed by MacPorts. The ports tree, portindex, and binary packages served directly by tigerports.com are all signed.

| [MacRumors Early Intel Macs Forum Thread](https://forums.macrumors.com/threads/tigerports-com-entire-macports-infrastructure-revived-for-mac-os-x-10-4.2485572) | [MacRumors PowerPC Macs Forum Thread](https://forums.macrumors.com/threads/tigerports-com-entire-macports-infrastructure-revived-for-mac-os-x-10-4.2485567/) |

## Table Of Contents

* [Downloads](#downloads)

* [Usage](#usage)

* [TODO](#todo)

## Downloads

### v1.1.8 (8/2/2026)

Changes:

* Update toolchains and compilers.

* Fix get_tar_flags to detect .gz and .bz2, correcting http self update for base fetch.

* Intel toolchain now configured for gcc14/libgcc14. PowerPC is configured for gcc16/libgcc14.

* [TigerPorts-1.1.8.tar.bz2](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.8.tar.bz2) _bzip2 release tarball ([verification signature](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.8.tar.bz2.sig))_

* [TigerPorts-1.1.8.tar.gz](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.8.tar.gz) _gzip release tarball ([verification signature](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.8.tar.gz.sig))_

* [TigerPorts-1.1.8.chk.txt](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.8.chk.txt) _cryptographic checksum manifest to verify the integrity of TigerPorts downloads_

[Previous versions](http://tigerports.com/macports/distfiles/MacPorts)

## Requirements

TigerPorts requires Mac OS X 10.4.11 and Xcode v2.5. For your convenience I host an archive for these Apple downloads here on tigerports.com for direct download on legacy Macs. 

* [MacOSXUpdCombo10.4.11Intel.dmg](http://tigerports.com/apple/MacOSXUpdCombo10.4.11Intel.dmg) (MD5: cc6e64bfe6b00910cdcf60ba2028840d)

* [MacOSXUpdCombo10.4.11PPC.dmg](http://tigerports.com/apple/MacOSXUpdCombo10.4.11PPC.dmg) (MD5: 378b21fbd51471b0fa86129ead81541b)

* [xcode25_8m2558_developerdvd.dmg](http://tigerports.com/apple/xcode25_8m2558_developerdvd.dmg) (MD5: 3bd6c24d8fbbdf9007e15861d173764d)

## Usage

1) Download and extract the latest tarball release.

2) `cd` into the extracted tarball release.

3) `./configure && make && sudo make install`.

4) `export PATH=/opt/local/bin:/opt/local/sbin:$PATH`

_Note:_ just like when installing official MacPorts from source, you'll need to either modify your `$PATH` or specify `export PATH=/opt/local/bin:/opt/local/sbin:$PATH` each terminal session to access your installed ports. This should be done automatically in a future update of the tigerports-base package.


## TODO

* Implement PKG installers.


