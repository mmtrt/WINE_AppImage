#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm winetricks patchelf sdl2 pipewire-audio pipewire-jack

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

WINE_VER="$(wget -qO- https://github.com/mmtrt/Wine-Builds/releases/expanded_assets/stable | grep -Eo '/wine-[0-9].*xz"' | cut -d'-' -f2 | head -1)"

wget -q "https://github.com/mmtrt/Wine-Builds/releases/download/stable/wine-${WINE_VER}-amd64.tar.xz"

tar xf *.tar.xz -C /

rm *.tar.xz

ls /bin

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
