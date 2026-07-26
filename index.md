# TigerPorts

Tigerports is not just a fork of MacPorts. It is a recreation of the entire MacPorts infrastructure that is tailored to our favorite OS. TigerPorts provides:

* [Tiger orientated ports tree](https://github.com/alex-free/tigerports-ports) focused on software that works on Tiger.

* [Tiger orientated base](https://github.com/alex-free/tigerports-base), configured in source to use tigerports.com.

* [Tiger orientated infrastructure](https://github.com/alex-free/tigerports-infrastructure), allows hosting tigerports.com on a Debian VPS rather then a Mac like MacPorts has it. This includes numerous improvements to the sync scripts, adds binary package signing management, and includes a setup script to recreate my server.

* [Tarball releases](#downloads) to install TigerPorts from source on your Mac, same as official MacPorts (PKG installer is WIP).

* The [tigerports.com](http://tigerports.com/) rsync server, which syncs with the [Tiger orientated ports tree](https://github.com/alex-free/tigerports-ports) every 15 minutes, exactly like real MacPorts. Any pull requests merged there will be available in no later then a quarter hour to all TigerPorts users via `sudo port selfupdate`. 

* The tigerports.com http server, which serves distfiles and compiled port binaries ([list of binaries](http://tigerports.com/macports/packages)).

* Security is kept the same, just not managed by MacPorts. The ports tree, portindex, and binary packages served directly by tigerports.com are all signed.


| [MacRumors Early Intel Macs Forum Thread](https://forums.macrumors.com/threads/tigerports-com-entire-macports-infrastructure-revived-for-mac-os-x-10-4.2485572) | [MacRumors PowerPC Macs Forum Thread](https://forums.macrumors.com/threads/tigerports-com-entire-macports-infrastructure-revived-for-mac-os-x-10-4.2485567/) |

## Table Of Contents

* [Downloads](#downloads)

* [Usage](#usage)

* [HOW YOU CAN HELP](#how-you-can-help)

* [TODO](#todo)

## Downloads

### v1.1.5 (7/26/2026)

Changes:

* Checks tigerports.com http for release updates

* [TigerPorts-1.1.5.tar.bz2](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.5.tar.bz2) _bzip2 release tarball ([verification signature](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.5.tar.bz2.sig))_

* [TigerPorts-1.1.5.tar.gz](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.5.tar.gz) _gzip release tarball ([verification signature](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.5.tar.gz.sig))_

* [TigerPorts-1.1.5.chk.txt](http://tigerports.com/macports/distfiles/MacPorts/TigerPorts-1.1.5.chk.txt) _cryptographic checksum manifest to verify the integrity of TigerPorts downloads_

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

_Note:_ just like when installing official macports from source, you'll need to either modify your `$PATH` or specify `export PATH=/opt/local/bin:/opt/local/sbin:$PATH` each terminal session to access your installed ports. This should be done automatically in a future update of the tigerports-base package.

## HOW YOU CAN HELP

### BINARY PACKAGES

As you use TigerPorts, you will keep a cache of compiled software binaries at `/opt/local/var/macports/software`. You will also get the distfiles (sources used to build) populated at `/opt/local/var/macports/distfiles`. The goal is for all of these to populated on the tigerports.com server, so please [submit these 2 folders to me](https://forums.macrumors.com/members/alex_free.1207497/) if the software is not yet available as binaries on the tigerports.com server so others can skip building from source!

### BE A USER

Spread the word! Tiger will never die. Report issues, suggest improvements, enjoy it.

## TODO

* Implement PKG installers.

* Possibly fix RELEASE_URL error on `sudo port selfupdate`. This is non-fatal (really a warning) because it just pulls this information from tigerports.com rsync server but looks bad. Theres a few ways this could be done.

* Automatic $PATH setting when building from source (Official MacPorts doesn't do this but we should add it).



