#!/bin/sh

set -eu

PACKAGE=wine
DESKTOP=wine.desktop
ICON=wine.svg

export ARCH="$(uname -m)"
export APPIMAGE_EXTRACT_AND_RUN=1
export VERSION="$(wget -qO- https://github.com/mmtrt/Wine-Builds/releases/expanded_assets/stable | grep -Eo '/wine-[0-9].*xz"' | cut -d'-' -f2 | head -1)"

URUNTIME="https://github.com/VHSgunzo/uruntime/releases/latest/download/uruntime-appimage-dwarfs-$ARCH"
URUNTIME_LITE="https://github.com/VHSgunzo/uruntime/releases/latest/download/uruntime-appimage-dwarfs-lite-$ARCH"
UPINFO="gh-releases-zsync|$(echo "$GITHUB_REPOSITORY" | tr '/' '|')|test7|*$ARCH.AppImage.zsync"
LIB4BN="https://raw.githubusercontent.com/VHSgunzo/sharun/refs/heads/main/lib4bin"

# Prepare AppDir
mkdir -p ./AppDir/bin ./AppDir/usr/bin ./AppDir/usr/share/applications ./AppDir/usr/share/icons
cd ./AppDir

ls -al
ls -al ./usr/share/applications/

cat > ./usr/share/applications/$DESKTOP << EOF
[Desktop Entry]
X-AppImage-Arch=$ARCH
X-AppImage-Version=$VERSION
X-AppImage-Name=$PACKAGE
Name=$PACKAGE
Exec=AppRun
Icon=$PACKAGE
Type=Application
Terminal=false
Categories=Utility;
EOF

ls -al ./usr/share/applications/
cp ./usr/share/applications/$DESKTOP ./
cp ../"$ICON" ./usr/share/icons
cp ../"$ICON" ./
ln -s "$ICON" .DirIcon.svg


# ADD LIBRARIES
wget "$LIB4BN" -O ./lib4bin
chmod +x ./lib4bin
./lib4bin -p -v -s -k "$(command -v wine)"

# CREATE APPRUN
echo '#!/bin/sh
CURRENTDIR="$(dirname "$(readlink -f "${0}")")"

# WINE env
export WINE="$CURRENTDIR/bin/wine"
export WINEDEBUG=${WINEDEBUG:-"fixme-all"}
export WINEPREFIX=${WINEPREFIX:-"$HOME/.wine-appimage"}
export WINESERVER="$CURRENTDIR/bin/wineserver"

# DXVK env
export DXVK_HUD=${DXVK_HUD:-"0"}
export DXVK_LOG_LEVEL=${DXVK_LOG_LEVEL:-"none"}
export DXVK_STATE_CACHE=${DXVK_STATE_CACHE:-"0"}
export DXVK_CONFIG_FILE=${DXVK_CONFIG_FILE:-"$progHome/dxvk.conf"}

# check gpu vendor
VENDOR=$(glxinfo -B | grep "OpenGL vendor")

if [[ $VENDOR == *"Intel"* ]]; then
  export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/intel_icd.i686.json:/usr/share/vulkan/icd.d/intel_icd.x86_64.json"
elif [[ $VENDOR == *"NVIDIA"* ]]; then
  export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/nvidia_icd.json"
elif [[ $VENDOR == *"Radeon"* ]]; then
  export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json"
fi

# Load winecfg if no arguments given
APPLICATION=""
if [ -z "$*" ] ; then
  APPLICATION="winecfg"
fi

# Allow the AppImage to be symlinked to e.g., /bin/wineserver
if [ -n "$APPIMAGE" ] ; then
  BINARY_NAME=$(basename "$ARGV0")
else
  BINARY_NAME=$(basename "$0")
fi

if [ -n "$1" ] && [ -e "$CURRENTDIR/bin/$1" ] ; then
  MAIN="$CURRENTDIR/bin/$1" ; shift
elif [ -e "$CURRENTDIR/bin/$BINARY_NAME" ] ; then
  MAIN="$CURRENTDIR/bin/$BINARY_NAME"
else
  MAIN="$CURRENTDIR/bin/wine"
fi

if [ -z "$APPLICATION" ] ; then
"$MAIN" "$@"
else
"$MAIN" "$APPLICATION"
fi' > ./AppRun
chmod +x ./AppRun

# MAKE APPIMAGE WITH URUNTIME
cd ..
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime
wget --retry-connrefused --tries=30 "$URUNTIME_LITE" -O ./uruntime-lite
chmod +x ./uruntime*

# Keep the mount point (speeds up launch time)
sed -i 's|URUNTIME_MOUNT=[0-9]|URUNTIME_MOUNT=0|' ./uruntime-lite

#Add udpate info to runtime
echo "Adding update information \"$UPINFO\" to runtime..."
./uruntime-lite --appimage-addupdinfo "$UPINFO"

echo "Generating AppImage..."
./uruntime --appimage-mkdwarfs -f \
	--set-owner 0 --set-group 0 \
	--no-history --no-create-timestamp \
	--compression zstd:level=22 -S26 -B8 \
	--header uruntime-lite \
	-i ./AppDir -o ./"$PACKAGE"-"$VERSION"-"$ARCH".AppImage

echo "Generating zsync file..."
zsyncmake *.AppImage -u *.AppImage

mv ./*.AppImage* ../
cd ..
echo "All Done!"
