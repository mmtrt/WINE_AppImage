#!/bin/bash

sudo apt-get update && sudo apt-get -y install python3 python3-setuptools python3-pip wget patchelf fakeroot gnupg2 libglib2.0-bin file desktop-file-utils libgdk-pixbuf2.0-dev librsvg2-dev zsync unzip

mkdir -p ./{tmp,workdir} && cd workdir && ver="$(wget -qO- https://github.com/AppImageCrafters/appimage-builder/releases | sed 's|<| |g' | grep "Release v" | awk '{print $3}' | head -n1)" && wget https://github.com/AppImageCrafters/appimage-builder/archive/$ver.zip && unzip v*.zip && cd ./appimage-builder-*/ && sudo python3 ./setup.py install && cd .. && sudo rm -rf ./appimage-builder-*/ && cd tmp && wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && chmod +x /tmp/appimagetool-x86_64.AppImage && /tmp/appimagetool-x86_64.AppImage --appimage-extract && mv squashfs-root appimage-tool.AppDir && sudo ln -s appimage-tool.AppDir/AppRun /usr/bin/appimagetool && rm /tmp/appimagetool-x86_64.AppImage && cd ..

appimage-builder --skip-tests && ls -al
