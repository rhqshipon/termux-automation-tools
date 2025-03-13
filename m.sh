#!/data/data/com.termux/files/usr/bin/bash
default_config="/data/data/com.termux/files/usr/etc/m_config.json"
intsd=$(jq -r ".storage.intsd" "$default_config")
extsd=$(jq -r ".storage.extsd" "$default_config")
backup_dir=$(jq -r ".bulk_storage.backup_dir" "$default_config")
device_model=$(jq -r ".additional_info.device_model" "$default_config")
ControlLists=$(jq -r ".bulk_storage.ControlLists" "$default_config")
busybox_dir=$(jq -r ".bulk_storage.busybox_dir" "$default_config")


help()	{
	local help_texts=(
		"  - h|help to show this help page."
		"  - t1|trim1 to trim the cache, data, system, and vendor partitions of the device."
		"  - t2|trim2 to trim the cache, and data partitions of the device."
		"  - b|balanceaudio to balance the audio channel volume."
		"  - sa|setanim to set the animation duration scale for window, transition, and animator animations respectively across the UI."
		"  - sr|setrefr to manually set the maximum and minimum refresh rate respectively for the device."
		"  - instl|instaloader and an additional argument with the Instagram username or the profile link to download contents of an Instagram profile using 'instaloader' python module to '$intsd/Pictures/instaloader' directory.\n  |\n  additional arguments,\n    i|img|image|images|r|reg|regular to only download images from the provided profile.\n    v|vid|video|videos to only download videos from the provided Instagram profile.\n    iv|i_v|imgvid|imgvids|imgsvids|img_vid|imagevideo|image_video to download both images and videos from the provided Instagram profile.\n    a|adv|advance|advanced for advanced mode (put the flags by the user manually.\n\n"
		"  - pur|pr to purge files from Whatsapp message backup database, dropbox, and anr folder from this device."
		"  - pus|ps to purge files having the extension '.meta', folder names with '.*', and has the word 'thumb' on the name of the file from the snaptube folder(s)."
		"  - bkt|bt to backup data of the Termux app."
		"  - bat|battery to know the battery health for your device. (Works on RMX3461, don't know about other devices)"
		"  - get mix|mixplorer to download the latest version of MiXplorer's free edition with all addons."
		"  - ret|rt  to restore data of the Termux app."
		"  - bki|bi to backup the directory tree of the Internal Storage."
		"  - rei|ri to restore the directory tree of the Internal Storage."
		"  - setup termpub|termuxpublic to setup termux for public use."
		"  - setup onesh|oneshot to install and setup OneShot."
		"  - setup bashhist|bashhistory to setup termux's bash history (Command history)."
		"  - setup termprog|termuxprograms to setup termux programs."
		"  - setup term|termux to setup termux with it's usual settings."
		"  - setup phn|phone to setup the phone for the first time (After Reset)."
		"  - setup settings to set all the personalized settings."
		"  - backup conf|config|configuration|configurations to backup configuration files to google drive."
		"  - backup callrec|callrecording|callrecordings to backup call recordings to google drive."
		"  - backup all|everything to backup call recordings, configurations to google drive."
		"  - backup wp|wpass|wifipass|wifipassword|wifipasswords to backup obtained Wi-Fi passwords using OneShot to GitHub repository."
		"  - backup|restore app <app package name> to respectively backup/restore the specified backed up app to/from Google Drive."
		"  - backup|restore pass|password to accordingly backup/restore the KeePass database to/from Google Drive."
		"  - p|pa|pan|panic|panik to initiate panic mode."
		"  - up|upa|unpan|unpanic|unpanik to initiate unpanic mode."
		"  - debloat to debloat apps using custom package list. Initiate to learn more."
		"  - rebloat to rebloat or re-install uninstalled system packages using custom package name list. Initate to learn more."
		"  - disable to disable specified app(s) using custom package/component name list. Initate to learn more."
		"  - enable to enable specified app(s) using custom package/component name list. Initate to learn more."
		"  - inf|infect to 'chmod 700' specified app'd data folder(s) using custom package/component name list. Initate to learn more."
		"  - dinf|imm|disinfect|immunize to 'chmod 0' specified app's data folder(s) using custom package/component name list. Initate to learn more."
		"  - suspend to suspend specified app(s) using custom package/component name list. Initate to learn more."
		"  - unsuspend to unsuspend specified app(s) using custom package/component name list. Initate to learn more."
		"  - disablecmp|disable_component|disable_components to disable specific components of package(s) using custom package/component name list. Initate to learn more."
		"  - enablecmp|enable_component|enable_components to enable specific components of package(s) using custom package/component name list. Initate to learn more."
		"  - o|opt|optimize to optimize apps using custom package name list. Initate to learn more.\n  |\n   optionally, only add 's' to perform operations silently.\n   optionally, only add 'e' to perform operations by a specified text file.\n   optionally, only add 'i' <space> <package name> to perform operations in interactive mode.\n\n"
		"  - msc|medsc|mediasc|mediascanner|mediascannerint to scan for all (if specifically not mentioned) media changes on the device.\n  |\n   optionally, only add int|intsd|internal|internalstorage|internal_storage|internalsd|internal_sd to specifically scan for media changes on the internal storage.\n   optionally, only add ext|extsd|external|externalstorage|external_storage|externalsd|external_sd to specifically scan for media changes on the external storage.\n\n"
		"  - purge|organize|purgeall|organizeall to initiate all the functions related to purging and organizing which you have to do in a regular basis."
		"  - cltmp|clean_temp|clean_tmp|cleantmp to clean up everything inside the 'temp' folder on the home directory of termux."
		"  - pmsh|push_m_sh to push 'm.sh' and 'm_config.json' to github."
		"  - sya|sync_alibi to sync, you know what."
		"  - sync <next argument> to sync stuffs back and forth between local storage and the cloud.\n  |\n   add 'alibi' to, you know what."
		"  - acs|aiub_courses_scraper to scrape through 'Offered Course Report.xlsx' file to analuze which course is filled up to which extent."
		"  - cpp <path to .cpp file with the .cpp file> to run .cpp files."
		"  - java <path to .java file with the .java file> to run .java files."
		"  - dex|d to forcefully perform dexopt job."
		"  - w|wifihack to search for WPS enabled Wi-Fi networks and perform pixie-dust attack to obtain the network authentication password."
		"  - wph|wifipushhack to search for Wi-Fi networks which has WPS push button turned on to obtain the network authentication password."
		"  - mvs|movesnaptube to move all the scattered snaptube folders to external sd card's 'snaptube' folder."
		"  - cpw|copywhatspp|copywhatsappmedia to copy all the WhatsApp photos videos and documents to specific directories of the internal storage."
	)
		one_line
		for help_text in "${help_texts[@]}"; do
			one_line
			echo -e "$help_text"
		done
		four_line
}

one_line()	{
	echo ""
}

two_line()	{
	echo ""
	echo ""
}

three_line()	{
	echo ""
	echo ""
	echo ""
}

four_line()	{
	echo ""
	echo ""
	echo ""
	echo ""
}

finished_message()	{
	one_line
	echo "	Process finished!"
	three_line
}

