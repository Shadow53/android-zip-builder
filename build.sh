#!/usr/bin/env bash

# Not sure if widevine is necessary or desired, so this is remaining commented for later reference
# WIDEVINE_SRC="https://github.com/opengapps/all/blob/master/framework/25/com.google.widevine.software.drm.jar?raw=true"
# WIDEVINE_DEST="/system/framework/com.google.widevine.software.drm.jar



verify_urls() {
  if [ verify_url "${GMS_SRC}" &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${GSF_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${FAKESTORE_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${PLAYSTORE_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${EMOJIONE_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${KEYBOARDDECODER_ARM_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${KEYBOARDDECODER_ARM64_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${KEYBOARDDECODER_X86_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${KEYBOARDDECODER_X86_64_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${LATINIMEGOOGLE_ARM_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${LATINIMEGOOGLE_ARM64_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${LATINIMEGOOGLE_X86_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${LATINIMEGOOGLE_X86_64_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${CONTACTS_ADAPTER_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${CALENDAR_ADAPTER_SRC}"  &>/dev/null ]; then exit 1; fi;
  #if [ verify_url "${GMS_SRC}"  &>/dev/null ]; then exit 1; fi;
}


















build_custom() {
  echo "Not implemented"
}

build_all() {
  build_microg_without_playstore
  build_microg_with_playstore
  build_standalone_playstore
  build_swipe_lib_arm
  build_swipe_lib_arm64
  build_swipe_lib_x86
  build_swipe_lib_x86_64
  build_contacts_sync
  build_calendar_sync
  build_contacts_calendar_sync
  build_emojione
}

verify_urls
#build_microg_without_playstore
#build_emojione
build_all
rm -r "${TMP}"
