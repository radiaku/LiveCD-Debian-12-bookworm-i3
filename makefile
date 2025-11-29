#!/usr/bin/make -f
SHELL := /bin/bash

SKEL = config/includes.chroot/etc/skel
VIMRC_REPO = https://github.com/radiaku/vimrc.git
VIMRC_SRC = build/vimrc_src

I3CONF_REPO = https://github.com/radiaku/i3config.git
POLYBAR_REPO = https://github.com/radiaku/polybarconfig.git

I3CONF_SRC = build/i3config
POLYBAR_SRC = build/polybarconfig

all: clean prepare fetch_vimrc fetch_i3 fetch_polybar install_vimrc install_i3 install_polybar copy_files build_iso

prepare:
	mkdir -p $(SKEL)/.config/i3
	mkdir -p config/includes.chroot/etc/systemd/system
	mkdir -p build

fetch_i3:
	rm -rf $(I3CONF_SRC)
	git clone $(I3CONF_REPO) $(I3CONF_SRC)

fetch_polybar:
	rm -rf $(POLYBAR_SRC)
	git clone $(POLYBAR_REPO) $(POLYBAR_SRC)

fetch_vimrc:
	rm -rf $(VIMRC_SRC)
	git clone $(VIMRC_REPO) $(VIMRC_SRC)

install_vimrc:
	rm -rf $(SKEL)/.vimrc_runtime
	cp -r $(VIMRC_SRC) $(SKEL)/.vimrc_runtime

	@echo ">>> Installing .vimrc (from repo file)"
	cp .vimrc_livecd $(SKEL)/.vimrc

install_i3:
	mkdir -p $(SKEL)/.config/i3
	cp -r $(I3CONF_SRC)/* $(SKEL)/.config/i3/

install_polybar:
	mkdir -p $(SKEL)/.config/polybar
	cp -r $(POLYBAR_SRC)/* $(SKEL)/.config/polybar/

copy_files:
	cp .bashrc $(SKEL)/.bashrc
	cp i3config $(SKEL)/.config/i3/config
	cp kraut.png $(SKEL)/.config/i3/

	echo "exec --no-startup-id feh --bg-scale ~/.config/i3/kraut.png" >> $(SKEL)/.config/i3/config

	cp -r /usr/share/live/build/bootloaders config/
	cp My_cephei_pxi.png config/bootloaders/grub-pc/splash.png

build_iso:
	sudo lb clean --all

	sudo lb config --debug --distribution bookworm \
		--memtest memtest86+ \
		--bootappend-live "boot=live component username=radia" \
		--debian-installer live \
		--backports true \
		--archive-areas "main contrib non-free non-free-firmware" \
		--hdd-label RADIA-bookworm \
		--uefi-secure-boot disable \
		--image-name RADIA-bookworm \
		--linux-packages "linux-image linux-headers"

	echo "debian-installer-launcher" > config/package-lists/installer.list.chroot
	echo "d-i debian-installer/locale string en_US" > config/includes.installer/preseed.cfg

	cp packages.list config/package-lists/desktop.list.chroot

	sudo lb build 2>&1 | tee build.log

clean:
	sudo lb clean || true
	rm -rf $(SKEL)/.vimrc $(SKEL)/.vimrc_runtime
	rm -rf build
