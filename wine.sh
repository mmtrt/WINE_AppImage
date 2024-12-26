     # Patch wrapper script
     sed -i 's|wine-appimage|wine-appimage-devel-v9|' AppDir/wrapper

     WINE_VER="10.0~rc3"

     wget -q -c https://dl.winehq.org/wine-builds/ubuntu/dists/focal/main/binary-i386/wine-devel_${WINE_VER}~focal-1_i386.deb
     wget -q -c https://dl.winehq.org/wine-builds/ubuntu/dists/focal/main/binary-i386/wine-devel-i386_${WINE_VER}~focal-1_i386.deb
     wget -q -c https://dl.winehq.org/wine-builds/ubuntu/dists/focal/main/binary-amd64/wine-devel_${WINE_VER}~focal-1_amd64.deb
     wget -q -c https://dl.winehq.org/wine-builds/ubuntu/dists/focal/main/binary-amd64/wine-devel-amd64_${WINE_VER}~focal-1_amd64.deb
     dpkg -x "wine-devel_${WINE_VER}~focal-1_i386.deb" AppDir/
     dpkg -x "wine-devel-i386_${WINE_VER}~focal-1_i386.deb" AppDir/
     dpkg -x "wine-devel_${WINE_VER}~focal-1_amd64.deb" AppDir/
     dpkg -x "wine-devel-amd64_${WINE_VER}~focal-1_amd64.deb" AppDir/
     (cd AppDir/usr/bin; ln -s "../../opt/wine-devel/bin/"* .)

     # Cleanup
     rm -rf AppDir/usr/share/{applications,man,doc}
     rm -rf AppDir/opt/wine-devel/share/{applications,man,doc}
     rm -rf AppDir/opt/wine-devel/lib/wine/i386-unix/*.a
     rm -rf AppDir/opt/wine-devel/lib/wine/i386-windows/*.a
     rm -rf AppDir/opt/wine-devel/lib64/wine/x86_64-unix/*.a
     rm -rf AppDir/opt/wine-devel/lib64/wine/x86_64-windows/*.a

     # Disable FileOpenAssociations
     sed -i 's|    LicenseInformation|    LicenseInformation,\\\n    FileOpenAssociations|g;$a \\n[FileOpenAssociations]\nHKCU,Software\\Wine\\FileOpenAssociations,"Enable",,"N"' AppDir/opt/wine-devel/share/wine/wine.inf

     # Disable winemenubuilder
     sed -i 's|    FileOpenAssociations|    FileOpenAssociations,\\\n    DllOverrides|;$a \\n[DllOverrides]\nHKCU,Software\\Wine\\DllOverrides,"*winemenubuilder.exe",,""' AppDir/opt/wine-devel/share/wine/wine.inf
     sed -i '/\%11\%\\winemenubuilder.exe -a -r/d' AppDir/opt/wine-devel/share/wine/wine.inf

     # Pre patch CJK font replacement with Noto Sans CJK by defualt
     sed -i 's|    ThemeSet|    ThemeSet,\\\n    FontReplacement|g;$a \\n[FontReplacement]\nHKCU,Software\\Wine\\Fonts\\Replacements,"Batang",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"BatangChe",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Dotum",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"DotumChe",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Gulim",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"GulimChe",,"Noto Sans CJK KR"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei Light",,"Noto Sans CJK TC Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei Bold",,"Noto Sans CJK TC Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei UI",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei UI Light",,"Noto Sans CJK TC Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft JhengHei UI Bold",,"Noto Sans CJK TC Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei Light",,"Noto Sans CJK SC Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei Bold",,"Noto Sans CJK SC Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei UI",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei UI Light",,"Noto Sans CJK SC Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Microsoft YaHei UI Bold",,"Noto Sans CJK SC Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MingLiU",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MingLiU-ExtB",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MingLiU_HKSCS",,"Noto Sans CJK HK"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MingLiU_HKSCS-ExtB",,"Noto Sans CJK HK"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MS Gothic",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MS PGothic",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"MS UI Gothic",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"NSimSun",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"PMingLiU",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"PMingLiU-ExtB",,"Noto Sans CJK TC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"SimHei",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"SimSun",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"SimSun-ExtB",,"Noto Sans CJK SC"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic Regular",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic Medium",,"Noto Sans CJK JP Medium"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic Light",,"Noto Sans CJK JP Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic Bold",,"Noto Sans CJK JP Black"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Regular",,"Noto Sans CJK JP"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Medium",,"Noto Sans CJK JP Medium"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Semilight",,"Noto Sans CJK JP DemiLight"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Light",,"Noto Sans CJK JP Light"\nHKCU,Software\\Wine\\Fonts\\Replacements,"Yu Gothic UI Bold",,"Noto Sans CJK JP Black"' AppDir/opt/wine-devel/share/wine/wine.inf

     # Deploy wine-mono wine-gecko
     # For future reference setting of MONO_VER see https://github.com/wine-mirror/wine/tree/stable of wine-stable
     MONO_VER=$(wget "https://raw.githubusercontent.com/wine-mirror/wine/$(wget -qO- https://github.com/wine-mirror/wine/releases/tag/wine-${WINE_VER} | grep 'commit/' | sed -r 's|/wine-mirror/wine/commit/||g' | cut -d'"' -f2 | head -1)/dlls/appwiz.cpl/addons.c" -qO- | grep -Po 'MONO_VERSION.*[0-9]"' | cut -d'"' -f2)
     GECKO_VER=$(wget "https://raw.githubusercontent.com/wine-mirror/wine/$(wget -qO- https://github.com/wine-mirror/wine/releases/tag/wine-${WINE_VER} | grep 'commit/' | sed -r 's|/wine-mirror/wine/commit/||g' | cut -d'"' -f2 | head -1)/dlls/appwiz.cpl/addons.c" -qO- | grep -Po 'GECKO_VERSION.*[0-9]"' | cut -d'"' -f2)

     case "$WINE_VER" in
     3.0.1|3.0.2|3.0.3|3.0.4|3.0.5)
       GECKO_VER="2.47"
       MONO_VER="4.7.1"
       ;;

     4.0.1|4.0.2|4.0.3|4.0.4)
       GECKO_VER="2.47"
       MONO_VER="4.7.5"
       ;;

     5.0.1|5.0.2|5.0.3|5.0.4|5.0.5)
       GECKO_VER="2.47.1"
       MONO_VER="4.9.4"
       ;;

     6.0.1|6.0.2|6.0.3|6.0.4)
       GECKO_VER="2.47.2"
       MONO_VER="5.1.1"
       ;;

     7.0.1|7.0.2|7.0.3|7.0.4)
       GECKO_VER="2.47.2"
       MONO_VER="7.0.0-x86"
       ;;
     *)
       MONO_VER="$MONO_VER-x86"
       ;;
     esac

     # if [[ $(echo $GECKO_VER |sed -e 's/\.//g') -le 247 ]]; then
     #    GECKO=wine_gecko-${GECKO_VER}
     # else
     #    GECKO=wine-gecko-${GECKO_VER}
     # fi

     MONO_URL="https://dl.winehq.org/wine/wine-mono/$(cut -d'-' -f1 <<< ${MONO_VER})/wine-mono-${MONO_VER}.msi"
     # GECKO_URL_x86="https://dl.winehq.org/wine/wine-gecko/$GECKO_VER/${GECKO}-x86.msi"
     # GECKO_URL_x86_64="https://dl.winehq.org/wine/wine-gecko/$GECKO_VER/${GECKO}-x86_64.msi"

     wget -q "$MONO_URL" -O AppDir/winedata/wine-mono-${MONO_VER}.msi
     # wget -q "$GECKO_URL_x86" -O AppDir/winedata/${GECKO}-x86.msi
     # wget -q "$GECKO_URL_x86_64" -O AppDir/winedata/${GECKO}-x86_64.msi

     # add wineaiso
     cp wineasio/docker/wineasio32.dll AppDir/opt/wine-devel/lib/wine/i386-windows/
     cp wineasio/docker/wineasio64.dll AppDir/opt/wine-devel/lib64/wine/x86_64-windows/
     cp wineasio/docker/wineasio32.dll.so AppDir/opt/wine-devel/lib/wine/i386-unix/wineasio32.so
     cp wineasio/docker/wineasio64.dll.so AppDir/opt/wine-devel/lib64/wine/x86_64-unix/wineasio64.so
