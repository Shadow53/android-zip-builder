make_addond_script() {
  ADDOND_FOLDER="${1}/system/addon.d"
  mkdir -p "${ADDOND_FOLDER}"
  local file_name="${1##*/}"
  ADDOND_DEST="${ADDOND_FOLDER}/01-${file_name}.sh" # Should pull the zip's name without .zip
  # Define ADDOND_BACKUP_FILES so that they can be concat'd with a prefix "/system/"
  # For now, just code the newlines into the argument
  ADDOND_BACKUP_FILES=""
  PREFIX="/system/"
  # From https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash#918931
  while IFS=';' read -ra ADDR; do
      for file in "${ADDR[@]}"; do
          ADDOND_BACKUP_FILES=$"${ADDOND_BACKUP_FILES}
${file##$PREFIX}"
      done
  done <<< "${2}"
  #for file in ${ADDONS_FILES[@]}
  #do
  #  ADDOND_BACKUP_FILES="${ADDOND_BACKUP_FILES}\n${file%$PREFIX}"
  #done

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
}
