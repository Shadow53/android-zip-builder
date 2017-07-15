set_perms_app() {
  if [ -z "${DEFAULT_PERMS_STRING}" ]; then
    DEFAULT_PERMS_STRING=$"<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<exceptions>"
  else
    # Assume we are adding a new app's permissions, end the last's xml
    DEFAULT_PERMS_STRING="${DEFAULT_PERMS_STRING}
  </exception>"
  fi
  DEFAULT_PERMS_STRING=$"${DEFAULT_PERMS_STRING}
  <exception package=\"${1}\" >"
}

add_permission() {
  local NEW_PERMISSION
  NEW_PERMISSION=""
  if [ -z "${1##*.*}" ]; then
    NEW_PERMISSION="${1}"
  else
    NEW_PERMISSION="android.permission.${1}"
  fi
  DEFAULT_PERMS_STRING="${DEFAULT_PERMS_STRING}
    <permission name=\"${NEW_PERMISSION}\" fixed=\"false\" />"
}

write_perms_file() {
  if [ -n "${DEFAULT_PERMS_STRING}" ]; then
    # End last app's permissions
    DEFAULT_PERMS_STRING="${DEFAULT_PERMS_STRING}
  </exception>
</exceptions>"

    local BASE="${1}"
    local ZIP_NAME="${2}"
    local FILE_NAME="/system/etc/default-permissions/${ZIP_NAME}-permissions.xml"
    local FULL_FILE_NAME="${BASE}${FILE_NAME}"
    make_parents "${FULL_FILE_NAME}"
    echo "${DEFAULT_PERMS_STRING}" > "${FULL_FILE_NAME}"
    addond_backup_file "${FILE_NAME}"
    # Reset global vars
    DEFAULT_PERMS_STRING=""
  fi
}

doze_whitelist() {
  #allow-in-power-save
  #allow-in-data-usage-save
  #allow-in-power-save-except-idle
  echo "Adding ${1} to Doze whitelist"
  DOZE_WHITELIST=$"${DOZE_WHITELIST}
    <allow-in-power-save package=\"${1}\" />
    <allow-in-data-usage-save package=\"${1}\" />"
}

system_user_whitelist() {
  echo "Granting system user to ${1}"
  SYSTEM_USER_WHITELIST_APPS=$"${SYSTEM_USER_WHITELIST_APPS}
    <system-user-whitelisted-app package=\"${1}\" />"
}

system_user_blacklist() {
  echo "Removing system user from ${1}"
  SYSTEM_USER_BLACKLIST_APPS=$"${SYSTEM_USER_BLACKLIST_APPS}
    <system-user-blacklisted-app package=\"${1}\" />"
}

save_sysconfig_options() {
  echo "Saving sysconfig options (Doze, system user)"
  local BASE="${1}"
  local BASE_NAME
  if [ -n "${ZIP_NAME}" ]; then
    BASE_NAME="${ZIP_NAME}"
  else
    BASE_NAME="custom"
  fi
  local FILE_NAME="/system/etc/sysconfig/${BASE_NAME}.xml"
  local FULL_FILE_NAME="${BASE}${FILE_NAME}"
  make_parents "${FULL_FILE_NAME}"

cat > "${FULL_FILE_NAME}" <<EOT
<?xml version="1.0" encoding="utf-8"?>
<config>
    <!-- These are the standard packages that are white-listed to always have internet
         access while in power save mode, even if they aren't in the foreground. -->
    ${DOZE_WHITELIST}

    <!-- These are the packages that are white-listed to be able to run as system user -->
    ${SYSTEM_USER_WHITELIST_APPS}

    <!-- These are the packages that are uninstalled for system user -->
    ${SYSTEM_USER_BLACKLIST_APPS}
</config>
EOT
  addond_backup_file "${FILE_NAME}"
  # Reset global vars
  DOZE_WHITELIST=""
  SYSTEM_USER_WHITELIST_APPS=""
  SYSTEM_USER_BLACKLIST_APPS=""
}
