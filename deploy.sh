#!/bin/bash

sudo apt-get update ;
sudo apt-get -y install python3 python3-setuptools python3-pip wget patchelf fakeroot gnupg2 libglib2.0-bin file desktop-file-utils libgdk-pixbuf2.0-dev librsvg2-dev zsync

sudo mkdir -p /usr/share/icons/hicolor/scalable/ ; sudo cp wine.svg /usr/share/icons/hicolor/scalable/ ;
sudo pip3 install appimage-builder ;
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && chmod +x appimagetool-x86_64.AppImage ;
mv appimagetool-x86_64.AppImage appimagetool && cp appimagetool /home/travis/bin && ls -al && ls -al /home/travis/bin ;
