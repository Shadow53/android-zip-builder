if [ "${BASH_SOURCE%/*}" = ${BASH_SOURCE} ] || [ "${BASH_SOURCE%/*}" = "." ] ; then
  source "./lib/include_all.sh"
else
  source "${BASH_SOURCE%/*}"/lib/include_all.sh
fi

GMS_SRC="$(get_most_recent_url 'https://microg.org/fdroid/repo' 'com.google.android.gms')"
GMS_DEST="/system/app/GmsCore/GmsCore.apk"
GSF_SRC="$(get_most_recent_url 'https://microg.org/fdroid/repo' 'com.google.android.gsf')"
GSF_DEST="/system/app/GsfProxy/GsfProxy.apk"
FAKESTORE_SRC="$(get_most_recent_url 'https://microg.org/fdroid/repo' 'com.android.vending')"
#PLAYSTORE_SRC="https://github.com/opengapps/all/blob/master/priv-PlayStoreapp/com.android.vending/14/240-320-480/80802200.apk?raw=true"
PLAYSTORE_SRC="https://gitlab.com/Nanolx/NanoMod/raw/master/Overlay/system/priv-app/Phonesky/Phonesky.apk"
PLAYSTORE_DEST="/system/priv-app/Phonesky/Phonesky.apk"
UNLP_SRC="$(get_most_recent_url 'https://f-droid.org/repo' 'com.google.android.gms')"
UNLP_DEST="/system/app/UnifiedNlp/UnifiedNlp.apk"
MOZ_SRC="$(get_most_recent_url 'https://f-droid.org/repo' 'org.microg.nlp.backend.ichnaea')"
MOZ_DEST="/system/app/MozillaNlpBackend/MozillaNlpBackend.apk"
NOM_SRC="$(get_most_recent_url 'https://f-droid.org/repo' 'org.microg.nlp.backend.nominatim')"
NOM_DEST="/system/app/NominatimNlpBackend/NominatimNlpBackend.apk"

extract_microg_libs() {
  # Unzip the microG library because we're installing to /system
  local PARENT="${1}"
  local ROOT="$(pwd)"
  cd "${PARENT%/*}"
  echo "Extracting libraries from GmsCore"
  unzip -o "${PARENT}" "lib*" &>/dev/null
  cd "${ROOT}"

  addond_backup_file "/system/app/GmsCore/lib/x86/libvtm-jni.so"
  addond_backup_file "/system/app/GmsCore/lib/x86_64/libvtm-jni.so"
  addond_backup_file "/system/app/GmsCore/lib/arm64-v8a/libvtm-jni.so"
  addond_backup_file "/system/app/GmsCore/lib/armeabi/libvtm-jni.so"
  addond_backup_file "/system/app/GmsCore/lib/armeabi-v7a/libvtm-jni.so"
}

