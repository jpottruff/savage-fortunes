#!/usr/bin/env bash

# Error Output
sf_errcho(){ >&2 echo "$@"; }

# https://stackoverflow.com/a/3232082
sf_confirm() {
    local confirmationText="[y/N]"
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure?} $confirmationText " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

sf_install_prep() {
    command printf "\\nRunning sudo apt update ...\\n\\n"
    command sudo apt update
}

sf_install_required_deps() {
    command printf "\\nInstalling required dependencies ...\\n\\n"
    command sudo apt install -y fortune
    command sudo apt install -y cowsay
    command printf "\\n===> Required dependencies installed!\\n\\n"
}

sf_install_optional_deps() {
    command printf "\\nInstalling optional dependencies ...\\n\\n"
    command sudo apt install -y lolcat
    command sudo apt install -y figlet
    command printf "\\n===> Optional dependencies installed!\\n\\n"
}

# Downloads necessary files from github, creates .dat file, and copies to necessary locations
sf_download_and_copy_files() {
    local tempFolder=./tmp-savage-install
    local cowUrl="https://raw.githubusercontent.com/jpottruff/savage-fortunes/main/cows/savage.cow"
    local cowFile=savage.cow
    local fortunesUrl="https://raw.githubusercontent.com/jpottruff/savage-fortunes/main/fortunes/savage-fortunes"
    local fortunesFile=savage-fortunes
    
    command printf "Starting file download and copy ...\\n"

    ## DOWNLOAD ##
    mkdir $tempFolder
    command printf "\\nDownloading cow\\n"
    curl -o $tempFolder/$cowFile $cowUrl
    command printf "\\nDownloading fortunes\\n"
    curl -o $tempFolder/$fortunesFile $fortunesUrl
    command printf "\\n===> Files downloaded to $tempFolder\\n\\n"
    ##############

    ## COPY COWS ##
    local cowsDirectory=/usr/share/cowsay/cows
    if [ -d $cowsDirectory ]; then 
        command printf "Copying savage cow to $cowsDirectory\\n"
        command sudo cp $tempFolder/$cowFile $cowsDirectory
        command printf "Cow copied!\\n\\n"
    else 
        sf_errcho "Cowsay does not appear in the default location. Cow not copied"
    fi;
    ###############

    ## COPY FORTUNES ##
    local fortuneDirectory=/usr/share/games/fortunes
    if [ -d $fortuneDirectory ]; then 
        # Generate a .dat file
        local fortunesDatFile=savage-fortunes.dat
        command printf "Generating fortunes .dat file\\n"
        command strfile -c % $tempFolder/$fortunesFile $tempFolder/$fortunesDatFile
        command printf "Fortunes .dat file generated!\\n\\n"

        # Copy to location 
        command printf "Copying savage fortunes and .dat file to $fortuneDirectory\\n"
        command sudo cp $tempFolder/$fortunesFile $tempFolder/$fortunesDatFile $fortuneDirectory
        command printf "Fortunes files copied!\\n\\n"
    else 
        sf_errcho "Fortune does not appear in the default location. Fortunes not copied."
    fi;
    ###################
    
    ## Clean up ##
    command printf "Cleaning up\\n"
    command printf "Removing $tempFolder\\n"
    command rm -rf $tempFolder
    command printf "Done\\n"
    ##############    

    command printf "\\n===> Copy and clean up complete\\n\\n"
}

# Appends aliases taking into account if optional deps were installed
sf_append_aliases() {
    command printf "\\nAppending to $FILE_TO_APPEND\\n"   

    ## Setup template 
    local HEADER="#### Savage Fortunes - see https://github.com/jpottruff/savage-fortunes"
    local ALIAS=''
    local FUNC_NAME='savagesay() {'
    local FUNC_BODY=''
    local FUNC_CLOSE='}'
    local FOOTER="####"

    if [ "$OPT_DEPS_INSTALLED" = true ]; then
        ALIAS='alias savagefortune="fortune savage-fortunes | cowsay -f savage | lolcat"'
        FUNC_BODY='figlet -k "$@" | cowsay -f savage -n | lolcat'
    else
        ALIAS='alias savagefortune="fortune savage-fortunes | cowsay -f savage"' 
        FUNC_BODY='cowsay -f savage "$@"'
    fi;

    # Append
    command printf "\\n\\n$HEADER\\n$ALIAS\\n$FUNC_NAME\\n\\t$FUNC_BODY\\n$FUNC_CLOSE\\n$FOOTER\\n" >> "$FILE_TO_APPEND"

    command printf "===> Appended aliases to $FILE_TO_APPEND\\n\\n"
}



#### INSTALL START ####
## Check for bash
if [ -z "${BASH_VERSION}" ] || [ -n "${ZSH_VERSION}" ]; then
    sf_errcho "Error: Please pipe the install script to bash"
    exit 1
fi

## Greeting
command printf "This script will require sudo privileges to install the dependencies and copy the files into the necessary directories\\n"
if ! sf_confirm "Do you wish to contine?"; then
    command printf "\\nAborting installation. Goodbye!\\n\\n"
    exit 0
fi

## Installs
# Prep for install
sf_install_prep

# Install prereqs
sf_install_required_deps

# Install optional deps
command printf "There are some optional dependencies that allow for colorization and additional text formatting\\n"
if sf_confirm "Would you like to install the optional dependencies? (recommended)"; then
    sf_install_optional_deps
    # https://stackoverflow.com/a/21210966
    OPT_DEPS_INSTALLED=true
else
    command printf "\\n===>Skipping optional dependencies\\n\\n"
fi

## Download files and copy to necessary location
sf_download_and_copy_files

## Append aliases to profile files 
if [ -f "$HOME/.bash_aliases" ] && sf_confirm "Would you like to append aliases to $HOME/.bash_aliases"; then
    FILE_TO_APPEND="$HOME/.bash_aliases" 
elif [ -f "$HOME/.bashrc" ] && sf_confirm "Would you like to append aliases to $HOME/.bashrc"; then
    FILE_TO_APPEND="$HOME/.bashrc"
fi

if [ "$FILE_TO_APPEND" ] && sf_confirm "Are you sure: $FILE_TO_APPEND"; then
    sf_append_aliases
    ALIASES_APPENDED=true
else
    command printf "\\nNot appending aliases\\n\\n"
fi

## Exit Messages
if [ "$OPT_DEPS_INSTALLED" = true ]; then
    command figlet -k "All done" | command cowsay -f savage -n | command lolcat
else
    command fortune savage-fortunes | command cowsay -f savage
fi;

if [ "$ALIASES_APPENDED" = true ]; then 
    command printf "Please reload bash to start using the alaises added in $FILE_TO_APPEND\\n\\n"
fi;

exit 0