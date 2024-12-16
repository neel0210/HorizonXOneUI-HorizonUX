#!/system/bin/sh

function grep_prop() {
	local variable_name=$1
	local prop_file=$2
	local args="$#"
	if [ ! "$args" -eq "2" ]; then
		return 1
	fi
	grep "$variable_name" $prop_file | cut -d '=' -f 2 | sed 's/"//g'
}

function restart_audioserver() {
    # Wait for system boot completion and audioserver to boot up
    for i in `seq 1 5`; do
        if [ "`getprop sys.boot_completed`" = "1" ] && [ -n "`getprop init.svc.audioserver`" ]; then
            break
        fi
        sleep 1.3
    done

    # Check if audioserver is running before restarting
    if [ -n "`getprop init.svc.audioserver`" ]; then
        # Restart audioserver if it's running
        setprop ctl.restart audioserver
        sleep 0.2
        if [ "`getprop init.svc.audioserver`" != "running" ]; then
            # Workarounds for older devices where the audioserver hangs
            local pid="`getprop init.svc_debug_pid.audioserver`"
            if [ -n "$pid" ]; then
                kill -HUP $pid 1>/dev/null 2>&1
            fi
            for i in `seq 1 10`; do
                sleep 0.2
                if [ "`getprop init.svc.audioserver`" = "running" ]; then
                    break
                elif [ $i -eq 10 ]; then
                    return 1
                fi
            done
        fi
        return 0
    else
        return 1
    fi
}

function is_boot_completed() {
	if [ "$(getprop sys.boot_completed)" == "1" ]; then
		return 0
	else 
		return 1
	fi
}

function is_bootanimation_exited() {
	if [ "$(getprop service.bootanim.exit)" == "1" ]; then
		return 0
	else 
		return 1
	fi
}

function maybe_set_prop() {
    local prop="$1"
    local contains="$2"
    local value="$3"
    if [[ "$(getprop "$prop")" == *"$contains"* ]]; then
        resetprop "$prop" "$value"
    fi
}

function string_case() {
    local smile="$(echo $1 | tr '[:upper:]' '[:lower:]')"
    local string="$2"
    case $smile in
        --lower*|-l*)
            echo "$string" | tr '[:upper:]' '[:lower:]'
        ;;
        --upper*|-u*)
            echo "$string" | tr '[:lower:]' '[:upper:]'
        ;;
        *)
            echo "$string"
        ;;
    esac
}

function horizon_ishiiimi_logfile() {
    local message="$2"
    local service="$(echo "$1" | string_case -u)"
    if [ -z "${message}" ]; then
        echo " - missing arguments, can't process anything..."
    else
        echo "/ [$(date +%H:%M%p)]-[$(date +%d-%m-%Y)] / $service / ${message} /" >> ${the_logfile}
    fi
}

function maybe_kill_daemons() {
    local daemon_name=$1
    local daemon_pid=$(pidof $daemon_name)
    if [ -z "${daemon_pid}" ]; then
        horizon_ishiiimi_logfile "DAEMON_KILLER" "- The $daemon_name wasn't running or it's removed i guess, well uhh i can't do anything about. Sorry!"
    else
        if ! kill ${daemon_name}; then
            horizon_ishiiimi_logfile "DAEMON_KILLER" "- The $daemon_name can't be killed, well uhh i can't do anything about. Sorry!"
        fi
    fi
}

function dawn() {
    local dir=$1
    local the_fifty_jeez=$(du -h $dir | head -n 1 | cut -c 4-4 | string_case -l)
    if [ "$(echo $the_fifty_jeez | grep -q m)" ] || [ "$(echo $the_fifty_jeez | grep -q g)" ]; then
        return 0
    else
        return 1
    fi
}

function horizon_features() {
    local feature_name="$1"
    local kamg_it="$(grep_prop "$feature_name" "/system/bin/hw/linker_binary")"
    if [[ "$kamg_it" == "available" || "$kamg_it" == "true" ]]; then
        return 0
    else
        return 1
    fi
}

