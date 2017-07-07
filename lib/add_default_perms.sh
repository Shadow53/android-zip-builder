add_default_perms() {
  local BASE="${1}"
  local PKG_NAME="${2}"
  local FILE_ROOT="${BASE}"
  local FILE_NAME="/system/etc/default-permissions/${PKG_NAME}-permissions.xml"
  local FULL_FILE_NAME="${BASE}${FILE_NAME}"
  make_parents "${FULL_FILE_NAME}"
  local PERMS=""
  while IFS=';' read -ra ADDR; do
      for item in "${ADDR[@]}"; do
          PERMS=$"${PERMS}
<permission name=\"android.permission.${item}\" fixed=\"false\"/>"
      done
  done <<< "${3}"

cat > "${FULL_FILE_NAME}" <<EOT
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<!--
    This file contains permissions to be granted by default. Default
    permissions are granted to special platform components and to apps
    that are approved to get default grants. The special components
    are apps that are expected to work out-of-the-box as they provide
    core use cases. Granting these permissions could prevent issues on
    some ROMs or non-clean installations.
-->

<exceptions>
  <exception package="${PKG_NAME}">${PERMS}
  </exception>
</exceptions>
EOT
  addond_backup_file "${FILE_NAME}"
}

doze_whitelist() {
  #allow-in-power-save
  #allow-in-data-usage-save
  #allow-in-power-save-except-idle
  DOZE_WHITELIST=$"${DOZE_WHITELIST}
<allow-in-power-save package=\"${1}\"/>
<allow-in-data-usage-save package=\"${1}\"/>"
}

system_user_whitelist() {
  SYSTEM_USER_WHITELIST_APPS=$"${SYSTEM_USER_WHITELIST_APPS}
<system-user-whitelisted-app package=\"${1}\"/>"
}

system_user_blacklist() {
  SYSTEM_USER_BLACKLIST_APPS=$"${SYSTEM_USER_BLACKLIST_APPS}
<system-user-blacklisted-app package=\"${1}\"/>"
}

save_sysconfig_options() {
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
}
