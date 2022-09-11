#!/usr/bin/env bash

declare -a profiles
GSETTINGS_PROFILELIST_PATH=org.gnome.Terminal.ProfilesList
DCONF_PROFILE_BASE_PATH=/org/gnome/terminal/legacy/profiles:
# Gets the available GNOME Terminal profiles.
#
# @globwrite profiles
# @return none
# @since 0.2.0
get_profiles() {
  profiles=($(gsettings get "$GSETTINGS_PROFILELIST_PATH" list | tr -d "[]\',"))
}

# Gets the UUID for the given profile name.
#
# @param $1 the name of the profile to get the UUID from
# @return the UUID of the profile, none otherwise
# @since 0.2.0
get_profile_uuid_for_Nord() {
   for idx in ${!profiles[@]}; do
     profile_name=$(dconf read "$DCONF_PROFILE_BASE_PATH"/:"${profiles[idx]}/"visible-name)
     if [[ "$profile_name" == "'Nord'" ]]; then
       printf "%s" "${profiles[idx]}"
       return 0
     fi
   done
}

get_profiles
get_profile_uuid_for_Nord
