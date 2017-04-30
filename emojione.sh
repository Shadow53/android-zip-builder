EMOJIONE_SRC="https://github.com/Ranks/emojione/blob/master/assets/fonts/emojione-android.ttf?raw=true"
EMOJIONE_DEST="/system/fonts/NotoColorEmoji.ttf"

build_emojione() {
  ZIP_NAME="emojione"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${EMOJIONE_DEST}"
  wget -c -O "${BASE}${EMOJIONE_DEST}" "${EMOJIONE_SRC}"
  make_updater_script "${BASE}"
  make_addond_script "${BASE}" "${EMOJIONE_DEST}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_emojione
