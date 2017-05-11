# Include configuration
source ~/.config/android-build-scripts.sh
# Create any missing directories
if [ ! -d "$ROOT" ]; then mkdir -p $ROOT; fi
if [ ! -d "$DEST" ]; then mkdir -p $DEST; fi
if [ ! -d "$TMP" ]; then mkdir -p $TMP
# Make sure we have an updated update-binary
echo "Copying update-binary to workspace root"
cp "${BASH_SOURCE%/*}/update-binary" "${ROOT}/update-binary"
cd $TMP
