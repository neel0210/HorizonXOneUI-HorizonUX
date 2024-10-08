#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

// import these from the lib file
void ___get__system__property(const char *property, bool asInt);
void ___execute__command(const char *command, bool *ignore_child_processes);
void ___check__root__privileges();
void ___make__OpenRecoveryScript();
void ___reboot__device(const char *state);
void ___disable__magisk__module();
// import these from the lib file

int main() {
	___check__root__privileges();
    char IS_DEVICE_SETUP_IS_FINISHED[7];
    strcpy(IS_DEVICE_SETUP_IS_FINISHED, ___get__system__property("persist.sys.setupwizard", "false"));

	// nothing.
    const char *SystemShellCommandsToCompressTheLogs[] = {
		"mkdir -p /cache/HorizonUX_last_logs/",
        "logcat -d >> /cache/HorizonUX_last_logs/HorizonUX/last_boot_attempt_logs.log",
        "cat /dev/kmsg >> /cache/HorizonUX_last_logs/HorizonUX/last_booted_system_kmsg_logs.log",
        "tar -cf /cache/HorizonUX_last_logs/HorizonUX/dropbox.tar '/data/system/dropbox'",
        "tar -cf /cache/HorizonUX_last_logs/HorizonUX/tombstones.tar '/data/tombstones'",
        "tar -cf /cache/HorizonUX_last_logs/HorizonUX/data_log.tar '/data/log'",
        "mkdir -p /cache/HorizonUX_last_logs/HorizonUX/.last_bootloop_logs",
        "tar -cf '/cache/HorizonUX_last_logs/HorizonUX/.last_bootloop_logs/$(date +\"%Y-%m-%d\")/@$(date +\"%I:%M%p\")_bootloop_logger.tar' '/cache/HorizonUX_last_logs/HorizonUX/dropbox.tar /cache/HorizonUX_last_logs/HorizonUX/tombstones.tar /cache/HorizonUX_last_logs/HorizonUX/data_log.tar /cache/HorizonUX_last_logs/HorizonUX/last_booted_system_kmsg_logs.log /cache/HorizonUX_last_logs/HorizonUX/last_boot_attempt_logs.log'"
    };
	
    if (strcmp(IS_DEVICE_SETUP_IS_FINISHED, "FINISH") == 0) {
		if (___get__system__property("sys.system_server.start_count", "true") > 2 || ___get__system__property("sys.rescue_boot_count", "true") > 2) {
			for (int i = 0; i < sizeof(SystemShellCommandsToCompressTheLogs) / sizeof(SystemShellCommandsToCompressTheLogs[0]); i++) {
				___execute__command(SystemShellCommandsToCompressTheLogs[i], "false");
			}
			// let's disable magisk modules;
			___disable__magisk__module();
			___make__OpenRecoveryScript(); // let's make a OpenRecoveryMode config file and reboot the device;
			___reboot__device("recovery");
		}
	}
	else { 
		// if the device is not provisioned.
		___make__OpenRecoveryScript();
		___reboot__device("recovery");
	}
    return 0;
}