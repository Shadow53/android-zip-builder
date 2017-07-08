if [ "${BASH_SOURCE%/*}" = ${BASH_SOURCE} ] || [ "${BASH_SOURCE%/*}" = "." ] ; then
  source "./lib/include_all.sh"
else
  source "${BASH_SOURCE%/*}"/lib/include_all.sh
fi

# The swipe libraries are arch-specific :/
KEYBOARDDECODER_X86_64_SRC="https://github.com/opengapps/x86_64/blob/master/lib64/23/libjni_keyboarddecoder.so?raw=true"
KEYBOARDDECODER_X86_SRC="https://github.com/opengapps/x86/blob/master/lib/23/libjni_keyboarddecoder.so?raw=true"
KEYBOARDDECODER_ARM64_SRC="https://github.com/opengapps/arm64/blob/master/lib64/23/libjni_keyboarddecoder.so?raw=true"
KEYBOARDDECODER_ARM_SRC="https://github.com/opengapps/arm/blob/master/lib/23/libjni_keyboarddecoder.so?raw=true"
KEYBOARDDECODER_32_DEST="/system/lib/libjni_keyboarddecoder.so"
KEYBOARDDECODER_64_DEST="/system/lib64/libjni_keyboarddecoder.so"

LATINIMEGOOGLE_X86_64_SRC="https://github.com/opengapps/x86_64/blob/master/lib64/23/libjni_latinimegoogle.so?raw=true"
LATINIMEGOOGLE_X86_SRC="https://github.com/opengapps/x86/blob/master/lib/23/libjni_latinimegoogle.so?raw=true"
LATINIMEGOOGLE_ARM64_SRC="https://github.com/opengapps/arm64/blob/master/lib64/23/libjni_latinimegoogle.so?raw=true"
LATINIMEGOOGLE_ARM_SRC="https://github.com/opengapps/arm/blob/master/lib/23/libjni_latinimegoogle.so?raw=true"
LATINIMEGOOGLE_32_DEST="/system/lib/libjni_latinimegoogle.so"
LATINIMEGOOGLE_64_DEST="/system/lib64/libjni_latinimegoogle.so"

build_swipe_lib_arm() {
  ZIP_NAME="swipelib-arm"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${KEYBOARDDECODER_32_DEST}"
  make_parents "${BASE}${LATINIMEGOOGLE_32_DEST}"
  download_source "${KEYBOARDDECODER_ARM_SRC}" "${BASE}${KEYBOARDDECODER_32_DEST}"
  download_source "${LATINIMEGOOGLE_ARM_SRC}" "${BASE}${LATINIMEGOOGLE_32_DEST}"
  make_updater_script "${BASE}"
  addond_backup_file "${KEYBOARDDECODER_32_DEST}"
  addond_backup_file "${LATINIMEGOOGLE_32_DEST}"
  make_addond_script "${BASE}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_swipe_lib_arm64() {
  ZIP_NAME="swipelib-arm64"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${KEYBOARDDECODER_64_DEST}"
  make_parents "${BASE}${LATINIMEGOOGLE_64_DEST}"
  download_source "${KEYBOARDDECODER_ARM64_SRC}" "${BASE}${KEYBOARDDECODER_64_DEST}"
  download_source "${LATINIMEGOOGLE_ARM64_SRC}" "${BASE}${LATINIMEGOOGLE_64_DEST}"
  make_updater_script "${BASE}"
  addond_backup_file "${KEYBOARDDECODER_64_DEST}"
  addond_backup_file "${LATINIMEGOOGLE_64_DEST}"
  make_addond_script "${BASE}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_swipe_lib_x86() {
  ZIP_NAME="swipelib-x86"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${KEYBOARDDECODER_32_DEST}"
  make_parents "${BASE}${LATINIMEGOOGLE_32_DEST}"
  download_source "${KEYBOARDDECODER_X86_SRC}" "${BASE}${KEYBOARDDECODER_32_DEST}"
  download_source "${LATINIMEGOOGLE_X86_SRC}" "${BASE}${LATINIMEGOOGLE_32_DEST}"
  make_updater_script "${BASE}"
  addond_backup_file "${KEYBOARDDECODER_32_DEST}"
  addond_backup_file "${LATINIMEGOOGLE_32_DEST}"
  make_addond_script "${BASE}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_swipe_lib_x86_64() {
  ZIP_NAME="swipelib-x86_64"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${KEYBOARDDECODER_64_DEST}"
  make_parents "${BASE}${LATINIMEGOOGLE_64_DEST}"
  download_source "${KEYBOARDDECODER_X86_64_SRC}" "${BASE}${KEYBOARDDECODER_64_DEST}"
  download_source "${LATINIMEGOOGLE_X86_64_SRC}" "${BASE}${LATINIMEGOOGLE_64_DEST}"
  make_updater_script "${BASE}"
  addond_backup_file "${KEYBOARDDECODER_64_DEST}"
  addond_backup_file "${LATINIMEGOOGLE_64_DEST}"
  make_addond_script "${BASE}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_swipe_lib_x86_64
build_swipe_lib_x86
build_swipe_lib_arm
build_swipe_lib_arm64

clean_up