test()	{
	two_line
	echo "      howdy?"
	one_line
	echo "	1st argument: $1"
	echo "	2nd argument: $2"
	echo "	3rd argument: $3"
	echo "	4th argument: $4"
	echo "	5th argument: $5"
	echo "	6th argument: $6"
	echo "	7th argument: $7"
	echo "	8th argument: $8"
	echo "	9th argument: $9"
	one_line
	echo "      bye!"
	three_line
}

media_scan_intsd()	{
	two_line
	echo "  - Invoking the media scanner to scan for file changes in $intsd"
	su -c "am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d 'file://$intsd'" > /dev/null
	one_line
}

media_scan_extsd()	{
	two_line
	echo "  - Invoking the media scanner to scan for file changes in $extsd"
	su -c "am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d 'file://$extsd'" > /dev/null
	one_line
}

does_it_look_like_a_directory()	{
	if [[ "$1" =~ ^/[^/]*(/[^/]*)*$ ]]; then
		is_directory="yes"
	else
		is_directory="no"
	fi
}

compile_m()	{
	cd
	termux-fix-shebang ../usr/bin/m.sh
	shc -f ../usr/bin/m.sh
	if [[ -f ../usr/bin/m.sh.x ]]; then
		rm -f "../usr/bin/m.sh.x.c" && rm -f "../usr/bin/m" && mv "../usr/bin/m.sh.x" "../usr/bin/m" && chmod +x "../usr/bin/m"
	else
		echo "	It did not compile and export the file successfully so, no files are modified."
		three_line
	fi
}

backup_restore_termux_and_internal()	{
	local bulk_dir="$backup_dir/Data/Bulk"
	local gcam_config_dir="$backup_dir/Apps/GCAM_RMX3461"
	case $1 in
		(backup_termux)
			tar -zcf "$bulk_dir/termux-backup.tar.gz" -C /data/data/com.termux/files ./home ./usr
			;;
		(restore_termux)
			tar -zxf "$backup_dir/termux-backup.tar.gz" -C /data/data/com.termux/files --recursive-unlink --preserve-permissions
			;;
		(backup_InternalStorage)
			tar -zcf "$backup_dir/InternalStorageBackup.tar.gz" -C $extsd/$bulk_dir/InternalStorage .
			;;
		(restore_InternalStorage)
			tar -zxf "$backup_dir/InternalStorageBackup.tar.gz" -C $intsd --recursive-unlink --preserve-permissions
			cp -pr "$gcam_config_dir/LMC8.4" "$gcam_config_dir/SGCAM" "$intsd"
			media_scan_intsd
			;;
		(*)
			echo "	Internal error! Exiting!"
			exit 1
			;;
	esac
}

backup_call_recordings()	{
    local bcr="$intsd/Android/media/com.chiller3.bcr/files"
    local aosp_callrec="$intsd/Recordings/Call recordings"
    local remote_name="evidence"
    local remote_dir="Share GDrive 2 by md.rhqshipon.in@gmail.com/Call Recordings"
    local processed_any=0

    # Process BCR directory if it exists
    if [[ -d "$bcr" ]]; then
        processed_any=1
        one_line
        echo "  Processing BCR call recordings..."
        process_directory "$bcr" "bcr_dir" "$remote_name" "$remote_dir"
    fi

    # Process AOSP directory if it exists
    if [[ -d "$aosp_callrec" ]]; then
        processed_any=1
        one_line
        echo "  Processing AOSP call recordings..."
        process_directory "$aosp_callrec" "aosp_callrec_dir" "$remote_name" "$remote_dir"
    fi

    if [[ $processed_any -eq 0 ]]; then
        one_line
        echo "  Both directories '$bcr' and '$aosp_callrec' are missing! Exiting!"
        exit 1
    fi

    one_line
    echo "	Process finished!"
    three_line
}

