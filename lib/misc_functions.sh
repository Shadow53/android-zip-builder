make_md5sum_file() {
  local ROOT="$(pwd)"
  cd "${1%/*}"
  md5sum "${1##*/}" > "${1}.md5"
}

zip_folder() {
  local ROOT="$(pwd)"
  cd "${1}"
  zip -r "${2}.zip" "."
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
