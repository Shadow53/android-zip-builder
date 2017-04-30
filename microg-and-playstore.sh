GMS_SRC="https://microg.org/fdroid/repo/com.google.android.gms-10545440.apk"
GMS_DEST="/system/app/GmsCore/GmsCore.apk"
GSF_SRC="https://microg.org/fdroid/repo/com.google.android.gsf-8.apk"
GSF_DEST="/system/app/GsfProxy/GsfProxy.apk"
FAKESTORE_SRC="https://microg.org/fdroid/repo/com.android.vending-16.apk"
FAKESTORE_DEST="/system/priv-app/FakeStore/FakeStore.apk"
PLAYSTORE_SRC="https://github.com/opengapps/all/blob/master/priv-app/com.android.vending/14/240-320-480/80771700.apk?raw=true"
PLAYSTORE_DEST="/system/priv-app/PlayStore/PlayStore.apk"

build_microg_without_playstore() {
  # Verify URLs
  if [ verify_url "${GMS_SRC}" &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${GSF_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${FAKESTORE_SRC}"  &>/dev/null ]; then exit 1; fi;

  ZIP_NAME="microg"
  BASE="${TMP}${ZIP_NAME}"

  make_parents "${BASE}${GMS_DEST}"
  make_parents "${BASE}${GSF_DEST}"
  make_parents "${BASE}${FAKESTORE_DEST}"

  wget -c -O "${BASE}${GMS_DEST}" "${GMS_SRC}"
  wget -c -O "${BASE}${GSF_DEST}" "${GSF_SRC}"
  wget -c -O "${BASE}${FAKESTORE_DEST}" "${FAKESTORE_SRC}"

local SCRIPT=$(cat <<EOF
ui_print("Removing any conflicting apps");
delete_recursive("/system/app/GmsCore", "/system/priv-app/GmsCore", "/system/priv-app/GmsCore_update", "/system/app/PrebuiltGmsCore", "/system/priv-app/PrebuiltGmsCore", "/system/priv-app/GmsCoreSetupPrebuilt");
delete_recursive("/system/priv-app/PlayStore", "/system/priv-app/FakeStore", "/system/priv-app/Phonesky");
delete_recursive("/system/app/GsfProxy", "/system/priv-app/GoogleServicesFramework", "/system/priv-app/GoogleLoginService");
EOF
)

  make_updater_script "${BASE}" "${SCRIPT}"
  make_addond_script "${BASE}" "${GMS_DEST};${GSF_DEST};${FAKESTORE_DEST};/system/app/GmsCore/lib/x86/libvtm-jni.so;/system/app/GmsCore/lib/x86_64/libvtm-jni.so;/system/app/GmsCore/lib/arm64-v8a/libvtm-jni.so;/system/app/GmsCore/lib/armeabi/libvtm-jni.so;/system/app/GmsCore/lib/armeabi-v7a/libvtm-jni.so"

  # Unzip the microG library because we're installing to /system
  local ROOT="$(pwd)"
  PARENT="${BASE}${GMS_DEST}"
  cd "${PARENT%/*}"
  unzip "${PARENT}" "lib*"
  cd "${ROOT}"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_microg_with_playstore() {
  if [ verify_url "${GMS_SRC}" &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${GSF_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${PLAYSTORE_SRC}"  &>/dev/null ]; then exit 1; fi;

  ZIP_NAME="microg-playstore"
  BASE="${TMP}${ZIP_NAME}"

  make_parents "${BASE}${GMS_DEST}"
  make_parents "${BASE}${GSF_DEST}"
  make_parents "${BASE}${PLAYSTORE_DEST}"

  wget -c -O "${BASE}${GMS_DEST}" "${GMS_SRC}"
  wget -c -O "${BASE}${GSF_DEST}" "${GSF_SRC}"
  wget -c -O "${BASE}${PLAYSTORE_DEST}" "${PLAYSTORE_SRC}"

local SCRIPT=$(cat <<EOF
ui_print("Removing any conflicting apps");
delete_recursive("/system/app/GmsCore", "/system/priv-app/GmsCore", "/system/priv-app/GmsCore_update", "/system/app/PrebuiltGmsCore", "/system/priv-app/PrebuiltGmsCore", "/system/priv-app/GmsCoreSetupPrebuilt");
delete_recursive("/system/priv-app/PlayStore", "/system/priv-app/FakeStore", "/system/priv-app/Phonesky");
delete_recursive("/system/app/GsfProxy", "/system/priv-app/GoogleServicesFramework", "/system/priv-app/GoogleLoginService");
EOF
)

  make_updater_script "${BASE}" "${SCRIPT}"
  make_addond_script "${BASE}" "${GMS_DEST};${GSF_DEST};${PLAYSTORE_DEST};/system/app/GmsCore/lib/x86/libvtm-jni.so;/system/app/GmsCore/lib/x86_64/libvtm-jni.so;/system/app/GmsCore/lib/arm64-v8a/libvtm-jni.so;/system/app/GmsCore/lib/armeabi/libvtm-jni.so;/system/app/GmsCore/lib/armeabi-v7a/libvtm-jni.so"

  # Unzip the microG library because we're installing to /system
  local ROOT="$(pwd)"
  PARENT="${BASE}${GMS_DEST}"
  cd "${PARENT%/*}"
  unzip "${PARENT}" "lib*"
  cd "${ROOT}"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_standalone_playstore() {
  # Test the URL first
  if [ verify_url "${PLAYSTORE_SRC}"  &>/dev/null ]; then exit 1; fi;

  ZIP_NAME="playstore"
  BASE="${TMP}${ZIP_NAME}"

  make_parents "${BASE}${PLAYSTORE_DEST}"
  wget -c -O "${BASE}${PLAYSTORE_DEST}" "${PLAYSTORE_SRC}"

local SCRIPT=$(cat <<EOF
ui_print("Removing any conflicting apps");
delete_recursive("/system/priv-app/PlayStore", "/system/priv-app/FakeStore", "/system/priv-app/Phonesky");
EOF
)

  make_updater_script "${BASE}" "${SCRIPT}"
  make_addond_script "${BASE}" "${FAKESTORE_DEST}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_microg_with_playstore
build_microg_without_playstore
build_standalone_playstore