process_directory()	{
    local src_dir="$1"
    local method="$2"
    local remote_name="$3"
    local remote_dir="$4"
    
    for entry in "$src_dir"/*; do
        # Skip processing if no files found
        [[ -e "$entry" ]] || continue

        local filename=$(basename "$entry")
        local year month remote_subdir

        case "$method" in
            ("bcr_dir")
                year="${filename:0:4}"
                month="${filename:4:2}"
                ;;
            ("aosp_callrec_dir")
                year="${filename:11:4}"
                month="${filename:15:2}"
                ;;
            (*)
                echo "  Invalid processing method! Exiting!"
                exit 1
                ;;
        esac

        remote_subdir="$remote_dir/$year/$month"
        one_line
        echo "  File to back-up: $filename"
        backup_file "$entry" "$remote_name" "$remote_subdir"
    done
}

backup_restore_configurations()	{
	local local_path="$backup_dir/Configurations"
	local remote_name="backupDrive"
	local folder_path="[Xiaomi Read] Share GDrive/Backup/Configurations"
	local termux_config_dir="$local_path/Extra/Termux"
	local gcam_config_dir="$backup_dir/Apps/GCAM_RMX3461"
	local backup_or_restore="$1"
	case "$backup_or_restore" in
		(backup)
			case "$2" in
				(termux_configurations)
					cp -pr ".bash_history" "../usr/bin/m" "../usr/bin/m.sh" "OneShot/reports" ".config/rclone/rclone.conf" ".config/instaloader" "$termux_config_dir"
					rm -rf "$termux_config_dir/reports/.git"
					mkdir -p "$backup_dir/Configurations/Extra/GCam/$device_model"
					cp -pr "$gcam_config_dir/LMC8.4" "$gcam_config_dir/SGCAM" "$backup_dir/Configurations/Extra/GCam/$device_model"
					;;
				(*)
					echo "	Internal error! Exiting!"
					exit 1
					;;
			esac
			backup_restore_directory "$local_path" "$remote_name" "$folder_path" "$backup_or_restore"
			one_line
			echo "	Configurations have been backed up successfully."
			three_line
			;;
		(restore)
			case "$2" in
				(termux_configurations)
					mkdir -p ".config/rclone"
					echo "  Checking local storage..."
					if [[ -d "$termux_config_dir" ]]; then
						echo "	Config folder exists! Restoring..."
					else
						echo "	Local copy doesn't exist! Importing from online backup..."
						local termux_config_dir="Termux"
						local folder_path="$folder_path/Extra/Termux"
						mkdir -p "$termux_config_dir"
						backup_restore_directory "$termux_config_dir" "$remote_name" "$folder_path" "$backup_or_restore"
						rm -r "Termux"
					fi
					mkdir -p "$HOME/.config/instaloader"
					cp -p "$termux_config_dir/rclone.conf" "$HOME/.config/rclone"
					chmod +x ".config/rclone/rclone.conf"
					cp -p "$termux_config_dir"/session-* "$HOME/.config/instaloader/"

					# Clone WifiPassRepo
					if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
						echo "✅ Authentication successful! Cloning repository..."
						git clone git@github.com:rhqshipon/WiFiPassRepo.git "OneShot/reports"
					else
						echo "❌ Authentication failed! Continuing with local copy."
						cp -pr "$termux_config_dir/reports" "OneShot"
					fi
					rm -r "Termux" > /dev/null 2>&1
					;;
			esac
			;;
	esac
}

backup_restore_app()	{
	local backup_or_restore="$1"
	local packagename="$2"
	local appmgr_path="$extsd/AppManager"
	local local_path="$appmgr_path/$packagename"
	local remote_name="backupDrive"
	local folder_path="[Xiaomi Read] Share GDrive/Backup/AppManager_Package/$packagename"
	backup_restore_directory "$local_path" "$remote_name" "$folder_path" "$backup_or_restore"
	finished_message
}

fetch_mixplorer()	{
	local backup_folder="$backup_dir"
	local topic="Apps/Essentials/Ignore/MiXplorer/free"
	local local_path="$backup_folder/$topic"
	local remote_name="backupDrive"
	local folder_path="[Xiaomi Read] Share GDrive/Backup/Apps/Essentials/MiXplorer/addons"
	backup_restore_directory "$local_path" "$remote_name" "$folder_path" "fetch"
	finished_message
}

push_m_sh() {
	local dir="$backup_dir/Data/Bulk"
	local actual_dir="$dir/termux-automation-tools"
	two_line

	# Clone if the directory doesn't exist
	if [[ ! -d "$actual_dir" ]]; then
		git clone git@github.com:rhqshipon/termux-automation-tools.git "$actual_dir"
	fi

	# Ensure the directory exists after cloning
	if [[ ! -d "$actual_dir" ]]; then
		echo "	Error: Cannot source the git working directory. Exiting!"
		exit 1
	fi

	# Add the directory as a safe directory globally (for Termux permissions)
	git config --global --add safe.directory "$actual_dir"

	# Change to the project directory
	cd "$actual_dir" || exit 1

	# Pull latest changes
	git pull origin main

	# Define source file paths
	local source_msh="$PREFIX/bin/m.sh"
	local source_config="$PREFIX/etc/m_config.json"

	# Copy files only if at least one exists
	if [[ -f "$source_msh" || -f "$source_config" ]]; then
		cp -pr "$source_msh" "$source_config" "$actual_dir" 2>/dev/null
	else
		echo "Warning: No source files found. Skipping copy."
	fi

	# Check if there are changes before committing
	if ! git diff --quiet || ! git diff --cached --quiet; then
		git add .
		git commit -m "update"
		git push
	else
		echo "No changes to commit."
	fi

	# Return to home directory
	cd || exit 1
	finished_message
}

sync_alibi() {
	# Define variables
	local backup_folder="$backup_dir"
	local topic="Docs/from_alibi"
	local local_path="$backup_folder/$topic"
	local remote_name="alibi"
	local folder_path="[md.rhqshipon@gmail.com] Share GDrive 1/[01] Documents"

	# Use backup_restore_directory function
	backup_restore_directory "$local_path" "$remote_name" "$folder_path" "fetch"
	finished_message
}

backup_restore_password_database()	{
	local password_database_directory="$backup_dir/Configurations/Pass"
	local local_path="$password_database_directory"
	local remote_name="main"
	local folder_path="Credentials"
	one_line
	backup_restore_directory "$local_path" "$remote_name" "$folder_path" "$1"
	finished_message
}

backup_file()	{
	local local_file="$1"
	local remote_name="$2"
	local remote_path="$3"
	if (rclone copy "$local_file" "$remote_name:$remote_path"); then
		echo "	Successful!"
	else
		echo "	Failed!"
	fi
}

backup_restore_directory()	{
	local local_dir="$1"
	local remote_name="$2"
	local remote_path="$3"
	local backup_or_restore="$4"
	if [[ "$backup_or_restore" = "backup" ]] || [[ "$backup_or_restore" = "sync" ]]; then
		rclone sync "$local_dir" "$remote_name:$remote_path" --progress
	elif [[ "$backup_or_restore" = "restore" ]] || [[ "$backup_or_restore" = "fetch" ]]; then
		rclone sync "$remote_name:$remote_path" "$local_dir" --progress
	fi
}

setup_termux_public()	{
	su -c "rm -rf './scripts'"
	su -c "rm -rf './config'"
	su -c "rm './wgcfd/wgcf-account.toml' './wgcfd/wgcf-profile.conf'"
	setup_bash_history "public"
	echo "	Setup complete. Welcome! <3 ..."
	three_line
}

setup_termux_programs() {
    local install_git=n install_python=n install_instaloader=n install_rclone=n install_exiftool=n install_sh_compile_essentials=n install_clang=n install_java=n install_oneshot=n install_personal_essentials=n

    if [[ "$1" == "s" ]]; then
        install_git=y install_python=y install_instaloader=y install_rclone=y install_exiftool=y install_sh_compile_essentials=y install_clang=y install_java=y install_oneshot=y install_personal_essentials=y
    else
        read -rp "Install git (required)? (y/N) " install_git
        read -rp "Install python (required)? (y/N) " install_python
        read -rp "Install instaloader? (y/N) " install_instaloader
        read -rp "Install rclone? (y/N) " install_rclone
        read -rp "Install exiftool? (y/N) " install_exiftool
        read -rp "Install sh compile essentials? (y/N) " install_sh_compile_essentials
        read -rp "Install clang? (y/N) " install_clang
        read -rp "Install java? (y/N) " install_java
        read -rp "Install oneshot? (y/N) " install_oneshot
		read -rp "Install personal essentials? (y/N) " install_personal_essentials
    fi

    echo "Updating and upgrading packages..."
    if ! (pkg update -y && pkg upgrade -y); then
        echo "Failed to update and upgrade packages."
        return 1
    fi

    declare -A packages=(
		[sh_compile_essentials]="pkg install -y shc binutils jq"
        [git]="pkg install -y git"
        [python]="pkg install -y python"
        [instaloader]="pip install git+https://github.com/instaloader/instaloader.git"
        [rclone]="pkg install -y rclone"
        [exiftool]="pkg install -y exiftool"
        [clang]="pkg install -y clang"
        [java]="pkg install -y openjdk-17"
		[personal_essentials]="pkg install -y tur-repo && pkg install -y python-pip python-numpy python-pandas python-xlib python-lxml && pip install tabulate"
    )

    for pkg_name in "${!packages[@]}"; do
        install_var="install_${pkg_name}"
        if [[ ${!install_var} =~ ^[Yy]$ ]]; then
            echo "Installing ${pkg_name}..."
            if ! eval "${packages[$pkg_name]}"; then
                echo "Failed to install ${pkg_name}. Exiting."
                return 1
            fi
        fi
    done

    if [[ $install_oneshot =~ ^[Yy]$ ]]; then
        echo "Setting up oneshot..."
        setup_oneshot "out"
    fi

	if [[ "$1" == "s" ]]; then
		setup_git
	fi

    local message="Successfully installed programs you requested."
    if [[ "$1" == "s" ]]; then
        message="All programs successfully installed."
    fi

    two_line
    echo "    $message" # Four spaces here
    two_line
    if [[ "$1" != "s" ]]; then
        three_line
    fi
}

setup_git() {
	echo "	Setting up git for personal use..."

	# Prompt for Git username and email
	read -p "Enter your Git username: " git_username
	read -p "Enter your Git email: " git_email

	# Set Git user details based on input
	git config --global user.name "$git_username"
	git config --global user.email "$git_email"

	# Copy SSH keys to the correct directory
	mkdir -p "$HOME/.ssh"
	cp -r "$backup_dir/Data/Bulk/my_github/"* "$HOME/.ssh/"

	# Use SSH instead of HTTPS for GitHub
	git config --global url."git@github.com:".insteadOf "https://github.com/"

	# Check if finished_message function exists before calling
	declare -F finished_message >/dev/null && finished_message
}

setup_oneshot()	{
	if [[ "$1" != "out" ]]; then
		pkg update -y && pkg upgrade -y
	fi
	if [[ "$1" == "out" ]]; then
		if [[ -f "$destination_folder/oneshot.py" ]]; then
			echo "	Error: $destination_folder already exists! Skipping!"
			exit 0
		fi
	fi
    pkg install root-repo -y
	pkg install git tsu python wpa-supplicant pixiewps iw openssl -y
    local repo_name="OneShot"
    local github_url="https://github.com/kimocoder/$repo_name"
    local destination_folder="OneShot"
    git clone --depth 1 "$github_url" "$destination_folder"
    if [ $? -eq 0 ]; then
        echo "	Successfuly cloned '$repo_name' into folder '$destination_folder'."
    else
        echo "	Failed to clone '$repo_name'. Checking local repository..."
        local external_path="$backup_dir/Data/Bulk/OneShot"
        local internal_path="$intsd/OneShot"
        if [ -d "$external_path" ]; then
            echo "  Found local copy of '$repo_name'."
            cp -pr "$external_path" .
            echo "  Continuing with the local copy of '$repo_name' in '$destination_folder'..."
        elif [ -d "$internal_path" ]; then
            echo "  Found local copy of '$repo_name'."
            cp -pr "$internal_path" .
            echo "  Continuing with the local copy of '$repo_name' in '$destination_folder'..."
        else
            echo "  Error: Local repository not found at '$external_path' or '$internal_path'."
            echo "  Aborting script."
			exit 1
        fi
    fi
    chmod +x "$destination_folder/oneshot.py"
    two_line
}

setup_bash_history()	{
	local filename=".bash_history"
	one_line
	rm -rf "$filename"
	text_to_write="m panic\n"
		if [[ "$1" != "public" ]]; then
			text_to_write+="scripts/backup_passtogithub.sh\n"  # Use "\n" for newlines
		fi
	text_to_write+="m.sh compile_m\n"
	text_to_write+="pkg update -y && pkg upgrade -y"
	echo -e "$text_to_write" > "$filename"
	one_line
	echo "	$filename has been successfully set up!"
	two_line
}

# Helper function to copy a file to the home directory
copy_to_home() {
    local FULL_PATH="$1"
    local DEST_DIR="$HOME/temp"

    echo "Copying $(basename "$FULL_PATH") to $DEST_DIR..."
    mkdir -p "$DEST_DIR"
    cp "$FULL_PATH" "$DEST_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to copy file to $DEST_DIR!"
        return 1
    fi
    echo "File copied successfully."
    return 0
}

# Helper function to clean up files
clean_up() {
    local FILES=("$@")
	three_line
    echo "Cleaning up..."
    for FILE in "${FILES[@]}"; do
        rm -f "$FILE"
    done
}

# Function to compile and run C++ programs
run_my_cpp() {
    if [ -z "$1" ]; then
        echo "Usage: m cpp <filename.cpp>"
        return 1
    fi

    local FULL_PATH="$1"
    local FILE_NAME=$(basename "$FULL_PATH")
    local BASE_NAME="${FILE_NAME%.cpp}"
    local HOME_DIR="$HOME/temp"

    copy_to_home "$FULL_PATH" || return 2

    cd "$HOME_DIR"
    echo "Compiling $FILE_NAME..."
    clang++ "$FILE_NAME" -o "$BASE_NAME"
    if [ $? -ne 0 ]; then
        echo "Compilation failed!"
        clean_up "$FILE_NAME"
        return 3
    fi

    chmod +x "./$BASE_NAME"
    clear
    echo "Running the program..."
    two_line
    ./"$BASE_NAME"

    clean_up "$FILE_NAME" "$BASE_NAME"
}

# Function to compile and run Java programs
run_my_java() {
    if [ -z "$1" ]; then
        echo "Usage: m java <filename.java>"
        return 1
    fi

    local FULL_PATH="$1"
    local FILE_NAME=$(basename "$FULL_PATH")
    local BASE_NAME="${FILE_NAME%.java}"
    local HOME_DIR="$HOME/temp"

    copy_to_home "$FULL_PATH" || return 2

    cd "$HOME_DIR"
    echo "Compiling $FILE_NAME..."
    javac "$FILE_NAME"
    if [ $? -ne 0 ]; then
        echo "Compilation failed!"
        clean_up "$FILE_NAME"
        return 3
    fi

    clear
    echo "Running the program..."
    two_line
    java "$BASE_NAME"

    clean_up "$FILE_NAME" "${BASE_NAME}.class"
}

clean_temp()	{
	cd
	rm temp/*
}

backup_wifi_pass_to_github()	{
	one_line
	cd OneShot/reports
	git add .
	git commit -m "addition of new entries"
	git push "$@"
	cd
	finished_message
}

aiub_courses_scraper()	{
	local script_directory="/storage/emulated/0/Files/aiub_routine"
	cd "$script_directory"
	python script.py
	cd
}

manipulate_shizuku_and_root()	{
	local src_dir="$intsd/Download"
	local dest_dir="../usr/bin"
	two_line
	case $1 in
		(root_as_primary)
			if [[ -f "$dest_dir/su1.bak" ]] && [[ ! -f "$dest_dir/su2.bak" ]]; then
				mv "$dest_dir/su" "$dest_dir/su2.bak"
				mv "$dest_dir/su1.bak" "$dest_dir/su"
			fi
			;;
		(shizuku_as_primary)
			if [[ ! -f $dest_dir/rish_shizuku.dex ]]; then
				echo "	Please make sure to export the 'rish_shizuku.dex' and 'rish' file from the Shizuku app to '$src_dir'..."
				two_line
				if [[ -f $src_dir/rish_shizuku.dex ]] then
					cp "$src_dir/rish_shizuku.dex" "$src_dir/rish" "$dest_dir/"
					sed -i 's/PKG/com.termux/g' "$dest_dir/rish"
					mv "$dest_dir/rish" "$dest_dir/su2.bak"
				else
					echo "	No files are detected inside $src_dir! Please try again!"
					exit 1
				fi
			fi
			if [[ -f "$dest_dir/su2.bak" ]] && [[ ! -f "$dest_dir/su1.bak" ]]; then
				mv "$dest_dir/su" "$dest_dir/su1.bak"
				mv "$dest_dir/su2.bak" "$dest_dir/su"
				chmod +x "$dest_dir/rish_shizuku.dex"
			fi
			;;
		(remove_shizuku)
			rm -f "$dest_dir/rish_shizuku.dex" "$dest_dir/rish" "$dest_dir/su2.bak" 
			if [[ -f "$dest_dir/su1.bak" ]]; then
				rm -f "$dest_dir/su"
				mv "$dest_dir/su1.bak" "$dest_dir/su"
			fi
			;;
		(*)
			echo "	Internal error! Exiting!"
			exit 1
			;;
	esac
	chmod +x "$dest_dir/su"
	su -c "echo '	If you can see this text, then su is working correctly!\n	Congratulations!'"
	three_line
}

debloat()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		echo "yes"
		for package in $(cat "$1"); do
			one_line
			echo "  Package to remove: $package"
			case $2 in
				(0)
					su -c "pm uninstall $package"
					su -c "pm uninstall --user $2 $package"
					;;
				(*)
					su -c "pm uninstall --user $2 $package"
					;;
			esac
		done
	else
		local package="$1"
		case $2 in
			(0)
				su -c "pm uninstall $package"
				su -c "pm uninstall --user $2 $package"
				;;
			(*)
				su -c "pm uninstall --user $2 $package"
				;;
		esac
	fi
}

rebloat()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for package in $(cat "$1"); do
			one_line
			rebloat_core "$package"
		done
	else
		local package="$1"
		rebloat_core "$package"
	fi
}

rebloat_core()	{
	local package="$1"
	echo "  Package to Re-Install: $package"
	su -c "pm install-existing $package"
}

optimize()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for package in $(cat "$1"); do
			one_line
			optimize_core "$package"
		done
		do_dexopt_job
	else
		# Iterate through all arguments passed to the script
		for package in "$@"; do
			optimize_core "$package"
			one_line
		done
	fi
}

optimize_core()	{
	local package="$1"
	echo "  Package to be compiled in 'speed' profile: $package"
	su -c "pm compile -m speed -f $package"
	if [[ "$(su -c 'getprop ro.build.version.release')" -ne 14 ]]; then
  	  su -c "pm compile -f --compile-layouts $package"
	fi
}

do_dexopt_job()	{
	one_line
	echo "    Forcefully performing bg-dexopt-job. (Might fail if the device is or becomes too hot!)"
	su -c "pm bg-dexopt-job"
	two_line
}

disable_component()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for component in $(cat "$1"); do
			one_line
			disable_component_core "$component"
		done
	else
		local component="$1"
		disable_component_core "$component"
	fi
}

disable_component_core()	{
	local component="$1"
	echo "  Component to disable: $component"
	su -c "pm disable $component"
}

enable_component()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for component in $(cat "$1"); do
			one_line
			enable_component_core "$component"
		done
	else
		local component="$1"
		enable_component_core "$component"
	fi
}

enable_component_core()	{
	local component="$1"
	echo "  Component to enable: $component"
	su -c "pm enable $component"
}

disable_app()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for package in $(cat "$1"); do
			one_line
			disable_app_core "$package"
		done
	else
		local package="$1"
		disable_app_core "$package"
	fi
}

disable_app_core()	{
	local package="$1"
	echo "  Package to disable: $package"
	su -c "am force-stop $package"
	su -c "pm disable $package"
}

disable_user_app()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for package in $(cat "$1"); do
			one_line
			disable_user_app_core "$package"
		done
	else
		local package="$1"
		disable_user_app_core "$package"
	fi
}

disable_user_app_core()	{
	local package="$1"
	echo "  Package to disable-user: $package"
	su -c "am force-stop $package"
	su -c "pm disable-user $package"
}

suspend_app()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for package in $(cat "$1"); do
			one_line
			suspend_app_core "$package"
		done
	else
		local package="$1"
		suspend_app_core "$package"
	fi
}

suspend_app_core()	{
	local package="$1"
	echo "  Package to suspend: $package"
	su -c "am force-stop $package"
	su -c "pm suspend $package"
}

unsuspend_app()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for package in $(cat "$1"); do
			one_line
			unsuspend_app_core "$package"
		done
	else
		local package="$1"
		unsuspend_app_core "$package"
	fi
}

unsuspend_app_core()	{
	local package="$1"
	echo "  Package to unsuspend: $package"
	su -c "am force-stop $package"
	su -c "pm unsuspend $package"
}

enable_app()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for package in $(cat "$1"); do
			one_line
			enable_app_core "$package"
		done
	else
		local package="$1"
		enable_app_core "$package"
	fi
}

enable_app_core()	{
	local package="$1"
	echo "  Package to enable: $package"
	su -c "pm enable $package"
}

infect_app_data()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for package in $(cat "$1"); do
		one_line
		infect_app_data_core "$package"
		done
	else
		local package="$1"
		infect_app_data_core "$package"
	fi
}

infect_app_data_core()	{
	local package="$1"
	local app_data_dir="/data/data"
	echo "  Package to infect: $package"
	su -c "chmod 0 '$app_data_dir/$package'"
}

disinfect_app_data()	{
	does_it_look_like_a_directory "$1"
	if [[ "$is_directory" == "yes" ]]; then
		for package in $(cat "$1"); do
		one_line
		disinfect_app_data_core "$package"
		done
	else
		local package="$1"
		disinfect_app_data_core "$package"
	fi
}

disinfect_app_data_core()	{
	local package="$1"
	local app_data_dir="/data/data"
	echo "  Package to disinfect: $package"
	su -c "chmod 700 '$app_data_dir/$package'"
}

app_manager()	{
	local filename
	local user_id="0"
	case "$1" in
		(debloat)
			filename="debloat.txt"
			verdict="Enjoy the smoothness (or potential boot issues)!"
			;;
		(rebloat)
			filename="rebloat.txt"
			verdict="Enjoy the stability or slowness!"
			;;
		(optimize)
			filename="optimize.txt"
			verdict="Enjoy!"
			;;
		(disable_component)
			filename="disable_components.txt"
			verdict="Finished disabling component(s)!"
			;;
		(enable_component)
			filename="enable_components.txt"
			verdict="Finished enabling component(s)!"
			;;
		(disable_app)
			filename="disable_apps.txt"
			verdict="Finished disabling app(s)!"
			;;
		(disable_user_app)
			filename="disable_user_apps.txt"
			verdict="Finished disabling app(s)!"
			;;
		(suspend_app)
			filename="suspend_app.txt"
			verdict="Finished suspending app(s)!"
			;;
		(unsuspend_app)
			filename="unsuspend_app.txt"
			verdict="Finished unsuspending app(s)!"
			;;
		(enable_app)
			filename="enable_apps.txt"
			verdict="Finished enabling app(s)!"
			;;
		(infect_app_data)
			filename="infect.txt"
			verdict="Finished infecting app's data folder(s)!"
			;;
		(disinfect_app_data)
			filename="disinfect.txt"
			verdict="Finished disinfecting app's data folder(s)!"
			;;
		(*)
			echo "Invalid argument for $0!"
			exit 1
			;;
	esac
	case "$2" in
		(s)
			before_pm "$filename" s
			;;
		(i)
			case $4 in
				("")
					local user_id="0"
					two_line
					$1 "$3" "$user_id" 
					three_line
					exit 1
					;;
				(*)
					two_line
					$1 "$3" "${@:4}"
					three_line
					exit 1
					;;
			esac
			;;
		(e)
			local filename="$3"
			before_pm "$filename" s
			;;
		(*)
			before_pm "$filename"
			;;
	esac
	$1 "$target_file" "$user_id"
	after_pm "$is_really_copied"
	one_line
	echo "	$verdict"
	three_line
}

before_pm()	{
	local is_copied
	local filename="$1"
	local target_dir="$intsd"
	local target_file_backup="$ControlLists/$filename"

	one_line
	if [[ "$2" = "s" ]]; then
		echo "	Processing "$filename" silently..."
	elif [[ "$2" = "" ]]; then
		echo "	Please ensure '$filename' is in $intsd or $extsd before continuing."
		echo "	Performing the above operation can prevent your apps from running and/or system from booting altogether if you don't research the app list properly. Proceed with caution."
		one_line
		read -r -t 10 -p "	Continue? (y/N) " response
		response=${response:-n}
		if [[ "$response" =~ ^[Yy]$ ]]; then
			echo "	Okay. Hang tight!"
		else
			echo "	Aborted."
			two_line
			exit 1
		fi
		if [[ -f "$intsd/$filename" ]]; then
			one_line
			echo "	File found in '$intsd/$filename'"
		elif [[ -f "$extsd/$filename" ]]; then
			one_line
			echo "	File found in '$extsd/$filename'"
		else
			one_line
			echo "	Error: '$filename' not found in $intsd or $extsd!"
			three_line
			exit 1
		fi
	else
		one_line
		echo "	There was an unknown issue. Please investigate."
		three_line
		exit 1
	fi
	if [[ -f "$intsd/$filename" ]]; then
		target_file="$intsd/$filename"
	elif [[ -f "$extsd/$filename" ]]; then
		target_file="$extsd/$filename"
	elif [[ -f "$target_file_backup" ]]; then
		if ! su -c "cp -p '$target_file_backup' '$target_dir'"  &> /dev/null; then
			one_line
			echo "	Error: Failed to copy '$filename'!"
			two_line
			exit 1
		fi
		is_copied="yes"
		target_file="$intsd/$filename"
	else
		echo "	Error: '$filename' not found in $intsd or $extsd!"
		three_line
		exit 1
	fi
	su -c "chmod +r '$target_file'"
	export is_really_copied="$is_copied"
}

after_pm()	{
	local is_copied="$1"
	if [[ "$is_copied" == "yes" ]]; then
		su -c "rm -f '$target_file'"
	fi
	one_line
	echo "	Finished processing '$filename'!"
}

copy_files_emergency()	{
	local backup_path="/data/local/com.backup"
	local owner_check_path="$intsd/Download"
	local uid=$(su -c "stat -c '%u' '$owner_check_path'")
	local gid=$(su -c "stat -c '%g' '$owner_check_path'")
	local mode=2770
	if [[ "$1" = "r" ]]; then
		su -c "mv '$backup_path/DCIM' '$intsd'"
		su -c "mv '$backup_path/Pictures' '$intsd'"
		su -c "mv '$backup_path/Movies' '$intsd'"
		su -c "mv '$backup_path/Android/media/com.snaptube.premium' '$extsd/Android/media'"
		su -c "mv '$backup_path/Android/media/com.chiller3.bcr' '$intsd/Android/media'"
	else
		su -c "mkdir -p '$backup_path/Android/media'"
		su -c "mv '$intsd/DCIM' '$backup_path'"
		su -c "mv '$intsd/Pictures' '$backup_path'"
		su -c "mv '$intsd/Movies' '$backup_path'"
		su -c "mv '$extsd/Android/media/com.snaptube.premium' '$backup_path/Android/media'"
		su -c "mv '$intsd/Android/media/com.chiller3.bcr' '$backup_path/Android/media'"
		local dirs=(
				"DCIM/Camera" "DCIM/CamScanner" "DCIM/Facebook" "DCIM/Snapchat" "DCIM/Restored"
				"Pictures/Screenshots" "Pictures/Nekogram" "Pictures/Twitter" "Pictures/MyInsta" "Pictures/Picsart" "Pictures/Whatsapp" "Pictures/Messenger" "Pictures/facebook"
				"Movies/Whatsapp" "Movies/Twitter" "Movies/Subtitles"
		)
		for dir in "${dirs[@]}"; do
			local full_path="$intsd/$dir"
			su -c "mkdir -p '$full_path'"
			su -c "chown $uid:$gid '$full_path'"
			su -c "chmod $mode '$full_path'"
		done
	fi
	media_scan_intsd
	media_scan_extsd
	finished_message
}

emergency_protocol()	{
	two_line
	echo "	All the best!"
	su -c "pm disable com.termux"
}

setupSettings() {
	settings=(
		"system accelerometer_rotation 0"
		"system lockscreen_sounds_enabled 0"
		"secure accessibility_captioning_font_scale 0.70"
		"global window_animation_scale 0.30"
		"global transition_animation_scale 0.26"
		"global animator_duration_scale 0.20"
		"system screen_off_timeout 1800000"
		"secure enabled_input_methods com.kunzisoft.keepass.free/com.kunzisoft.keepass.magikeyboard.MagikeyboardService:com.google.android.googlequicksearchbox/com.google.android.voicesearch.ime.VoiceInputMethodService:com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME"
		"secure enabled_notification_listeners com.samsung.accessory.pearlmgr/com.samsung.accessory.hearablemgr.core.notification.NotificationListener"
		"global data_roaming1 1"
		"global data_roaming2 1"
	)

	for setting in "${settings[@]}"; do
		su -c "settings put $setting"
	done
}

set_animation_duration_scale() {
	# Define the setting keys
	keys=(
		"window_animation_scale"
		"transition_animation_scale"
		"animator_duration_scale"
	)

	# Default values if "d" is passed as the first argument
	if [[ "$1" = "d" ]]; then
		values=("0.30" "0.26" "0.20")
	else
		values=("$1" "$2" "$3")
	fi

	# Loop through the keys and apply the corresponding values
	for i in "${!keys[@]}"; do
		su -c "settings put global ${keys[i]} ${values[i]}"
	done
}

set_refresh_rate() {
	# Define the setting keys
	keys=(
		"min_refresh_rate"
		"peak_refresh_rate"
	)

	# Default values if "d" is passed as the first argument
	if [[ "$1" == "d" ]]; then
		values=("30" "90")
	else
		values=("$1" "$2")
	fi

	# Loop through the keys and apply the corresponding values
	for i in "${!keys[@]}"; do
		su -c "settings put system ${keys[i]} ${values[i]}"
	done
}

purgeRegular()	{
	local targets=(
		"/data/system/dropbox"
		"/data/anr"
		"/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Databases"
	)
	one_line
	echo "Cleaning up..."
	for target in "${targets[@]}"; do
		su -c "rm -rf '$target'/*"
		echo "  - Deleted everything inside '$target'"
	done
	finished_message
}

purgeSnaptube()	{
	local internal_media_specific=(
		"$extsd/snaptube/download"	"$extsd/Android/media/com.snaptube.premium"	"$extsd/Download/snaptube"
		"$intsd/snaptube/download"	"$intsd/Android/media/com.snaptube.premium"	"$intsd/Download/snaptube"
	)
	local files_to_delete=("*.thumb*" "*.meta*")

	one_line
	for dir in "${internal_media_specific[@]}"; do
		if [ -d "$dir" ]; then
			cd "$dir"
			for file_pattern in "${files_to_delete[@]}"; do
				su -c "find . -type f -name '$file_pattern' -delete" > /dev/null 2>&1
			done
			su -c "find . -type d -name '.*' ! -path '.' -exec rm -rf {} \;" > /dev/null 2>&1
			echo "  - Cleaned '$dir'"
		else
			echo "Skipping '$dir': directory does not exist."
		fi
		cd - &> /dev/null
	done
	finished_message
}

moveSnaptubedata()	{
	local source_dirs=(
		"$extsd/Android/media/com.snaptube.premium"
		"$extsd/Download/snaptube"
		"$intsd/Android/media/com.snaptube.premium"
		"$intsd/Download/snaptube"
		"$intsd/snaptube/download"
	)
	local target_dir="$extsd/snaptube/download"
	local media_dirs=("SnapTube Video" "SnapTube Image" "SnapTube Audio")
	one_line
	for source in "${source_dirs[@]}"; do
		if [ -d "$source" ]; then
			for media_dir in "${media_dirs[@]}"; do
				su -c "mv '$source/$media_dir'/* '$target_dir/$media_dir'"
			done
		else
			echo "Skipping '$source': directory does not exist."
		fi
	done
	media_scan_intsd
	media_scan_extsd
	finished_message
}

copy_whatsapp_media() {
	local whatsapp_media_dir="$intsd/Android/media/com.whatsapp/WhatsApp/Media"
	local internal_media_specific=("$intsd/Pictures/Whatsapp"	"$intsd/Movies/Whatsapp"	"$intsd/Documents/Whatsapp")
	local whatsapp_media_specific=("WhatsApp Images/Private"	"WhatsApp Video/Private"	"WhatsApp Documents/Private")
	for i in "${!whatsapp_media_specific[@]}"; do
		cp -pr "$whatsapp_media_dir/${whatsapp_media_specific[$i]}"/*.* "${internal_media_specific[$i]}" > /dev/null 2>&1
		rm -f "${internal_media_specific[$i]}/.nomedia" > /dev/null
	done
	media_scan_intsd
	su -c "am start -n com.whatsapp/com.whatsapp.storage.StorageUsageActivity" > /dev/null 2>&1
	finished_message
}

instaloader_init() {
    local instaloader_dir="$intsd/Pictures/instaloader"
    local set_exif_authorization="n"
    su -c "mkdir -p '$instaloader_dir'"
    cd "$instaloader_dir" || exit
    for arg in "$@"; do
        if [[ "$arg" =~ ^http(s?):// ]]; then
            username=$(echo "$arg" | sed -E 's#.*/([^\?/]+).*#\1#')
            if [[ -n "$username" ]]; then
                user_names+=("$username")
            fi
        else
            remaining_args+=("$arg")
        fi
    done
    for username in "${user_names[@]}"; do
        one_line
        echo "  Currently working for: $username"
        instaloader --no-video-thumbnails --no-metadata-json --no-captions ${remaining_args[@]} "$username"
		one_line
		read -p "  Do you want to set date EXIF(s) from filename(s)...? (yes/No): " set_exif_authorization
		set_exif_authorization=$(echo "$set_exif_authorization" | tr '[:upper:]' '[:lower:]')
		one_line
		if [[ "$set_exif_authorization" == "y" || "$set_exif_authorization" == "yes" ]]; then
			cd "$username" || continue
			echo "	Setting date EXIF(s) from filename(s)..."
   	     for file_name in *; do
          	  filename=$(basename -- "$file_name")
       	     date_part=$(echo "$filename" | grep -oP '^\d{4}-\d{2}-\d{2}')
         	   time_part=$(echo "$filename" | grep -oP '\d{2}-\d{2}-\d{2}(?=_UTC)')
          	  datetime="${date_part} ${time_part//-/:}"
         	   exiftool -overwrite_original -AllDates="$datetime" "$file_name" > /dev/null
			done
			echo "	Complete!"
			cd ..
		else
			echo "  Operation canceled."
		fi
    done
    media_scan_intsd
    finished_message
}

