#!/usr/bin/env bash

# Not sure if widevine is necessary or desired, so this is remaining commented for later reference
# WIDEVINE_SRC="https://github.com/opengapps/all/blob/master/framework/25/com.google.widevine.software.drm.jar?raw=true"
# WIDEVINE_DEST="/system/framework/com.google.widevine.software.drm.jar

if [ "${BASH_SOURCE%/*}" = ${BASH_SOURCE} ] || [ "${BASH_SOURCE%/*}" = "." ] ; then
  SCRIPT_HOME="$(pwd)"
else
  SCRIPT_HOME="${BASH_SOURCE%/*}"
fi

source "${SCRIPT_HOME}/emojione.sh"
source "${SCRIPT_HOME}/microg-and-playstore.sh"
source "${SCRIPT_HOME}/swipe_lib.sh"
source "${SCRIPT_HOME}/sync_adapters.sh"
source "${SCRIPT_HOME}/unifiednlp.sh"
