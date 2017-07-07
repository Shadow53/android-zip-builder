if [ "${BASH_SOURCE%/*}" = ${BASH_SOURCE} ] || [ "${BASH_SOURCE%/*}" = "." ] ; then
  source "./lib/include_all.sh"
else
  source "${BASH_SOURCE%/*}"/lib/include_all.sh
fi

GMS_SRC="https://microg.org/fdroid/repo/com.google.android.gms-11059462.apk"
GMS_DEST="/system/app/GmsCore/GmsCore.apk"
GSF_SRC="https://microg.org/fdroid/repo/com.google.android.gsf-8.apk"
GSF_DEST="/system/app/GsfProxy/GsfProxy.apk"
FAKESTORE_SRC="https://microg.org/fdroid/repo/com.android.vending-16.apk"
#PLAYSTORE_SRC="https://github.com/opengapps/all/blob/master/priv-PlayStoreapp/com.android.vending/14/240-320-480/80802200.apk?raw=true"
PLAYSTORE_SRC="https://github.com/Nanolx/NanoMod/blob/master/Overlay/system/priv-app/Phonesky/Phonesky.apk?raw=true"
PLAYSTORE_DEST="/system/priv-app/Phonesky/Phonesky.apk"
PLAYSTORE_DIFF="https://raw.githubusercontent.com/Nanolx/NanoMod/master/doc/Phonesky.diff"

extract_microg_libs() {
  # Unzip the microG library because we're installing to /system
  local PARENT="${1}"
  local ROOT="$(pwd)"
  cd "${PARENT%/*}"
  echo "Extracting libraries from GmsCore"
  unzip "${PARENT}" "lib*" &>/dev/null
  cd "${ROOT}"

  addond_backup_file "/system/app/GmsCore/lib/x86/libvtm-jni.so"
  addond_backup_file "/system/app/GmsCore/lib/x86_64/libvtm-jni.so"
  addond_backup_file "/system/app/GmsCore/lib/arm64-v8a/libvtm-jni.so"
  addond_backup_file "/system/app/GmsCore/lib/armeabi/libvtm-jni.so"
  addond_backup_file "/system/app/GmsCore/lib/armeabi-v7a/libvtm-jni.so"
}

