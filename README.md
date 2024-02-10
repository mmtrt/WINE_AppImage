<p align="center">
    <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" alt="WINE logo" width=128 height=128>

<h2 align="center">WINE AppImage</h2>

  <p align="center">WINE AppImage (unofficial) AppImages by GitHub Actions Continuous Integration
    <br>
    <a href="https://github.com/mmtrt/WINE_AppImage/issues/new">Report bug</a>
    ·
    <a href="https://github.com/mmtrt/WINE_AppImage/issues/new">Request feature</a>
    ·
    <a href="https://github.com/mmtrt/WINE_AppImage/releases">Download AppImage</a>
  </p>
</p>

## Info
 * Now WINE AppImages are built with wow64 enabled WINE builds.
 * GE-Proton AppImage does not have wow64 enabled atm.

## Get Started

Download the latest release from

| Stable | Devel | Staging | GE-Proton |
| ------- | --------- | --------- | --------- |
| <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" height=100> | <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" height=100> | <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" height=100> | <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" height=100> |
| [Download](https://github.com/mmtrt/WINE_AppImage/releases/tag/continuous-stable) | [Download](https://github.com/mmtrt/WINE_AppImage/releases/tag/continuous-devel) | [Download](https://github.com/mmtrt/WINE_AppImage/releases/tag/continuous-staging) | [Download](https://github.com/mmtrt/WINE_AppImage/releases/tag/continuous-staging_ge_proton) |

### Executing
#### File Manager
Just double click the `*.AppImage` file and you are done!

> In normal cases, the above method should work, but in some rare cases
the `+x` permissisions. So, right click > Properties > Allow Execution
#### Terminal
```bash
./wine-*.AppImage
```
```bash
chmod +x wine-*.AppImage
./wine-*.AppImage
```

In case, if FUSE support libraries are not installed on the host system, it is
still possible to run the AppImage

```bash
./wine-*.AppImage --appimage-extract
cd squashfs-root
./AppRun
```

## Building AppImage (Debian Based Host Only)

#### > Clone this repo
```
git clone 'https://github.com/mmtrt/WINE_AppImage.git'
```

#### > Download appimage-builder and unpack (AppRun v2)
```
cd WINE_AppImage ; wget -q 'https://github.com/AppImageCrafters/appimage-builder/releases/download/v1.0.3/appimage-builder-1.0.3-x86_64.AppImage' ; chmod +x 'appimage-builder-1.0.3-x86_64.AppImage' ; ./appimage-builder-1.0.3-x86_64.AppImage --appimage-extract
```
#### > Download appimage-builder continuous build and unpack (AppRun v3)
> NOTE: use this step for only WINE 9 and above AppImage recipe. below mentioned version may change in future.
```
cd WINE_AppImage ; wget -q 'https://github.com/AppImageCrafters/appimage-builder/releases/download/Continuous/appimage-builder-1.1.1.dev32+g2709a3b-x86_64.AppImage' ; chmod +x 'appimage-builder-1.1.1.dev32+g2709a3b-x86_64.AppImage' ; ./appimage-builder-1.1.1.dev32+g2709a3b-x86_64.AppImage --appimage-extract
```

#### > Modify appimage-builder
```
cp runtime/mksquashfs squashfs-root/usr/bin/mksquashfs ; sed -i 's|xz|zstd|' squashfs-root/usr/lib/python3.8/site-packages/appimagebuilder/modules/prime/appimage_primer.py
```

#### > Modify Recipe for building locally
Change version in `wine-stable.yml` for example.

version: `!ENV ${WINE_VER}` 

To

version: `"1.0"`


#### > Start building
Now launch modified appimage-builder using modifed recipe after doing above steps

```
squashfs-root/AppRun --recipe wine-stable.yml
```

**NOTE:** if you are making changes in recipe file after doing all steps then just skip all steps and use building step only.

## Acknowledgements
* https://www.winehq.org
* https://github.com/AppImageCrafters/appimage-builder
* https://github.com/GloriousEggroll