organizeInstagram() {
	local directories=("$intsd/Pictures/MyInsta"	"$intsd/Pictures/Instander")
	local image_types=("jpg" "jpeg")
	local video_types=("mp4")
	for dir in "${directories[@]}"; do
		if [ -d "$dir" ]; then
			cd "$dir" || continue
			for type in "${image_types[@]}"; do
				su -c "find . -type f -name '*.$type' -exec mv {} '$dir/instagram_images' \;" > /dev/null
			done
			for type in "${video_types[@]}"; do
				su -c "find . -type f -name '*.$type' -exec mv {} '$dir/instagram_videos' \;" > /dev/null
			done
			echo "	Operation successful in $dir!"
		else
			echo "Skipping: $dir directory does not exist!"
		fi
		one_line
	done
	cd
	media_scan_intsd
	finished_message
}

oneshot_hacker()	{
	case $1 in
		(wifiattack)
			sudo python OneShot/oneshot.py -i wlan0 --pixie-dust --pixie-force --write "${@:2}"
			;;
		(wifi_push_button_attack)
			sudo python OneShot/oneshot.py -i wlan0 -K --push-button-connect --write "${@:2}"
			;;
		(*)
			echo "	Internal error!"
			exit 1
			;;
	esac
	two_line
	if [[ -d $extsd ]]; then
		echo " Found external storage! Backing up stored passwords to $extsd..."
		one_line
		local OneShot_reports_directory="OneShot/reports"
		if [[ -d $OneShot_reports_directory ]]; then
			local OneShot_reports_backup_directory="$backup_dir/Configurations/Extra/Termux/reports"
			mkdir -p "$OneShot_reports_backup_directory"  # Create directory if it doesn't exist
			cp -pr "$OneShot_reports_directory/stored.txt" "$OneShot_reports_directory/stored.csv" "$OneShot_reports_backup_directory" \
				&& echo "	Backup complete!" || echo "	Backup failed!"
		else
			echo "	Reports directory not found!"
		fi
	three_line
	fi
}

