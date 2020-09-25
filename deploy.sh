#!/bin/bash

sudo apt-get update ;
sudo apt-get -y install python3 python3-setuptools python3-pip wget patchelf fakeroot gnupg2 libglib2.0-bin file desktop-file-utils libgdk-pixbuf2.0-dev librsvg2-dev zsync

mkdir -p workdir ; cd workdir ;
sudo pip3 install appimage-builder ;
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && chmod +x appimagetool-x86_64.AppImage ;
./appimagetool-x86_64.AppImage --appimage-extract && mv squashfs-root appimage-tool.AppDir ;
sudo ln -s appimage-tool.AppDir/AppRun /usr/bin/appimagetool && rm appimagetool-x86_64.AppImage ;
sudo wget https://github.com/mmtrt/Wine_Appimage_old/raw/master/resource/Wine.png -O /usr/share/pixmaps/wine.png
