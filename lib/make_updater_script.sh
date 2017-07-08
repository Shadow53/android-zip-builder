updater_remove_files() {
  echo "Adding ${1} to files to remove"
  if [ -z "${UPDATER_REMOVE}" ]; then
    UPDATER_REMOVE="ui_print(\"Deleting unwanted or conflicting files\");"
  fi
  UPDATER_REMOVE="${UPDATER_REMOVE}
delete_recursive(\"${1}\");"
}

make_updater_script() {
  echo "Generating updater script"
  local UPDATER_FOLDER="${1}/META-INF/com/google/android"
  mkdir -p "${UPDATER_FOLDER}"
  cp "${ROOT}/update-binary" "${UPDATER_FOLDER}/update-binary"
  local UPDATER_DEST="${UPDATER_FOLDER}/updater-script"
  local EXTRA_COMMANDS="${2}"
cat > "${UPDATER_DEST}" <<EOT
ui_print("--------------------------------------");
ui_print("Mounting system");
ifelse(is_mounted("/system"), unmount("/system"));
run_program("/sbin/busybox", "mount", "/system");

$EXTRA_COMMANDS
$UPDATER_REMOVE

ui_print("Extracting to /system");
assert(package_extract_dir("system", "/system") == "t");
ui_print("Setting permissions");
assert(set_metadata_recursive("/system/app", "uid", 0, "gid", 0, "fmode", 0644, "dmode", 0755) == "");
assert(set_metadata_recursive("/system/priv-app", "uid", 0, "gid", 0, "fmode", 0644, "dmode", 0755) == "");
assert(set_metadata_recursive("/system/etc/permissions", "uid", 0, "gid", 0, "fmode", 0644, "dmode", 0755) == "");
assert(set_metadata_recursive("/system/etc/sysconfig", "uid", 0, "gid", 0, "fmode", 0644, "dmode", 0755) == "");
assert(set_metadata_recursive("/system/etc/default-permissions", "uid", 0, "gid", 0, "fmode", 0644, "dmode", 0755) == "");
assert(set_metadata_recursive("/system/fonts", "uid", 0, "gid", 0, "fmode", 0644, "dmode", 0755) == "");
ui_print("Permissions set");

ui_print("Unmounting /system");
unmount("/system");
ui_print("Done!");
ui_print("--------------------------------------");

EOT

  # Reset global vars
  UPDATER_REMOVE=""
}
