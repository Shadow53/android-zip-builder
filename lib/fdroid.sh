get_most_recent_url() {
  local REPO="${1}"
  local DOMAIN="$(awk -F/ '{print $3}' <<< ${REPO})"
  local INDEX_FILE="${TMP}/${DOMAIN}.index.xml"
  if [ ! -f "${INDEX_FILE}" ]; then
    download_source "${REPO}/index.xml" "${INDEX_FILE}" &>/dev/null
  fi
  local PKG_NAME="${2}"
  local APK_NAME="$(xmllint --xpath "/fdroid/application[id=\"${PKG_NAME}\"]/package[1]/apkname/text()" ${INDEX_FILE})"
  echo -n "${REPO}/${APK_NAME}"
}
