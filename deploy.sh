#!/bin/bash

sudo apt-get update ;
sudo apt-get -y install python3 python3-setuptools python3-pip wget patchelf fakeroot gnupg2 libglib2.0-bin file desktop-file-utils libgdk-pixbuf2.0-dev librsvg2-dev zsync

mkdir -p workdir ; cd workdir ;
sudo pip3 install appimage-builder ;
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && chmod +x appimagetool-x86_64.AppImage ;
./appimagetool-x86_64.AppImage --appimage-extract && mv squashfs-root appimage-tool.AppDir ;
sudo ln -s appimage-tool.AppDir/AppRun /usr/bin/appimagetool && rm appimagetool-x86_64.AppImage ;
sudo mkdir -p /usr/share/icons/hicolor/256x256/apps/ ;
cat > org.winehq.wine.desktop <<'EOF'
[Desktop Entry]
X-AppImage-Arch=x86_64
X-AppImage-Version=staging
X-AppImage-Name=wine
Name=wine
Exec=opt/wine-staging/bin/wine64
Icon=wine
Type=Application
Terminal=false
Categories=Utility;
Comment=
EOF
sudo mv org.winehq.wine.desktop /usr/share/applications/ ;
sudo wget https://github.com/mmtrt/Wine_Appimage_old/raw/master/resource/Wine.png -O /usr/share/icons/hicolor/256x256/apps/wine.png
