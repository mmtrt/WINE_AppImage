#!/bin/sh

set -eu

export ARCH="$(uname -m)"
export VERSION="$(wget -qO- https://github.com/mmtrt/Wine-Builds/releases/expanded_assets/stable | grep -Eo '/wine-[0-9].*xz"' | cut -d'-' -f2 | head -1)"
export OUTNAME=wine-stable_"$VERSION"-"$ARCH".AppImage
export UPINFO="gh-releases-zsync|$(echo "$GITHUB_REPOSITORY" | tr '/' '|')|test7|*$ARCH.AppImage.zsync"
export ICON=wine.svg
export DESKTOP=/usr/share/applications/wine.desktop
export APPNAME=wine
export ANYLINUX_LIB=1
export DEPLOY_SDL=1
export DEPLOY_PIPEWIRE=1
export DEPLOY_VULKAN=1
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun \
	/usr/bin/wine*            \
	/usr/lib/wine             \
	/usr/bin/msidb            \
	/usr/bin/msiexec          \
	/usr/bin/notepad          \
	/usr/bin/regedit          \
	/usr/bin/regsvr32         \
	/usr/bin/widl             \
	/usr/bin/wmc              \
	/usr/bin/wrc              \
	/usr/bin/function_grep.pl \
	/usr/lib/libfreetype.so*  \
	/usr/lib/libavcodec.so*

# alright here the pain starts
ln -sr ./AppDir/lib/wine/x86_64-unix/*.so* ./AppDir/bin

# this gets broken by sharun somehow
kek=.$(tr -dc 'A-Za-z0-9_=-' < /dev/urandom | head -c 10)
rm -f ./AppDir/lib/wine/x86_64-unix/wine
cp /usr/lib/wine/x86_64-unix/wine ./AppDir/lib/wine/x86_64-unix/wine
patchelf --set-interpreter /tmp/"$kek" ./AppDir/lib/wine/x86_64-unix/wine
patchelf --add-needed anylinux.so ./AppDir/shared/lib/wine/x86_64-unix/wine

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

# remove wine static libs
find ./AppDir/lib/ -type f -name '*.a'
find ./AppDir/lib/ -type f -name '*.a' -delete

# Turn AppDir into AppImage
wget -q https://github.com/pkgforge-dev/appimagetool-uruntime/releases/download/continuous/appimagetool-x86_64.AppImage -O /usr/local/bin/appimagetool ; chmod +x /usr/local/bin/appimagetool

appimagetool --no-appstream -u "$UPINFO" AppDir "$OUTNAME"
