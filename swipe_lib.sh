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
  wget -c -O "${BASE}${KEYBOARDDECODER_32_DEST}" "${KEYBOARDDECODER_ARM_SRC}"
  wget -c -O "${BASE}${LATINIMEGOOGLE_32_DEST}" "${LATINIMEGOOGLE_ARM_SRC}"
  make_updater_script "${BASE}"
  make_addond_script "${BASE}" "${KEYBOARDDECODER_32_DEST};${LATINIMEGOOGLE_32_DEST}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_swipe_lib_arm64() {
  ZIP_NAME="swipelib-arm64"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${KEYBOARDDECODER_64_DEST}"
  make_parents "${BASE}${LATINIMEGOOGLE_64_DEST}"
  wget -c -O "${BASE}${KEYBOARDDECODER_64_DEST}" "${KEYBOARDDECODER_ARM64_SRC}"
  wget -c -O "${BASE}${LATINIMEGOOGLE_64_DEST}" "${LATINIMEGOOGLE_ARM64_SRC}"
  make_updater_script "${BASE}"
  make_addond_script "${BASE}" "${KEYBOARDDECODER_64_DEST};${LATINIMEGOOGLE_64_DEST}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_swipe_lib_x86() {
  ZIP_NAME="swipelib-x86"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${KEYBOARDDECODER_32_DEST}"
  make_parents "${BASE}${LATINIMEGOOGLE_32_DEST}"
  wget -c -O "${BASE}${KEYBOARDDECODER_32_DEST}" "${KEYBOARDDECODER_X86_SRC}"
  wget -c -O "${BASE}${LATINIMEGOOGLE_32_DEST}" "${LATINIMEGOOGLE_X86_SRC}"
  make_updater_script "${BASE}"
  make_addond_script "${BASE}" "${KEYBOARDDECODER_32_DEST};${LATINIMEGOOGLE_32_DEST}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_swipe_lib_x86_64() {
  ZIP_NAME="swipelib-x86_64"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${KEYBOARDDECODER_64_DEST}"
  make_parents "${BASE}${LATINIMEGOOGLE_64_DEST}"
  wget -c -O "${BASE}${KEYBOARDDECODER_64_DEST}" "${KEYBOARDDECODER_X86_64_SRC}"
  wget -c -O "${BASE}${LATINIMEGOOGLE_64_DEST}" "${LATINIMEGOOGLE_X86_64_SRC}"
  make_updater_script "${BASE}"
  make_addond_script "${BASE}" "${KEYBOARDDECODER_64_DEST};${LATINIMEGOOGLE_64_DEST}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}
