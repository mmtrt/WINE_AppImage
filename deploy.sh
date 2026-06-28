#!/bin/sh

set -eu

export ARCH="$(uname -m)"
export VERSION="staging_$(wget -qO- https://github.com/mmtrt/Wine-Builds/releases/expanded_assets/latest | grep -Eo '[0-9].*xz"' | sed -r 's|-amd64| |;/wcp/d' | head -1 | awk '{print $1}')"
export OUTNAME=wine-"$VERSION"-"$ARCH".AppImage
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|$(echo "$GITHUB_REPOSITORY" | tr '/' '|')|test7|*$ARCH.AppImage.zsync"
export ICON=wine.svg
export DESKTOP=/usr/share/applications/wine.desktop
export APPNAME=wine
export DEPLOY_SDL=1
export DEPLOY_PIPEWIRE=1
export DEPLOY_GSTREAMER=1
export DEPLOY_VULKAN=1
export DEPLOY_OPENGL=1

# Deploy dependencies
mkdir -p /tmp/wine
WINEPREFIX=/tmp/wine quick-sharun \
	/usr/bin/wine*             \
	/usr/lib/wine              \
	/usr/bin/msidb             \
	/usr/bin/msiexec           \
	/usr/bin/notepad           \
	/usr/bin/regedit           \
	/usr/bin/regsvr32          \
	/usr/bin/widl              \
	/usr/bin/wmc               \
	/usr/bin/wrc               \
	/usr/bin/function_grep.pl  \
	/usr/bin/cabextract        \
	/usr/lib/libfreetype.so*   \
	/usr/lib/libharfbuzz*      \
	/usr/lib/libgraphite*      \
	/usr/lib/libavcodec.so*    \
	/usr/lib/libavdevice.so*   \
	/usr/lib/libavfilter.so*   \
	/usr/lib/libavformat.so*   \
	/usr/lib/libavutil.so*     \
	/usr/lib/libswresample.so* \
	/usr/lib/libswscale.so*    \
	/usr/bin/wget              \
	/usr/bin/zenity

# Install latest winetricks
wget --retry-connrefused --tries=30 https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O ./AppDir/bin/winetricks
chmod +x ./AppDir/bin/winetricks

# alright here the pain starts
ln -sr ./AppDir/lib/wine/x86_64-unix/*.so* ./AppDir/bin

# this gets broken by sharun somehow
kek=.$(tr -dc 'A-Za-z0-9_=-' < /dev/urandom | head -c 10)
rm -f ./AppDir/lib/wine/x86_64-unix/wine
cp /usr/lib/wine/x86_64-unix/wine ./AppDir/lib/wine/x86_64-unix/wine
patchelf --set-interpreter /tmp/"$kek" ./AppDir/lib/wine/x86_64-unix/wine
# we used to run patchelf --add-needed anylinux.so on the wine binary
# but after 11.8 this causes the binary to break horribly:
# AppDir/lib/wine/x86_64-unix/wine: oops... not enough space for load commands
# so we will ahve to make sure anylinux.so loads by adding it as a dependency to the libc
patchelf --add-needed anylinux.so ./AppDir/shared/lib/libc.so.6

cat <<EOF > ./AppDir/bin/random-linker.src.hook
#!/bin/sh
cp -f "\$APPDIR"/shared/lib/ld-linux*.so* /tmp/"$kek"
EOF
chmod +x ./AppDir/bin/*.hook

# Set the lib path to also use wine libs
echo 'LD_LIBRARY_PATH=${APPDIR}/lib:${APPDIR}/lib/pulseaudio:${APPDIR}/lib/alsa-lib:${APPDIR}/lib/wine/x86_64-unix' >> ./AppDir/.env

# lib/wine/x86_64-unix/wine will try to execute a relative ../../bin/wineserver
# which resolves to shared/bin/wineserver and it is wrong
# so we have to make AppDir/shared/lib the symlink and AppDir/lib the real directory
# that way ../../bin/wineserver resolves to the sharun hardlink
if [ -L ./AppDir/lib ]; then
	rm -f ./AppDir/lib
	mv ./AppDir/shared/lib ./AppDir
	ln -sr ./AppDir/lib ./AppDir/shared
fi

# Turn AppDir into AppImage
quick-sharun --make-appimage
