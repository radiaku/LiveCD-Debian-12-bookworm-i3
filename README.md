Customized Debian 12 (bookworm) Live ISO with i3, Polybar, LightDM autologin, and a curated toolbox. Use this to build a bootable image or install to disk from the live session.

## Requirements
- Debian-based host with `sudo`
- Packages: `live-build`, `curl`, `unzip`, `git`, `grub-common` (for `grub-mkfont`)

```sh
sudo apt update
sudo apt install live-build curl unzip git grub-common
```

## Clone
```sh
git clone https://github.com/radiaku/LiveCD-Debian-12-bookworm-i3.git
cd LiveCD-Debian-12-bookworm-i3
```

Internet access is required during the build because we pull the i3/polybar/vim configs and fonts from GitHub.

## Build the ISO
```sh
sudo make
```

The ISO is produced via `live-build` (see `makefile`). Output is named `RADIA-bookworm` (hybrid ISO, suitable for USB with `dd`/`cp`). Boot menu includes: Live system, Debian installer, HDT, and memtest86+.

## What the build does
- Autologin user `radia` into the i3 session via LightDM (`lightdm.conf`).
- Fetch configs:
  - Vim runtime from `radiaku/vimrc`
  - i3 config from `radiaku/i3config`
  - Polybar config from `radiaku/polybarconfig`
- Install Nerd Font (Iosevka) and generate a GRUB unicode font.
- Copy package selection from `packages.list` into the live system.
- Set the Debian mirror used by `live-build` (`MIRROR` in `makefile`).

## Quick i3 guide (live session)
- Modifier: Super/Windows key (Mod4) as defined in the fetched config.
- Start terminal: `Mod+Enter`
- App launcher (rofi/dmenu): `Mod+d`
- Close window: `Mod+Shift+q`
- Reload config: `Mod+Shift+c`; restart i3: `Mod+Shift+r`
- Exit menu: `Mod+Shift+e`

Full keybindings live in the fetched `~/.config/i3/config` inside the ISO (source repo: `radiaku/i3config`).

## Install from the live session
Run the Debian installer from the live environment:
```sh
sudo debian-installer-launcher
```

## Customize
- Packages: edit `packages.list`.
- Mirrors/ISO name: adjust `MIRROR` and `lb config` flags in `makefile`.
- Autologin/session: see `lightdm.conf`.
- i3/Polybar/Vim configs: edit the respective upstream repos or replace the copies in `build/` before `make`.

Credit to [ananke](https://codeberg.org/ananke/Live-Debian-12-bookworm-i3).
