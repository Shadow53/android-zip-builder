addond_backup_file() {
  echo "Adding ${1} to addon.d backup files"
  # Add the item to the list
  local PREFIX="/system/"
  ADDOND_BACKUP_FILES=$"${ADDOND_BACKUP_FILES}
${1##$PREFIX}"
}

addond_remove_file() {
  echo "Adding ${1} to addon.d remove files"
  ADDOND_REMOVE_FILES=$"${ADDOND_REMOVE_FILES}
rm -rf ${1}"
}

make_addond_script() {
  echo "Generating addon.d script"
  # Don't make file if nothing is saved
  if [ -n "${ADDOND_BACKUP_FILES}" ] || [ -n "${ADDOND_REMOVE_FILES}" ]; then
    local ADDOND_FOLDER="${1}/system/addon.d"
    mkdir -p "${ADDOND_FOLDER}"
    local file_name="${1##*/}"
    local ADDOND_DEST="${ADDOND_FOLDER}/01-${file_name}.sh" # Should pull the zip's name without .zip
    # Define ADDOND_BACKUP_FILES so that they can be concat'd with a prefix "/system/"
    # For now, just code the newlines into the argument

  # All $s in the heredoc script are escaped so they are not expanded
cat > "${ADDOND_DEST}" <<EOT
#!/sbin/sh
#
# This addon.d script was automatically generated
# It backs up the files installed by ${1##*/}
# If there are any issues, send an email to admin@shadow53.com
# describing the issue
#

. /tmp/backuptool.functions

list_files() {
cat <<EOF${ADDOND_BACKUP_FILES}
EOF
}

case "\$1" in
  backup)
    list_files | while read FILE DUMMY; do
      echo "Backing up \$FILE"
      backup_file \$S/"\$FILE"
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      echo "Restoring \$REPLACEMENT"
      R=""
      [ -n "\$REPLACEMENT" ] && R="\$S/\$REPLACEMENT"
      [ -f "\$C/\$S/\$FILE" -o -L "\$C/\$S/\$FILE" ] && restore_file \$S/"\$FILE" "\$R"
    done
    ${ADDOND_REMOVE_FILES}
  ;;
  pre-backup)
    #Stub
  ;;
  post-backup)
    #Stub
  ;;
  pre-restore)
    #Stub
  ;;
  post-restore)
    #Stub
  ;;
esac
EOT
  # Reset global vars
  ADDOND_BACKUP_FILES=""
  ADDOND_REMOVE_FILES=""
fi
}
