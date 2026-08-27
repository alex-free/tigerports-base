v2.12.04.002 - 8/26/2026

* Fixed bootstrap ppc detection.

* Improved bootstrap rebuild detection so that it will not rebuild only if curl successfully was built (and -f wasn't given, and its not set to false for version bump via selfupdate).

* Bootstrap now extracts tarballs instead of copying extracted source directories. This not only makes diffing this against other macports-base projects easier, but fixes issues related to copying extracted sources after they have been uploaded to git.

v2.12.04.001 - 8/26/2026

* Now at parity with MacPorts v2.12.04, specificially we are at: https://github.com/macports/macports-base/commit/227a37b749dc2991bbaf7c600dd56e46174f8206. This enables a ton of new base features and functionallity, and gets TigerPorts-base up to date with MacPorts-base as of 4/10/2026.

* New bootstrap system has been implemented. It gets Tiger able to connect and fetch software with https up to TLSv1.2, which github and gitlab still support. This means many more distfiles can be downloaded by default, lowering the burden on me keeping up hosting them on tigerports.com. Tigerports.com will still offer distfiles from the http server as backups in case any go down or are missing or if for some reasons it's faster then other mirrors it will be automatically used.

* Selfupdate has been changed to use tigerports.com server rather then macports. It also is aware of and uses the new bootstrap system.

* Further clean up, getting base as close to upstream as possible to make this easier to maintain.

v1.2.1 - 8/16/2026

* Only apply should_add_stdlib for 10.6 or less.

v1.2.0 - 8/16/2026

* Fixed launchagents on Tiger.

* Fixed proc portconfigure::should_add_stdlib {} in src/port1.0/portconfigure for gcc16 and new ppcports style toolchain.

v1.1.9 - 8/7/2026

* Updated toolchains and compilers to match PowerPC ports upstream. Intel is now at parity with PowerPC at gcc16/libgcc16.

v1.1.8 - 8/2/2026

* Update toolchains and compilers.

* Fix get_tar_flags to detect .gz and .bz2, correcting http self update for base fetch.

* Intel toolchain now configured for gcc14/libgcc14. PowerPC is configured for gcc16/libgcc16.

v1.1.7 - 8/1/2026

* Restore build_arch auto-detect.

v1.1.6 - 7/31/2026

* Rebase on tiger_upd PPCPorts-Base branch.