add_microg() {
  if [ verify_url "${GMS_SRC}" &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${GSF_SRC}"  &>/dev/null ]; then exit 1; fi;

  make_parents "${BASE}${GMS_DEST}"
  make_parents "${BASE}${GSF_DEST}"

  download_source "${GMS_SRC}" "${BASE}${GMS_DEST}"
  download_source "${GSF_SRC}" "${BASE}${GSF_DEST}"

  updater_remove_files "/system/app/GmsCore"
  updater_remove_files "/system/priv-app/GmsCore"
  updater_remove_files "/system/priv-app/GmsCore_update"
  updater_remove_files "/system/app/PrebuiltGmsCore"
  updater_remove_files "/system/priv-app/PrebuiltGmsCore"
  updater_remove_files "/system/priv-app/GmsCoreSetupPrebuilt"
  updater_remove_files "/system/app/GsfProxy"
  updater_remove_files "/system/priv-app/GoogleServicesFramework"
  updater_remove_files "/system/priv-app/GoogleLoginService"

  addond_backup_file "${GMS_DEST}"
  addond_backup_file "${GSF_DEST}"

  set_perms_app "com.google.android.gms"
  # Grant signature spoofing
  add_permission "FAKE_PACKAGE_SIGNATURE"
  # Need to know the location to provide it
  add_permission "ACCESS_COARSE_LOCATION"
  add_permission "ACCESS_FINE_LOCATION"
  # Asked for in self-check
  add_permission "READ_PHONE_STATE"
  # Required for providing a Google account
  add_permission "AUTHENTICATE_ACCOUNTS"
  add_permission "GET_ACCOUNTS"
  add_permission "MANAGE_ACCOUNTS"
  add_permission "USE_CREDENTIALS"
  # Part of Doze whitelisting, I think?
  add_permission "WAKE_LOCK"
  # Asked for in self-check
  add_permission "WRITE_EXTERNAL_STORAGE"
  add_permission "READ_EXTERNAL_STORAGE"
  # Reboot no longer required to bind to system
  add_permission "INSTALL_LOCATION_PROVIDER"

  extract_microg_libs "${BASE}${GMS_DEST}"

  doze_whitelist "com.google.android.gms"
}

add_playstore() {
  local PLAYSTORE_SRC="${1}"
  if [ verify_url "${PLAYSTORE_SRC}"  &>/dev/null ]; then exit 1; fi;
  make_parents "${BASE}${PLAYSTORE_DEST}"
  download_source "${PLAYSTORE_SRC}" "${BASE}${PLAYSTORE_DEST}"
  updater_remove_files "/system/priv-app/PlayStore"
  updater_remove_files "/system/priv-app/FakeStore"
  updater_remove_files "/system/priv-app/Phonesky"
  addond_backup_file "${PLAYSTORE_DEST}"
  # The below functions add files to be backed up by addon.d
  # Need to be called before make_addond_script
  set_perms_app "com.android.vending"
  # Using FakeStore, grant signature spoofing
  add_permission "android.permission.FAKE_PACKAGE_SIGNATURE"
}

add_unlp_backends() {
  if [ verify_url "${MOZ_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${NOM_SRC}"  &>/dev/null ]; then exit 1; fi;
  echo "Downloading UNLP Backends"
  make_parents "${BASE}${MOZ_DEST}"
  make_parents "${BASE}${NOM_DEST}"
  download_source "${MOZ_SRC}" "${BASE}${MOZ_DEST}"
  download_source "${NOM_SRC}" "${BASE}${NOM_DEST}"
  addond_backup_file "${MOZ_DEST}"
  addond_backup_file "${NOM_DEST}"

  set_perms_app "org.microg.nlp.backend.ichnaea"
  # Wifi-based location
  add_permission "ACCESS_WIFI_STATE"
  add_permission "CHANGE_WIFI_STATE"
  add_permission "ACCESS_NETWORK_STATE"
  # Cell tower-based location
  add_permission "READ_PHONE_STATE"
  # Location
  add_permission "ACCESS_COARSE_LOCATION"
  add_permission "ACCESS_FINE_LOCATION"
}

add_unifiednlp() {
  if [ verify_url "${UNLP_SRC}" &>/dev/null ]; then exit 1; fi;
  make_parents "${BASE}${UNLP_DEST}"
  download_source "${UNLP_SRC}" "${BASE}${UNLP_DEST}"

  set_perms_app "com.google.android.gms"
  add_permission "ACCESS_COARSE_LOCATION"
  add_permission "ACCESS_COARSE_UPDATES"
  add_permission "INSTALL_LOCATION_PROVIDER"

  addond_backup_file "${UNLP_DEST}"
}

build_microg_without_playstore() {
  ZIP_NAME="microg"
  BASE="${TMP}${ZIP_NAME}"

  add_microg
  add_playstore "${FAKESTORE_SRC}"
  add_unlp_backends

  make_updater_script "${BASE}"

  write_perms_file "${BASE}" "${ZIP_NAME}"

  save_sysconfig_options "${BASE}"

  make_addond_script "${BASE}"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_microg_with_playstore() {
  ZIP_NAME="microg-playstore"
  BASE="${TMP}${ZIP_NAME}"

  add_microg
  add_playstore "${PLAYSTORE_SRC}"
  add_unlp_backends

  make_updater_script "${BASE}"

  write_perms_file "${BASE}" "${ZIP_NAME}"

  save_sysconfig_options "${BASE}"

  make_addond_script "${BASE}"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_standalone_playstore() {
  ZIP_NAME="playstore"
  BASE="${TMP}${ZIP_NAME}"

  add_playstore

  make_updater_script "${BASE}"

  make_addond_script "${BASE}"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_unifiednlp() {
  ZIP_NAME="unifiednlp"
  BASE="${TMP}${ZIP_NAME}"

local SCRIPT=$(cat <<EOF
ui_print("If the installation aborts here, you already have a network location provider installed.");
ui_print("If you have microG installed, it comes bundled with UnifiedNLP.");
ui_print("If you have GApps installed, this version of UnifiedNLP is incompatible.");
ui_print("Checking if GApps or microG is installed...");
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/app/GmsCore"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/priv-app/GmsCore"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/priv-app/GmsCore_update"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/app/PrebuiltGmsCore"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/priv-app/PrebuiltGmsCore"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/priv-app/GmsCoreSetupPrebuilt"));
EOF
)

  write_perms_file "${BASE}" "${ZIP_NAME}"

  make_updater_script "${BASE}" "${SCRIPT}"

  make_addond_script "${BASE}"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_microg_with_playstore
echo
build_microg_without_playstore
echo
build_standalone_playstore
echo
build_unifiednlp

clean_up
