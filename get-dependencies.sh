#!/bin/sh

set -ex

sed -i 's/DownloadUser/#DownloadUser/g' /etc/pacman.conf

if [ "$(uname -m)" = 'x86_64' ]; then
	PKG_TYPE='x86_64.pkg.tar.zst'
else
	PKG_TYPE='aarch64.pkg.tar.xz'
fi
FFMPEG_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/ffmpeg-mini-$PKG_TYPE"

echo "Installing build dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
  alsa-lib \
  base-devel \
  binutils \
  coreutils \
  desktop-file-utils \
  ffmpeg \
  file \
  findutils \
  fontconfig \
  freetype2 \
  gcc-libs \
  git \
  glibc \
  gnutls \
  grep \
  hicolor-icon-theme \
  jack \
  lcms2 \
  libdrm \
  libegl \
  libgl \
  libglvnd \
  libpcap \
  libpipewire \
  libpulse \
  libunwind \
  libx11 \
  libxcursor \
  libxext \
  libxi \
  libxkbcommon \
  libxpresent \
  libxrandr \
  mesa \
  mesa-utils \
  mingw-w64-binutils \
  openal \
  patchelf \
  patchelf \
  sed \
  strace \
  vulkan-headers \
  vulkan-icd-loader \
  wayland \
  wayland-protocols \
  wget \
  wine \
  xorg-server-xvfb \
  zlib \
  zsync

#if [ "$(uname -m)" = 'x86_64' ]; then
#	pacman -Syu --noconfirm vulkan-intel haskell-gnutls gcc13 svt-av1
#else
#	pacman -Syu --noconfirm vulkan-freedreno vulkan-panfrost
#fi

echo "Installing debloated pckages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$FFMPEG_URL" -O ./ffmpeg-mini.pkg.tar.zst
pacman -U --noconfirm ./*.pkg.tar.zst
rm -f ./*.pkg.tar.zst

# Remove vapoursynth since ffmpeg-mini doesn't link to it
pacman -Rsndd --noconfirm vapoursynth

echo "All done!"
echo "---------------------------------------------------------------"
