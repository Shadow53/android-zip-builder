if [ "${BASH_SOURCE%/*}" = ${BASH_SOURCE} ] || [ "${BASH_SOURCE%/*}" = "." ] ; then
  source "./lib/include_all.sh"
else
  source "${BASH_SOURCE%/*}"/lib/include_all.sh
fi

EMOJIONE_SRC="https://github.com/Ranks/emojione/blob/master/extras/fonts/emojione-android.ttf?raw=true"
EMOJIONE_DEST="/system/fonts/NotoColorEmoji.ttf"

build_emojione() {
  # Check if the URL is valid. If not, exit.
  if [ verify_url "${EMOJIONE_SRC}"  &>/dev/null ]; then exit 1; fi;
  # The base name of the zip file
  ZIP_NAME="emojione"
  # The directory to serve as the root of the zip
  BASE="${TMP}${ZIP_NAME}"
  # Make all parent directories of the file, placing it under $BASE
  make_parents "${BASE}${EMOJIONE_DEST}"
  # Download the file from SRC to DEST
  download_source "${EMOJIONE_SRC}" "${BASE}${EMOJIONE_DEST}"
  # Make an updater script for a zip at $BASE
  make_updater_script "${BASE}"
  # Make an addon.d script under $BASE to keep the file between upgrades
  addond_backup_file "${EMOJIONE_DEST}"

  make_addond_script "${BASE}"
  # Zip the folder
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  # Make an MD5SUM file
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

# Call the function
build_emojione

clean_up
