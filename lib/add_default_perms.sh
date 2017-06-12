add_default_perms() {
  local BASE="${1}"
  local PKG_NAME="${2}"
  local FILE_ROOT="${BASE}/system/etc/default-permissions/"
  local FILE_NAME="${FILE_ROOT}${PKG_NAME}-permissions.xml"
  mkdir -p "${FILE_ROOT}"
  local PERMS=""
  while IFS=';' read -ra ADDR; do
      for item in "${ADDR[@]}"; do
          PERMS=$"${PERMS}
<permission name=\"android.permission.${item}\" fixed=\"false\"/>"
      done
  done <<< "${3}"

cat > "${FILE_NAME}" <<EOT
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
}
