if [ "${BASH_SOURCE%/*}" = ${BASH_SOURCE} ] || [ "${BASH_SOURCE%/*}" = "." ] ; then
  source "./lib/include_all.sh"
else
  source "${BASH_SOURCE%/*}"/lib/include_all.sh
fi

CALENDAR_ADAPTER_SRC="https://github.com/opengapps/all/blob/master/app/com.google.android.syncadapters.calendar/15/nodpi/2015080710.apk?raw=true"
CALENDAR_ADAPTER_DEST="/system/app/CalendarSync/CalendarSync.apk"
# There are multiple versions of this apk avaiable, presumably for other Android versions?
# See https://en.wikipedia.org/wiki/Android_version_history for which numbers correspond to which version
# None-nougat users may need to use a different number than 25
CONTACTS_ADAPTER_SRC="https://github.com/opengapps/all/blob/master/app/com.google.android.syncadapters.contacts/25/nodpi/25.apk?raw=true"
CONTACTS_ADAPTER_DEST="/system/app/ContactSync/ContactSync.apk"

build_contacts_sync() {
  ZIP_NAME="contacts-sync"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${CONTACTS_ADAPTER_DEST}"
  download_source "${CONTACTS_ADAPTER_SRC}" "${BASE}${CONTACTS_ADAPTER_DEST}"
  make_updater_script "${BASE}"
  make_addond_script "${BASE}" "${CONTACTS_ADAPTER_DEST}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_calendar_sync() {
  ZIP_NAME="calendar-sync"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${CALENDAR_ADAPTER_DEST}"
  download_source "${CALENDAR_ADAPTER_SRC}" "${BASE}${CALENDAR_ADAPTER_DEST}"
  make_updater_script "${BASE}"
  make_addond_script "${BASE}" "${CALENDAR_ADAPTER_DEST}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_contacts_calendar_sync() {
  ZIP_NAME="contacts-calendar-sync"
  BASE="${TMP}${ZIP_NAME}"
  make_parents "${BASE}${CONTACTS_ADAPTER_DEST}"
  make_parents "${BASE}${CALENDAR_ADAPTER_DEST}"
  download_source "${CONTACTS_ADAPTER_SRC}" "${BASE}${CONTACTS_ADAPTER_DEST}"
  download_source "${CALENDAR_ADAPTER_SRC}" "${BASE}${CALENDAR_ADAPTER_DEST}"
  make_updater_script "${BASE}"
  make_addond_script "${BASE}" "${CONTACTS_ADAPTER_DEST};${CALENDAR_ADAPTER_DEST}"
  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_contacts_sync
build_calendar_sync
build_contacts_calendar_sync

clean_up
