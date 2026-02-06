#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm winetricks patchelf sdl2 pipewire-audio pipewire-jack

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

WINE_VER="$(wget -qO- https://github.com/mmtrt/Wine-Builds/releases/expanded_assets/latest | grep -Eo '[0-9].*xz"' | sed -r 's|-amd64| |' | head -1 | awk '{print $1}')"

wget -q "https://github.com/mmtrt/Wine-Builds/releases/download/latest/wine-${WINE_VER}-staging-amd64.tar.xz"

tar xf *.tar.xz ; cp -R wine-*-amd64/* /usr/

# Disable FileOpenAssociations
sed -i 's|    LicenseInformation|    LicenseInformation,\\\n    FileOpenAssociations|g;$a \\n[FileOpenAssociations]\nHKCU,Software\\Wine\\FileOpenAssociations,"Enable",,"N"' /usr/share/wine/wine.inf

# Disable winemenubuilder
sed -i 's|    FileOpenAssociations|    FileOpenAssociations,\\\n    DllOverrides|;$a \\n[DllOverrides]\nHKCU,Software\\Wine\\DllOverrides,"*winemenubuilder.exe",,""' /usr/share/wine/wine.inf
sed -i '/\%11\%\\winemenubuilder.exe -a -r/d' /usr/share/wine/wine.inf

rm *.tar.xz

ls /usr/bin | grep wine

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