function maybe_nuke_prop() {
    local variable="$@"
    if [[ ! -z "$(command -v resetprop)" && ! -z "$(resetprop $variable)" ]]; then
        if ! resetprop -d $variable; then
            horizon_ishiiimi_logfile "resetprop_services" "Can't remove $variable for some unknown reason..."
        fi
    fi
}

check_reset_prop() {
    local NAME=$1
    local EXPECTED=$2
    local VALUE=$(resetprop $NAME)
    [ -z $VALUE ] || [ $VALUE = $EXPECTED ] || resetprop $NAME $EXPECTED
}

########################################### effectless services #####################################

# let's change the default theme to dark, Thanks to nobletaro for the idea!
if [ "$(settings get secure device_provisioned)" == "0" ]; then
    settings put secure ui_night_mode 2
    cmd uimode night yes
fi

# gms doze crap 
horizon_ishiiimi_logfile "GMSDoze" "Tweaking gms..."
horizon_ishiiimi_logfile "GMSDoze" "The logs of this commands can be seen below:"
{
    # Disable collective device administrators for all users
    for U in $(ls /data/user); do
        for C in "auth.managed.admin.DeviceAdminReceiver" "mdm.receivers.MdmDeviceAdminReceiver"; do
            pm disable --user $U com.google.android.gms/com.google.android.gms.$C
        done
    done
    # The GMS0 variable holds the Google Mobile Services package name
    GMS0="\"com.google.android.gms\""
    STR1="allow-unthrottled-location package=$GMS0"
    STR2="allow-ignore-location-settings package=$GMS0"
    STR3="allow-in-power-save package=$GMS0"
    STR4="allow-in-data-usage-save package=$GMS0"
    # Find all XML files under /data/adb directory (case-insensitive search for .xml files)
    find /data/adb/* -type f -iname "*.xml" -print |
    while IFS= read -r XML; do
        for X in $XML; do
        # If any of the defined strings (STR1, STR2, STR3, STR4) are found in the file,
        # execute the following block
        if grep -qE "$STR1|$STR2|$STR3|$STR4" $X 2>/dev/null; then
            # Use sed to remove the matched strings from the XML file
            # It deletes lines containing any of STR1, STR2, STR3, or STR4
            sed -i "/$STR1/d;/$STR2/d;/$STR3/d;/$STR4/d" $X
        fi
        done
    done
    # Add GMS to battery optimization
    dumpsys deviceidle whitelist com.google.android.gms
} >> ${the_logfile}

########################################### effectless services #####################################

############################################ late_start_services ############################################################

# let's cook an tmp file to save our logs because we have to save things on it
# and after that we have to move it to the /data/horizonux/logs because we
# still have no idea whether the device is freaking encrypted or not. You might say that
# we can plug things but idc, im just gonna f'round with the temp file and fuckin' move
# it to the directory.
if is_boot_completed; then
    the_logfile="/data/horizonux/logs/horizon_ishiiimi_logfile.log"; 
    horizon_ishiiimi_logfile "ishimi" "The ROM decryped the storage, using the $the_logfile file to store logs..."
else
    the_logfile=$(mktemp)
    horizon_ishiiimi_logfile "ishimi" "using the $the_logfile file to store logs because the storage haven't decryped yet!"
fi
dawn "/data/horizonux/logs/" && rm -rf /data/horizonux/logs/*
# we are gonna remove everything inside the dir if uhhh... it takes up an megabyte(s) of space

# let's initialize the resampler thing.
if horizon_features "persist.horizonux.audio.resampler"; then
    horizon_ishiiimi_logfile "horizonux_features_verifier" "The audio resampler is enabled in this build...."
    if is_boot_completed; then
        horizon_ishiiimi_logfile "late_start_service" "Starting HorizonUX resampler..."
        # pixel things that we don't need to f around...
        #for pixel_craps in enable_at_samplerate stopband halflength cutoff_percent tbwcheat; do
            #resetprop --delete ro.audio.resampler.psd.$pixel_craps
        #done
        resetprop ro.audio.resampler.psd.enable_at_samplerate 44100
        resetprop ro.audio.resampler.psd.stopband 194
        resetprop ro.audio.resampler.psd.halflength 520
        resetprop ro.audio.resampler.psd.cutoff_percent 85
        horizon_ishiiimi_logfile "late_start_service" "Restarting audioserver to apply the changes in your device..."
        if restart_audioserver; then
            horizon_ishiiimi_logfile "late_start_service" "audioserver restarted successfully..."
        else 
            horizon_ishiiimi_logfile "late_start_service" "failed to reboot audioserver, the resampler stuffs aren't saved.. sorryyy"
        fi
    fi
fi

if boot_completed; then
    # spoof the device to green state, making it seem like an locked device.
    check_reset_prop "ro.boot.vbmeta.device_state" "locked"
    check_reset_prop "ro.boot.verifiedbootstate" "green"
    check_reset_prop "ro.boot.flash.locked" "1"
    check_reset_prop "ro.boot.veritymode" "enforcing"
    check_reset_prop "ro.boot.warranty_bit" "0"
    check_reset_prop "ro.warranty_bit" "0"
    check_reset_prop "ro.debuggable" "0"
    check_reset_prop "ro.secure" "1"
    check_reset_prop "ro.adb.secure" "1"
    check_reset_prop "ro.build.type" "user"
    check_reset_prop "ro.build.tags" "release-keys"
    check_reset_prop "ro.vendor.boot.warranty_bit" "0"
    check_reset_prop "ro.vendor.warranty_bit" "0"
    check_reset_prop "vendor.boot.vbmeta.device_state" "locked"
    check_reset_prop "vendor.boot.verifiedbootstate" "green"
    check_reset_prop "ro.secureboot.lockstate" "locked"
    # Hide that we booted from recovery when magisk is in recovery mode
    contains_reset_prop "ro.bootmode" "recovery" "unknown"
    contains_reset_prop "ro.boot.bootmode" "recovery" "unknown"
    contains_reset_prop "vendor.boot.bootmode" "recovery" "unknown"
    # nuke these mfs if they have any value
    maybe_nuke_prop persist.log.tag.LSPosed
    maybe_nuke_prop persist.log.tag.LSPosed-Bridge
    maybe_nuke_prop ro.build.selinux
    # start bro board's touch fix commands
    [ "$(grep_prop persist.horizonux.brotherboard.touch_fix)" == "$(string_case --lower "available")" ] && start brotherboard_touch_fix
    # let's try to disable user apps log visibitlity...
    for idkmanwtfdowhateveridcyouarebomblikebeambfrfr in $(pm list packages | cut -d':' -f2); do
        cmd package log-visibility --disable $idkmanwtfdowhateveridcyouarebomblikebeambfrfr || horizon_ishiiimi_logfile "ishimi" "Can't disable logs for this application: ${idkmanwtfdowhateveridcyouarebomblikebeambfrfr}..."
    done
    # fx kernelSU image size lmao
    if [ -f "/data/adb/ksu/modules_update.img" ]; then
        horizon_ishiiimi_logfile "Fixing userdata block size...."
        if [ -z "$(resetprop persist.horizonux.kernelsu_imgfixerrantime)" ]; then
            resetprop persist.horizonux.kernelsu_imgfixerrantime $(date +%U)
        elif [ "$(resetprop persist.horizonux.kernelsu_imgfixerrantime)" == "$(date +%U)" ]; then
            horizon_ishiiimi_logfile "horizonux_kernelsu_fix" "Not touching the kernel image, fam, 'cause it can only get touched in the $(($(date +%U) + 1))th week of this year. So, it ain't running this week—it's already been fixed, no cap."
        elif [ "$(resetprop persist.horizonux.kernelsu_imgfixerrantime)" -ge "$(($(date +%U) + 1))" ]; then
            e2fsck -f /data/adb/ksu/modules_update.img
            resize2fs /data/adb/ksu/modules_update.img 500M
            resetprop persist.horizonux.kernelsu_image_size_fix_ran true
            horizon_ishiiimi_logfile "horizonux_kernelsu_fix" "The kernelSU image has been resized fam! it might fix the issue xD"
        fi
    fi
fi

############################################ late_start_services ############################################################

# let's clear the system logs and exit with '0' because we dont want to f-around things lol
logcat -c
exit 0