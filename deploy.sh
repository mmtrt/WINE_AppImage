#!/bin/sh

set -eu

PACKAGE=wine
DESKTOP=wine.desktop
ICON=wine.svg

export ARCH="$(uname -m)"
export APPIMAGE_EXTRACT_AND_RUN=1
export VERSION="$(wget -qO- https://github.com/mmtrt/Wine-Builds/releases/expanded_assets/stable | grep -Eo '/wine-[0-9].*xz"' | cut -d'-' -f2 | head -1)"

UPINFO="gh-releases-zsync|$(echo $GITHUB_REPOSITORY | tr '/' '|')|test7|wine-stable*$ARCH.AppImage.zsync"
LIB4BN="https://raw.githubusercontent.com/VHSgunzo/sharun/refs/heads/main/lib4bin"
URUNTIME="$(wget -q https://api.github.com/repos/VHSgunzo/uruntime/releases -O - \
	| sed 's/[()",{} ]/\n/g' | grep -oi "https.*appimage.*dwarfs.*$ARCH$" | head -1)"

# Prepare AppDir
mkdir -p ./"$PACKAGE"/AppDir/shared/lib \
	./"$PACKAGE"/AppDir/usr/share/applications \
	./"$PACKAGE"/AppDir/usr/share/icons \
	./"$PACKAGE"/AppDir/opt
cd ./"$PACKAGE"/AppDir

cp -r /usr/share/locale    ./usr/share

# Prepare wine
wget -q "https://github.com/mmtrt/Wine-Builds/releases/download/stable/wine-${VERSION}-amd64.tar.xz"

