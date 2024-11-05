function main () {
	# switch to the script's directory
	cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" || echo -e "\e[0;31m - Warning! the script can't switch to it's path, but the generated file will get moved to a appropriate folder\e[0;37m"
	
	# wallpapers configuration
	local i 
	local wallpaper_count
	local special_symbol
	local the_homescreen_wallpaper_has_been_set=false
	local the_lockscreen_wallpaper_has_been_set=false
	local wallpaper_count_additional_int=00
	
	# the main stuffs starts from here!
	printf "\e[1;36m - How much wallpapers you need to add it in the FLOSSPaper App :\e[0;37m "
	read wallpaper_count

	# failsafe, let's avoid null values..
	if [ -z "$wallpaper_count" ]; then
		continue_the_thing=false
		echo ""
		echo -e "\e[0;31m - failed to fetch some informations, bye bye!\e[0;37m"
	fi

	if $continue_the_thing; then
		# removing the json file will help us to reduce some codes.
		rm -rf resources_info.json
		touch resources_info.json
		json_header
		echo -e " - Adding requested amount of wallpaper(s) into the list..\n"
		for ((i=1; i<=wallpaper_count; i++)); do
			# let's not make the user to not make them do another job to rename the files.
			# cuz this bash script is meant to be simple.
			if [ "${wallpaper_count}" -ge "10" ]; then
				wallpaper_count_additional_int=0
			fi
		
			# change the default wallpaper configs
			echo -e "\e[0;36m - Adding configurations for the wallpaper_${wallpaper_count_additional_int}${i}.png."
			CHANGE_THE_DEFAULT_WALLPAPER_CONFIGURATIONS
			echo -e "\e[0;36m - Finished adding configurations for the wallpaper_${i}.png..\e[0;37m"
			# add a newline char to differenciate the next thingy.
			echo ""
		done
		json_ending_stuffs
		if ! $the_homescreen_wallpaper_has_been_set; then
			echo -e "\e[0;31m - Warning! The default homescreen wallpaper was not included in the lists\e[0;37m"
		elif ! $the_lockscreen_wallpaper_has_been_set; then
			echo -e "\e[0;31m - Warning! The default lockscreen wallpaper was not included in the lists\e[0;37m"
		fi
	fi
	echo -e "\e[0;31m"
	echo "######################################################################"
	echo "#                                                                    #"
	echo "#       __        ___    ____  _   _ ___ _   _  ____ _               #"
	echo "#       \ \      / / \  |  _ \| \ | |_ _| \ | |/ ___| |              #"
	echo "#        \ \ /\ / / _ \ | |_) |  \| || ||  \| | |  _| |              #"
	echo "#         \ V  V / ___ \|  _ <| |\  || || |\  | |_| |_|              #"
	echo "#          \_/\_/_/   \_\_| \_\_| \_|___|_| \_|\____(_)              #"
	echo "#                                                                    #"
	echo "#                                                                    #"
	echo "######################################################################"
	echo -e "\e[1;36m"
	echo -e "  besure to move the images to the drawable-nodpi/ folder with their appropriate names"
	echo -e "\e[0;31m  this script is still in the beta stages, please check the \"res/raw/resources_info.json\" if you're concerned about it"
	echo -e "  being failed to add a wallpaper meta-data."
	echo -e "  thnx for your time!\e[0;37m"
	mv resources_info.json ./packages/flosspaper_purezza/res/raw
	echo -e "  \e[0;36mthe generated resources_info.json is moved to the \"./packages/flosspaper_purezza/res/raw" folder.\e[0;37m"
}

main;