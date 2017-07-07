reset() {
  ADDOND_BACKUP_FILES=""
  ADDOND_REMOVE_FILES=""
  UPDATER_REMOVE=""
  DOZE_WHITELIST=""
  SYSTEM_USER_WHITELIST_APPS=""
  SYSTEM_USER_BLACKLIST_APPS=""
}

download_source() {
  local SRC="${1}"
  local DEST="${2}"
  echo "Downloading file to ${DEST}"
  wget -c -O "${DEST}" "${SRC}" &>/dev/null
}

make_md5sum_file() {
  local ROOT="$(pwd)"
  echo "Calculating checksum of ${1}"
  cd "${1%/*}"
  md5sum "${1##*/}" > "${1}.md5"
}

zip_folder() {
  local ROOT="$(pwd)"
  cd "${1}"
  # Remove existing zip if recreating it
  if [ -f "${2}.zip" ] ; then
    rm "${2}.zip"
  fi
  echo "Creating ${2}.zip"
  zip -r "${2}.zip" "." &>/dev/null
  cd "${ROOT}"
}

make_parents() {
  mkdir -p "${1%/*}"
}

verify_url() {
  RESULT=$(curl --raw -I "${1}")
  case "${RESULT}" in
    *"404 Not Found"*) return 2 ;;
    *) return 1 ;;
  esac
}

clean_up() {
  echo "Cleaning up"
  rm -r "${TMP}"
}

function_exists() {
  declare -f -F $1 > /dev/null
  return $?
}
