# Set up environment and directories
export TMPDIR=/dev/tmp
export OUTFD="$2"
export ZIPFILE="$3"
export INSTALLER="$TMPDIR/install"
export IMAGES="${INSTALLER}/"
mkdir -p "$INSTALLER" "$TMPDIR" 2>/dev/null
. ${INSTALLER}/rom.prop
. ${INSTALLER}/util-functions.sh

# Display Header
___print "#########################################################"
___print "   _  _     _   _            _                _   ___  __"
___print " _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \\/ /"
___print "|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / "
___print "|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ "
___print "  |_||_|   |_| |_|\\___/|_|  |_/___\\___/|_| |_|\\___//_/\\_\\"
___print "                                                         "
___print "#########################################################"
___print "Developer : $(___get__rom__prop author) "
___print "Version : v$(___get__rom__prop version) "
___print "Codename : $(___get__rom__prop codename) "
___print "###############################################"
___print " - Installing packages..."
___print "   please wait, it might take longer than usual..."

# Install the images
if ! ___get__rom__prop "THE_DEVICE_HAS_DYNAMIC_PARTITIONS"; then
    for i in $(echo ${SAR_PARTITIONS_TO_FLASH[@]}); do count=$((count + 1)); done
    SAR_PARTS_SIZE=$(( $count - 1 ))
    for ((i = 0; i < $SAR_PARTS_SIZE; i++)); do 
        ___install__the__disk__image "${SAR_PARTITIONS_TO_FLASH[${i}]}_${FORMAT_SPECIFIER}" "${SAR_PARTITIONS_TO_FLASH[${i}]}"
    done
elif ___get__rom__prop "THE_DEVICE_HAS_DYNAMIC_PARTITIONS"; then
    for i in $(echo ${DYNAMIC_SYSTEM_PARTITIONS_TO_FLASH[@]}); do count=$((count + 1)); done
    DYNAMIC_PARTS_SIZE=$(( $count - 1 ))
    for ((i = 0; i < $DYNAMIC_PARTS_SIZE; i++)); do 
        ___install__the__disk__image "${DYNAMIC_SYSTEM_PARTITIONS_TO_FLASH[${i}]}_${FORMAT_SPECIFIER}" "${DYNAMIC_SYSTEM_PARTITIONS_TO_FLASH[${i}]}"
    done
fi

# let's flash the low-level things of the device...
for j in $(echo ${LOW_LEVEL_PARTITIONS_TO_FLASH[@]}); do countone=$((countone + 1)); done
LOW_LEVEL_PARTS_SIZE=$(( $countone - 1 ))
for ((i = 0; i < $SAR_PARTS_SIZE; i++)); do
    ___install__low__level__images "${LOW_LEVEL_PARTITIONS_TO_FLASH[@]}" "${LOW_LEVEL_PARTITIONS_MD5SUMS[@]}"
done

# Recovery script setup
___setup_openrecoveryscript
___print " "
___print " - don't get jumpscared, the device needs to reboot into recovery again for some stuffs"
___print " - if your device doesn't boot then congrats! you fucked your device :D"
___print "   After booting into recovery, just reboot the device...\n"
___print " - rebooting in 5"
for ((i = 4; i >= 1; i--)); do 
    ___print "\t\t${i}"
done
reboot recovery