# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# License: see portunload_run.tcl

package provide portunload 1.0

set org.macports.unload [target_new org.macports.unload portunload::unload_main]
target_runtype ${org.macports.unload} always
target_state ${org.macports.unload} no
target_provides ${org.macports.unload} unload 
target_requires ${org.macports.unload} main
target_runpkg ${org.macports.unload} portunload_run

options unload.asroot
<<<<<<< HEAD

set_ui_prefix

proc portunload::unload_main {args} {
    global UI_PREFIX prefix subport sudo_user os.major \
           portutil::autoconf::launchctl_path

    portstartupitem::foreach_startupitem {
        if {$si_install} {
            set path /Library/${si_location}/${si_plist}
        } else {
            set path ${prefix}/etc/${si_location}/${si_plist}
        }
        if {$launchctl_path eq ""} {
            return -code error [format [msgcat::mc "launchctl command was not found by configure"]]
        } elseif {![file exists $path]} {
            return -code error [format [msgcat::mc "Launchd plist %s was not found"] $path]
        } else {
            set skip 0
            if {$si_location eq "LaunchDaemons"} {
                if {[getuid] == 0} {
                    set uid 0
                } else {
                    ui_warn [format [msgcat::mc "Skipping unload of startupitem '%s' for %s, root privileges required"] $si_name $subport]
                    set skip 1
                }
	    # To disable an enabled launch agent on Tiger, it uses CFURLWriteDataAndPropertiesToResource()
            # Which fails unless done as root.
            # launchctl: CFURLWriteDataAndPropertiesToResource(/Library/LaunchAgents/org.freedesktop.dbus-session.plist) failed: -10
            } elseif {$si_location eq "LaunchAgents" && ${os.major} == 8} {
                if {[getuid] == 0} {
                    set uid 0
                } else {
                    ui_warn [format [msgcat::mc "Skipping unload of startupitem '%s' for %s, root privileges required"] $si_name $subport]
                    set skip 1
                }
            } elseif {[getuid] == 0} {
                if {[info exists sudo_user]} {
                    set uid [name_to_uid $sudo_user]
                } else {
                    ui_warn [format [msgcat::mc "Unloading per-user startupitem '%s' for %s as root"] $si_name $subport]
                    set uid 0
                }
            } else {
                set uid [getuid]
            }
            if {!$skip} {
                ui_notice "$UI_PREFIX [format [msgcat::mc "Unloading startupitem '%s' for %s"] $si_name $subport]"
                exec_as_uid $uid {system "$launchctl_path unload -w $path"}
                # Disabling it requires root privileges, but the agent itself is under the regular user context.
                if {$si_location eq "LaunchAgents" && ${os.major} == 8} {
                    set uid [name_to_uid $sudo_user]
                    exec_as_uid $uid {system "$launchctl_path unload $path"}
                }
            }
        }
    }

    return
}
=======
>>>>>>> upstream/master