build_microg_without_playstore() {
  reset
  # Verify URLs
  if [ verify_url "${GMS_SRC}" &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${GSF_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${FAKESTORE_SRC}"  &>/dev/null ]; then exit 1; fi;

  ZIP_NAME="microg"
  BASE="${TMP}${ZIP_NAME}"

  make_parents "${BASE}${GMS_DEST}"
  make_parents "${BASE}${GSF_DEST}"
  make_parents "${BASE}${PLAYSTORE_DEST}"

  download_source "${GMS_SRC}" "${BASE}${GMS_DEST}"
  download_source "${GSF_SRC}" "${BASE}${GSF_DEST}"
  download_source "${FAKESTORE_SRC}" "${BASE}${PLAYSTORE_DEST}"

  # Remove any conflicting gapps installs
  updater_remove_files "/system/app/GmsCore"
  updater_remove_files "/system/priv-app/GmsCore"
  updater_remove_files "/system/priv-app/GmsCore_update"
  updater_remove_files "/system/app/PrebuiltGmsCore"
  updater_remove_files "/system/priv-app/PrebuiltGmsCore"
  updater_remove_files "/system/priv-app/GmsCoreSetupPrebuilt"
  updater_remove_files "/system/priv-app/PlayStore"
  updater_remove_files "/system/priv-app/FakeStore"
  updater_remove_files "/system/priv-app/Phonesky"
  updater_remove_files "/system/app/GsfProxy"
  updater_remove_files "/system/priv-app/GoogleServicesFramework"
  updater_remove_files "/system/priv-app/GoogleLoginService"

  addond_backup_file "${GMS_DEST}"
  addond_backup_file "${GSF_DEST}"
  addond_backup_file "${PLAYSTORE_DEST}"

  make_updater_script "${BASE}" "${SCRIPT}"

  # The below functions add files to be backed up by addon.d
  # Need to be called before make_addond_script
  add_default_perms "${BASE}" "com.android.vending" "FAKE_PACKAGE_SIGNATURE"
  add_default_perms "${BASE}" "com.google.android.gms" "FAKE_PACKAGE_SIGNATURE;ACCESS_COARSE_LOCATION;ACCESS_FINE_LOCATION;READ_PHONE_STATE;AUTHENTICATE_ACCOUNTS;GET_ACCOUNTS;MANAGE_ACCOUNTS;USE_CREDENTIALS;WAKE_LOCK;WRITE_EXTERNAL_STORAGE;READ_EXTERNAL_STORAGE;INSTALL_LOCATION_PROVIDER"
  extract_microg_libs "${BASE}${GMS_DEST}"
  doze_whitelist "com.google.android.gms"
  save_sysconfig_options "${BASE}"

  make_addond_script "${BASE}" "${GMS_DEST};${GSF_DEST};${PLAYSTORE_DEST};"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_microg_with_playstore() {
  reset

  if [ verify_url "${GMS_SRC}" &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${GSF_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${PLAYSTORE_SRC}"  &>/dev/null ]; then exit 1; fi;

  ZIP_NAME="microg-playstore"
  BASE="${TMP}${ZIP_NAME}"

  make_parents "${BASE}${GMS_DEST}"
  make_parents "${BASE}${GSF_DEST}"
  make_parents "${BASE}${PLAYSTORE_DEST}"

  download_source "${GMS_SRC}" "${BASE}${GMS_DEST}"
  download_source "${GSF_SRC}" "${BASE}${GSF_DEST}"
  download_source "${PLAYSTORE_SRC}" "${BASE}${PLAYSTORE_DEST}"

  # Remove any conflicting gapps installs
  updater_remove_files "/system/app/GmsCore"
  updater_remove_files "/system/priv-app/GmsCore"
  updater_remove_files "/system/priv-app/GmsCore_update"
  updater_remove_files "/system/app/PrebuiltGmsCore"
  updater_remove_files "/system/priv-app/PrebuiltGmsCore"
  updater_remove_files "/system/priv-app/GmsCoreSetupPrebuilt"
  updater_remove_files "/system/priv-app/PlayStore"
  updater_remove_files "/system/priv-app/FakeStore"
  updater_remove_files "/system/priv-app/Phonesky"
  updater_remove_files "/system/app/GsfProxy"
  updater_remove_files "/system/priv-app/GoogleServicesFramework"
  updater_remove_files "/system/priv-app/GoogleLoginService"

  addond_backup_file "${GMS_DEST}"
  addond_backup_file "${GSF_DEST}"
  addond_backup_file "${PLAYSTORE_DEST}"

  make_updater_script "${BASE}"

  # The below functions add files to be backed up by addon.d
  # Need to be called before make_addond_script
  add_default_perms "${BASE}" "com.android.vending" "FAKE_PACKAGE_SIGNATURE"
  add_default_perms "${BASE}" "com.google.android.gms" "FAKE_PACKAGE_SIGNATURE;ACCESS_COARSE_LOCATION;ACCESS_FINE_LOCATION;READ_PHONE_STATE;AUTHENTICATE_ACCOUNTS;GET_ACCOUNTS;MANAGE_ACCOUNTS;USE_CREDENTIALS;WAKE_LOCK;WRITE_EXTERNAL_STORAGE;READ_EXTERNAL_STORAGE;INSTALL_LOCATION_PROVIDER"
  extract_microg_libs "${BASE}${GMS_DEST}"
  doze_whitelist "com.google.android.gms"
  save_sysconfig_options "${BASE}"

  # Make addon.d script using generated ADDOND_FILES
  make_addond_script "${BASE}"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_standalone_playstore() {
  reset

  # Test the URL first
  if [ verify_url "${PLAYSTORE_SRC}"  &>/dev/null ]; then exit 1; fi;

  ZIP_NAME="playstore"
  BASE="${TMP}${ZIP_NAME}"

  make_parents "${BASE}${PLAYSTORE_DEST}"
  download_source "${PLAYSTORE_SRC}" "${BASE}${PLAYSTORE_DEST}"

  updater_remove_files "/system/priv-app/PlayStore"
  updater_remove_files "/system/priv-app/FakeStore"
  updater_remove_files "/system/priv-app/Phonesky"

  addond_backup_file "${PLAYSTORE_DEST}"

  add_default_perms "${BASE}" "com.android.vending" "FAKE_PACKAGE_SIGNATURE"

  make_updater_script "${BASE}"

  make_addond_script "${BASE}"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_microg_with_playstore
echo
build_microg_without_playstore
echo
build_standalone_playstore

clean_up