(cd ./opt ; tar -xf ../*.tar.xz ; mv wine-* wine-stable)

# Cleanup
rm -rf ./opt/wine-stable/share/{applications,man,doc}
rm -rf ./opt/wine-stable/lib/wine/i386-windows/*.a
rm -rf ./opt/wine-stable/lib64/wine/x86_64-unix/*.a
rm -rf ./opt/wine-stable/lib64/wine/x86_64-windows/*.a

# Disable FileOpenAssociations
sed -i 's|    LicenseInformation|    LicenseInformation,\\\n    FileOpenAssociations|g;$a \\n[FileOpenAssociations]\nHKCU,Software\\Wine\\FileOpenAssociations,"Enable",,"N"' ./opt/wine-stable/share/wine/wine.inf

# Disable winemenubuilder
sed -i 's|    FileOpenAssociations|    FileOpenAssociations,\\\n    DllOverrides|;$a \\n[DllOverrides]\nHKCU,Software\\Wine\\DllOverrides,"*winemenubuilder.exe",,""' ./opt/wine-stable/share/wine/wine.inf
sed -i '/\%11\%\\winemenubuilder.exe -a -r/d' ./opt/wine-stable/share/wine/wine.inf

# Pre patch CJK font replacement with Noto Sans CJK by defualt
sed -i 's|    DllOverrides|    DllOverrides,\\\n    FontReplacement|g;$a \\n[FontReplacement]\nHKCU,Software\\Wine\\Fonts\\Replacements,"Batang",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"BatangChe",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Dotum",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"DotumChe",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Gulim",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"GulimChe",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei Light",,"Noto Sans CJK TC Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei Bold",,"Noto Sans CJK TC Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei UI",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei UI Light",,"Noto Sans CJK TC Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei UI Bold",,"Noto Sans CJK TC Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei Light",,"Noto Sans CJK SC Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei Bold",,"Noto Sans CJK SC Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei UI",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei UI Light",,"Noto Sans CJK SC Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei UI Bold",,"Noto Sans CJK SC Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MingLiU",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MingLiU-ExtB",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MingLiU_HKSCS",,"Noto Sans CJK HK"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MingLiU_HKSCS-ExtB",,"Noto Sans CJK HK"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MS Gothic",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MS PGothic",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MS UI Gothic",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"NSimSun",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"PMingLiU",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"PMingLiU-ExtB",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"SimHei",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"SimSun",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"SimSun-ExtB",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic Regular",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic Medium",,"Noto Sans CJK JP Medium"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic Light",,"Noto Sans CJK JP Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic Bold",,"Noto Sans CJK JP Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Regular",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Medium",,"Noto Sans CJK JP Medium"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Semilight",,"Noto Sans CJK JP DemiLight"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Light",,"Noto Sans CJK JP Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Bold",,"Noto Sans CJK JP Black"' ./opt/wine-stable/share/wine/wine.inf

wget -q "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" -P ./opt/wine-stable/bin && chmod +x ./opt/wine-stable/bin/winetricks

rm -f *.tar.xz

cat > ./usr/share/applications/$DESKTOP << EOF
[Desktop Entry]
X-AppImage-Arch=$ARCH
X-AppImage-Version=$VERSION
X-AppImage-Name=$PACKAGE
Name=$PACKAGE
Exec=AppRun
Icon=$PACKAGE
Type=Application
Terminal=false
Categories=Utility;
EOF

cp ./usr/share/applications/$DESKTOP ./
cp ../../"$ICON" ./usr/share/icons
cp ../../"$ICON" ./
ln -s "$ICON" .DirIcon

ln -s ./usr/share  ./share
ln -s ./shared/lib ./lib

# ADD LIBRARIES
wget "$LIB4BN" -O ./lib4bin
chmod +x ./lib4bin
xvfb-run -d -- ./lib4bin -p -v -e -r ./opt/wine-stable/bin/*
rm -f ./lib4bin

# CREATE APPRUN
echo '#!/bin/sh
CURRENTDIR="$(dirname "$(readlink -f "${0}")")"

# WINE env
export WINE="$CURRENTDIR/opt/wine-stable/bin/wine"
export WINEDEBUG=${WINEDEBUG:-"fixme-all"}
export WINEPREFIX=${WINEPREFIX:-"$HOME/.wine-appimage"}
export WINESERVER="$CURRENTDIR/opt/wine-stable/bin/wineserver"

# DXVK env
export DXVK_HUD=${DXVK_HUD:-"0"}
export DXVK_LOG_LEVEL=${DXVK_LOG_LEVEL:-"none"}
export DXVK_STATE_CACHE=${DXVK_STATE_CACHE:-"0"}
export DXVK_CONFIG_FILE=${DXVK_CONFIG_FILE:-"$progHome/dxvk.conf"}

# check gpu vendor
VENDOR=$(glxinfo -B | grep "OpenGL vendor")

if [[ $VENDOR == *"Intel"* ]]; then
  export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/intel_icd.i686.json:/usr/share/vulkan/icd.d/intel_icd.x86_64.json"
elif [[ $VENDOR == *"NVIDIA"* ]]; then
  export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/nvidia_icd.json"
elif [[ $VENDOR == *"Radeon"* ]]; then
  export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json"
fi

# Load winecfg if no arguments given
APPLICATION=""
if [ -z "$*" ] ; then
  APPLICATION="winecfg"
fi

# Allow the AppImage to be symlinked to e.g., /opt/wine-stable/bin/wineserver
if [ -n "$APPIMAGE" ] ; then
  BINARY_NAME=$(basename "$ARGV0")
else
  BINARY_NAME=$(basename "$0")
fi

if [ -n "$1" ] && [ -e "$CURRENTDIR/opt/wine-stable/bin/$1" ] ; then
  MAIN="$CURRENTDIR/opt/wine-stable/bin/$1" ; shift
elif [ -e "$CURRENTDIR/opt/wine-stable/bin/$BINARY_NAME" ] ; then
  MAIN="$CURRENTDIR/opt/wine-stable/bin/$BINARY_NAME"
else
  MAIN="$CURRENTDIR/opt/wine-stable/bin/wine"
fi

if [ -z "$APPLICATION" ] ; then
"$MAIN" "$@"
else
"$MAIN" "$APPLICATION"
fi' > ./AppRun
chmod +x ./AppRun

./sharun -g

# MAKE APPIMAGE WITH URUNTIME
cd ..
wget -q "$URUNTIME" -O ./uruntime
chmod +x ./uruntime

#Add udpate info to runtime
echo "Adding update information \"$UPINFO\" to runtime..."
printf "$UPINFO" > data.upd_info
llvm-objcopy --update-section=.upd_info=data.upd_info \
	--set-section-flags=.upd_info=noload,readonly ./uruntime
printf 'AI\x02' | dd of=./uruntime bs=1 count=3 seek=8 conv=notrunc

echo "Generating AppImage..."
./uruntime --appimage-mkdwarfs -f \
	--set-owner 0 --set-group 0 \
	--no-history --no-create-timestamp \
	--compression zstd:level=22 -S25 -B16 \
	--header uruntime \
	-i ./AppDir -o "$PACKAGE"-stable_"$VERSION"-"$ARCH".AppImage

echo "Generating zsync file..."
zsyncmake *.AppImage -u *.AppImage

mv ./*.AppImage* ../
cd ..
rm -rf ./"$PACKAGE"
echo "All Done!"
