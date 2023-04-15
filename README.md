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
 * This AppImage includes i386 GPU drivers. If it still doesnt work then don't get angry at me.

## Get Started

Download the latest release from

| Stable | Devel | Staging | GE-Proton | GE-LoL |
| ------- | --------- | --------- | --------- | --------- |
| <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" height=100> | <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" height=100> | <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" height=100> | <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" height=100> | <img src="https://github.com/mmtrt/WINE_AppImage/raw/master/wine.svg" height=100> |
| [Download](https://github.com/mmtrt/WINE_AppImage/releases/tag/continuous-stable) | [Download](https://github.com/mmtrt/WINE_AppImage/releases/tag/continuous-devel) | [Download](https://github.com/mmtrt/WINE_AppImage/releases/tag/continuous-staging) | [Download](https://github.com/mmtrt/WINE_AppImage/releases/tag/continuous-staging_ge_proton) | [Download](https://github.com/mmtrt/WINE_AppImage/releases/tag/continuous-staging_ge_lol) |


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

## Acknowledgements
* https://www.winehq.org
* https://github.com/AppImageCrafters/appimage-builder
* https://github.com/GloriousEggroll
