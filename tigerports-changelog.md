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