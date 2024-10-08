HEX_PATCH() {
    local FILE="$1"
    local FROM="$2"
    local TO="$3"

    if xxd -p "$FILE" | tr -d \\n | tr -d " " | grep -q "$TO"; then
        echo " - the patches were already applied to the file, no need to apply them again.."
        return 0
    fi

    if ! xxd -p "$FILE" | tr -d \\n | tr -d " " | grep -q "$FROM"; then
        echo " - No need to patch the file cuz the file was perfect..."
        return 1
    fi

    echo " - Patching the bluetooth system file..."
    xxd -p "$FILE" | tr -d \\n | tr -d " " | sed "s/$FROM/$TO/" | xxd -r -p > "$FILE.tmp"
	mkdir -p ./patched_resources/system/lib64/
	mv "$FILE.tmp" "./patched_resources/system/lib64/libbluetooth_jni.so"
    echo " - Patched successfully, the file was moved to \"patched_resources/system/lib64/libbluetooth_jni.so\" folder.."
}

if [ ! -f "utilites/switchprop" ]; then
	gcc utilites/switchprop.c -o utilites/compiled_bins/switchprop
	chmod 755 utilites/compiled_bins/switchprop
	export PATH="${PATH}:utilites/compiled_bins/"
fi
printf " - Please enter the path of the system/lib64 folder - "
read SYSTEM_LIB_FOLDER
if [ ! -f "${SYSTEM_LIB_FOLDER}/libbluetooth_jni.so" ]; then
	echo " - the \"libbluetooth_jni.so\" file from the system/lib64 wasn't found, copy and put them in a random directory"
	echo "   and try again.."
	exit 1
fi
HEX_PATCH "$1" "6804003528008052" "2b00001428008052"