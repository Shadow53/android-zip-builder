if [ "${BASH_SOURCE%/*}" = ${BASH_SOURCE} ] || [ "${BASH_SOURCE%/*}" = "." ] ; then
  source "./lib/include_all.sh"
else
  source "${BASH_SOURCE%/*}"/lib/include_all.sh
fi

# Using the F-Droid version for two reasons:
# First, I'm not sure which apk on GitHub is the right one (NetworkLocation or UnifiedNLP)
# Second, people are more likely to have F-Droid installed, so this means updates
UNLP_SRC="https://f-droid.org/repo/com.google.android.gms_20187.apk"
UNLP_DEST="/system/app/UnifiedNlp/UnifiedNlp.apk"
MOZ_SRC="https://f-droid.org/repo/org.microg.nlp.backend.ichnaea_20018.apk"
MOZ_DEST="/system/app/MozillaNlpBackend/MozillaNlpBackend.apk"
NOM_SRC="https://f-droid.org/repo/org.microg.nlp.backend.nominatim_20042.apk"
NOM_DEST="/system/app/NominatimNlpBackend/NominatimNlpBackend.apk"

build_unifiednlp() {
  # Verify URLs
  if [ verify_url "${UNLP_SRC}" &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${MOZ_SRC}"  &>/dev/null ]; then exit 1; fi;
  if [ verify_url "${NOM_SRC}"  &>/dev/null ]; then exit 1; fi;

  ZIP_NAME="unifiednlp"
  BASE="${TMP}${ZIP_NAME}"

  make_parents "${BASE}${UNLP_DEST}"
  make_parents "${BASE}${MOZ_DEST}"
  make_parents "${BASE}${NOM_DEST}"

  download_source "${UNLP_SRC}" "${BASE}${UNLP_DEST}"
  download_source "${MOZ_SRC}" "${BASE}${MOZ_DEST}"
  download_source "${NOM_SRC}" "${BASE}${NOM_DEST}"

local SCRIPT=$(cat <<EOF
ui_print("If the installation aborts here, you already have a network location provider installed.");
ui_print("If you have microG installed, it comes bundled with UnifiedNLP.");
ui_print("If you have GApps installed, this version of UnifiedNLP is incompatible.");
ui_print("Checking if GApps or microG is installed...");
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/app/GmsCore"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/priv-app/GmsCore"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/priv-app/GmsCore_update"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/app/PrebuiltGmsCore"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/priv-app/PrebuiltGmsCore"));
assert(run_program("/system/bin/sh", "-c", "test ! -d /system/priv-app/GmsCoreSetupPrebuilt"));
EOF
)

  make_updater_script "${BASE}" "${SCRIPT}"
  make_addond_script "${BASE}" "${UNLP_DEST};${MOZ_DEST};${NOM_DEST}"

  zip_folder "${BASE}" "${DEST}${ZIP_NAME}"
  make_md5sum_file "${DEST}${ZIP_NAME}.zip"
}

build_unifiednlp

clean_up
