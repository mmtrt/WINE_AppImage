#!/bin/bash

mkdir -p /usr/share/icons/hicolor/scalable/ ; cp wine.svg /usr/share/icons/hicolor/scalable/

#Initializing the keyring requires entropy
pacman-key --init

# Enable Multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Add more repo:
echo "" >> /etc/pacman.conf

# https://lonewolf.pedrohlc.com/chaotic-aur/
echo "[chaotic-aur]" >> /etc/pacman.conf
#echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = http://lonewolf-builder.duckdns.org/\$repo/x86_64" >> /etc/pacman.conf
echo "Server = http://chaotic.bangl.de/\$repo/x86_64" >> /etc/pacman.conf
echo "Server = https://repo.kitsuna.net/x86_64" >> /etc/pacman.conf
echo "" >> /etc/pacman.conf

# workaround one bug: https://bugzilla.redhat.com/show_bug.cgi?id=1773148
echo "Set disable_coredump false" >> /etc/sudo.conf

echo "DEBUG: updating pacmam keys"
pacman -Syy --noconfirm && pacman --noconfirm -S archlinuxcn-keyring

echo "DEBUG: pacmam sync"
pacman -Syy --noconfirm

echo "DEBUG: pacmam updating system"
pacman -Syu --noconfirm

#Add "base-devel multilib-devel" for compile in the list:
pacman -S --noconfirm wget base-devel multilib-devel pacman-contrib git tar grep sed zstd xz bzip2 patchelf python-pip

# Add appimagetool
(wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && chmod +x appimagetool-x86_64.AppImage
./appimagetool-x86_64.AppImage --appimage-extract &>/dev/null && rm *.AppImage && ln -s $PWD/squashfs-root/AppRun /usr/bin/appimagetool)

mkdir cache

# wine deps
pacman -Syw --noconfirm --cachedir cache \
fontconfig \
lib32-fontconfig \
lcms2 \
lib32-lcms2 \
libxml2 \
lib32-libxml2 \
libxcursor \
lib32-libxcursor \
libxrandr \
lib32-libxrandr \
libxdamage \
lib32-libxdamage \
libxi \
lib32-libxi \
gettext \
lib32-gettext \
freetype2 \
lib32-freetype2 \
glu \
lib32-glu \
libsm \
lib32-libsm \
gcc-libs \
lib32-gcc-libs \
libpcap \
lib32-libpcap \
faudio \
lib32-faudio \
desktop-file-utils \
giflib \
lib32-giflib \
libpng \
lib32-libpng \
libldap \
lib32-libldap \
gnutls \
lib32-gnutls \
mpg123 \
lib32-mpg123 \
openal \
lib32-openal \
v4l-utils \
lib32-v4l-utils \
libpulse \
lib32-libpulse \
alsa-plugins \
lib32-alsa-plugins \
alsa-lib \
lib32-alsa-lib \
libjpeg-turbo \
lib32-libjpeg-turbo \
libxcomposite \
lib32-libxcomposite \
libxinerama \
lib32-libxinerama \
ncurses \
lib32-ncurses \
opencl-icd-loader \
lib32-opencl-icd-loader \
libxslt \
lib32-libxslt \
gst-plugins-base-libs \
lib32-gst-plugins-base-libs \
vkd3d \
lib32-vkd3d \
sdl2 \
lib32-sdl2 \
libgphoto2 \
sane \
gsm \
cups \
samba \
libxmu \
lib32-libxmu \
libxxf86vm \
lib32-libxxf86vm \
pcre \
lib32-pcre \
bzip2 \
lib32-bzip2 \
harfbuzz \
lib32-harfbuzz

# wine
pacman -Syw --noconfirm --cachedir cache \
wine

# glibc
pacman -Syw --noconfirm --cachedir cache \
glibc \
lib32-glibc \
zlib \
lib32-zlib \
libstdc++5

# drivers
pacman -Syw --noconfirm --cachedir cache \
mesa \
lib32-mesa \
mesa-libgl \
lib32-mesa-libgl \
ocl-icd \
lib32-ocl-icd \
vulkan-icd-loader \
lib32-vulkan-icd-loader \
libdrm \
lib32-libdrm \
libva \
lib32-libva \
vulkan-intel \
lib32-vulkan-intel \
vulkan-radeon \
lib32-vulkan-radeon \
vulkan-tools

# core deps
sudo pacman -Syw --noconfirm --cachedir cache \
coreutils \
grep \
bash \
readline \
lib32-readline

pip3 install appimage-builder

wget -q https://gist.github.com/mmtrt/8d1a2b9eb33429feb0197ec46b0acdf4/raw/0c43ab647a1b9c8b6cabb95ad33c62ab8a2a7367/nvidia_icd.json

appimage-builder --skip-tests --recipe wine-stable.yml

tar cvf output.tar *.AppImage *.zsync

# wineworkdir cleanup
# rm -rf cache; rm -rf include; rm usr/lib32/{*.a,*.o}; rm -rf usr/lib32/pkgconfig; rm -rf share/man; rm -rf usr/include; rm -rf usr/share/{applications,doc,emacs,gtk-doc,java,licenses,man,info,pkgconfig}; rm usr/lib32/locale

# fix broken link libglx_indirect
# rm usr/lib32/libGLX_indirect.so.0
# ln -s libGLX_mesa.so.0 libGLX_indirect.so.0
# mv libGLX_indirect.so.0 usr/lib32

# Disable winemenubuilder
# sed -i 's/winemenubuilder.exe -a -r/winemenubuilder.exe -r/g' share/wine/wine.inf

# Disable FileOpenAssociations
# sed -i 's|    LicenseInformation|    LicenseInformation,\\\n    FileOpenAssociations|g;$a \\n[FileOpenAssociations]\nHKCU,Software\\Wine\\FileOpenAssociations,"Enable",,"N"' share/wine/wine.inf

# appimage
# cd -
# 
# wget -nv -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O  appimagetool.AppImage
# chmod +x appimagetool.AppImage


# Remove library path from vk icd files
# sed -i -E 's,(^.+"library_path": ")/.*/,\1,' $wineworkdir/usr/share/vulkan/icd.d/*.json