balanceaudiochannel()	{
	su -c "settings put system master_balance $1"
}

batteryHealth()	{
	one_line
	su -c 'echo "    Battery cycle $(cat /sys/devices/virtual/oplus_chg/battery/battery_cc)"'
	su -c 'echo "    Battery capacity $(cat /sys/devices/virtual/oplus_chg/battery/battery_fcc)"'
	su -c 'echo "    Battery health $(( $(cat /sys/devices/virtual/oplus_chg/battery/battery_fcc) / 50 ))%"'
	three_line
}

trim_cache_system_vendor_data()	{
	su -c "'$busybox_dir' fstrim -v /cache"
	if [[ "$1" == "t1" ]]; then
		su -c "'$busybox_dir' fstrim -v /vendor"
		su -c "'$busybox_dir' fstrim -v /system"
	fi
	su -c "'$busybox_dir' fstrim -v /data"
	finished_message
}

main()	{
	case $1 in
		(bt | bkt)
			backup_restore_termux_and_internal backup_termux
			;;
		(rt | ret)
			backup_restore_termux_and_internal restore_termux
			;;
		(bi | bki)
			backup_restore_termux_and_internal backup_InternalStorage
			;;
		(ri | rei)
			backup_restore_termux_and_internal restore_InternalStorage
			;;
		(compile_m)
				compile_m
			;;
		(d | dex)
			do_dexopt_job
			;;
		(b | balanceaudio)
			balanceaudiochannel "$1"
			;;
		(w | wifihack)
			oneshot_hacker wifiattack "${@:2}"
			;;
		(wph | wififpushhack)
			oneshot_hacker wifi_push_button_attack "${@:2}"
			;;
		(sa | setanim)
			set_animation_duration_scale "${@:2:3}"
			;;
		(sr | setrefr)
			set_refresh_rate "${@:2:2}"
			;;
		(t1 | trim1)
			trim_cache_system_vendor_data "t1"
			;;
		(t2 | trim2)
			trim_cache_system_vendor_data "t2"
			;;
		(instl | instal | instaloader)
			case $2 in
				(i | img | image | images | r | reg | regular)
					instaloader_init "--no-videos" "--login=entropy.observed" "${@:3}"
					;;
				(v | vid | video | videos)
					instaloader_init "--no-pictures" "--login=entropy.observed" "${@:3}"
					;;
				(iv | i_v | imgvid | imgvids | imgsvids | img_vid | imagevideo | image_video)
					instaloader_init "--login=entropy.observed" "${@:3}"
					;;
				(a | adv | advance | advanced)
					instaloader_init "${@:3}"
					;;
				(*)
					echo "	Invalid input for '$1'!"
					;;
			esac
			;;
		(instorg | instaorg | inorg | instagramorganize)
			organizeInstagram
			;;
		(pur | pr)
			purgeRegular
			;;
		(pus | ps)
			purgeSnaptube
			;;
		(mvs | movesnaptube)
			purgeSnaptube
			moveSnaptubedata
			;;
		(cpw | copywhatspp | copywhatsappmedia)
			copy_whatsapp_media
			;;
		(debloat | rebloat)
			app_manager "${@:1:4}"
			;;
		(o | opt | optimize)
			app_manager optimize "${@:2}"
			;;
		(suspend)
			app_manager suspend_app "${@:2:2}"
			;;
		(unsuspend)
			app_manager unsuspend_app "${@:2:2}"
			;;
		(inf | infect)
			app_manager infect_app_data "${@:2:2}"
			;;
		(dinf | imm | disinfect | immunize)
			app_manager disinfect_app_data "${@:2:2}"
			;;
		(p | pa | pan | panic | panik)
			app_manager disable_app e "emergency.txt"
			app_manager infect_app_data e "emergency.txt"
			copy_files_emergency
			emergency_protocol
			;;
		(up | upa | unpan | unpanic | unpanik)
			app_manager disinfect_app_data e "emergency.txt"
			app_manager enable_app e "emergency.txt"
			copy_files_emergency r
			;;
		(disable | disable_app)
			app_manager disable_app "${@:2:2}"
			;;
		(enable | enable_app)
			app_manager enable_app "${@:2:2}"
			;;
		(disablecmp | disable_component | disable_components)
			app_manager disable_component "${@:2:2}"
			;;
		(enablecmp | enable_component | enable_components)
			app_manager enable_component "${@:2:2}"
			;;
		(purge | organize | purgeall | organizeall)
			purgeRegular
			purgeSnaptube
			moveSnaptubedata
			copy_whatsapp_media
			backup_call_recordings
			backup_restore_configurations backup termux_configurations
			;;
		(pmsh | push_m_sh)
			push_m_sh
			;;
		(cpp)
			run_my_cpp ${@:2}
			;;
		(java)
			run_my_java ${@:2}
			;;
		(cltmp | clean_temp | clean_tmp | cleantmp)
			clean_temp
			;;
		(sya | sync_alibi)
			sync_alibi ${@:3}
			;;
		(sync)
			case $2 in
				(alibi)
					sync_alibi ${@:3}
					;;
			esac
			;;
		(acs | aiub_courses_scraper)
			aiub_courses_scraper ${@:2}
			;;
		(setup)
			case $2 in
				(settings)
					setupSettings
					;;
				(phn | phone)
					setupSettings
					app_manager debloat s
					;;
				(termprog | termuxprograms)
					setup_termux_programs "$3"
					;;
				(term | termux)
					setup_oneshot
					setup_termux_programs s
					setup_bash_history
					backup_restore_configurations "restore" "termux_configurations"
					finished_message
					;;
				(termpub | termuxpublic)
					setup_termux_public
					;;
				(onesh | oneshot)
					setup_oneshot
					;;
				(bashhist | bashhistory)
					setup_bash_history
					;;
				(shizuku)
					manipulate_shizuku_and_root shizuku_as_primary
						;;
				(root)
					manipulate_shizuku_and_root root_as_primary
					;;
				(*)
					two_line
					echo "	Invalid input for $1!"
					three_line
					exit 1
					;;
			esac
			;;
		(revert)
			case $2 in
				(shizuku)
					manipulate_shizuku_and_root remove_shizuku
					;;
				(*)
					two_line
					echo "	Invalid input for $1!"
					three_line
					exit 1
					;;
			esac
			;;
		(get)
			if [[ "$2" == "mix" ]] || [[ "$2" == "mixplorer" ]]; then
				fetch_mixplorer
			fi
			;;
		(backup | restore)
			case $2 in
				(callrec | callrecording | callrecordings)
					backup_call_recordings
					;;
				(conf | config | configuration | configurations)
					backup_restore_configurations "$1" "termux_configurations"
					;;
				(all | everything)
					backup_call_recordings
					backup_restore_configurations "$1" "termux_configurations"
					;;
				(pass | password)
					backup_restore_password_database "$1"
					;;
				(wp | wpass | wifipass | wifipassword | wifipasswords)
					backup_wifi_pass_to_github "${@:3}"
					;;
				(termconf | termconfig | termuxconf | termuxconfig | termuxconfiguration | termuxconfigurations | termux_configuration | termux_configurations)
					backup_restore_configurations "$1" "termux_configurations"
					;;
				(*)
					two_line
					echo "	Invalid option for $1!"
					three_line
					exit 1
					;;
			esac
			;;
		(app)
			case $2 in
				(backup | restore)
					case $3 in
						(gboard)
							backup_restore_app "$2" "com.google.android.inputmethod.latin"
							;;
						(nekogram)
							backup_restore_app "$2" "tw.nekomimi.nekogram"
							;;
						(snaptube)
							backup_restore_app "$2" "com.snaptube.premium"
							;;
						(hurry)
							backup_restore_app "$2" "com.samruston.hurry"
							;;
						(o | ot | othr | other)
							case $4 in
								("")
									two_line
									echo "	You did not mention which $1 to $2!"
									three_line
									exit 1
									;;
								(*)
									backup_restore_app "$2" "$4"
									exit 1
									;;
							esac
						(*)
							two_line
							echo "	Invalid option for $1 $2!"
							three_line
							exit 1
							;;
					esac
					;;
				(*)
					two_line
					echo "	Invalid option for $1!"
					three_line
					exit 1
					;;
			esac
			;;
		(msc | medsc | mediasc | mediascanner | mediascannerint)
			case $2 in
				(int | intsd | internal | internalstorage | internal_storage | internalsd | internal_sd)
					media_scan_intsd
					;;
				(ext | extsd | external | externalstorage | external_storage | externalsd | external_sd)
					media_scan_extsd
					;;
				("" | all)
					media_scan_intsd
					media_scan_extsd
					;;
				(*)
					two_line
					echo "	Invalid option for $1!"
					three_line
					exit 1
					;;
			esac
			;;
		(bat | battery)
			batteryHealth
			;;
		(test)
			test "$@"
			;;
		(h | he | hel | help)
			help
			;;
		(*)
			one_line
			echo "   You didn't provide any valid argument. Type 'm h' and press enter to see the list of commands."
			four_line
			;;
	esac
}

main "$@"
