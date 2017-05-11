# Include configuration
source ~/.config/android-build-scripts.sh
# Create any missing directories
mkdir -p $ROOT
mkdir -p $DEST
mkdir -p $TMP
# Make sure we have an updated update-binary
echo "Copying update-binary to workspace root"
cp "${BASH_SOURCE%/*}/update-binary" "${ROOT}/update-binary"
cd $TMP
