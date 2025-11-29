#!/usr/bin/make -f
# Change the default shell /bin/sh which does not implement 'source'
# source is needed to work in a python virtualenv
SHELL := /bin/bash

DIR=config/includes.chroot/etc/skel/.vim

build:
	# Clean
	sudo lb clean --all

	# Configure LB
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

	# Installer settings
	echo "debian-installer-launcher" > config/package-lists/installer.list.chroot
	echo "d-i debian-installer/locale string en_US" > config/includes.installer/preseed.cfg

	# Copy package list
	cat packages.list > config/package-lists/desktop.list.chroot

	# Create directories
	mkdir -p $(DIR)/colors
	mkdir -p $(DIR)/bundle
	mkdir -p $(DIR)/nerdtree
	mkdir -p $(DIR)/plugin
	mkdir -p $(DIR)/bundle/YouCompleteMe
	mkdir -p $(DIR)/pack/tpope/start

	mkdir -p config/includes.chroot/etc/skel/.config/i3
	mkdir -p config/includes.chroot/etc/systemd/system

	# Run vim plugin clones
	$(MAKE) all

	# Copy configs
	cp .bashrc config/includes.chroot/etc/skel/.bashrc
	cp i3config config/includes.chroot/etc/skel/.config/i3/config
	cp kraut.png config/includes.chroot/etc/skel/.config/i3/
	cp vimrc config/includes.chroot/etc/skel/.vimrc
	cp forest_refuge.vim $(DIR)/colors/

	echo "exec --no-startup-id feh --bg-scale /home/radia/.config/i3/kraut.png" >> config/includes.chroot/etc/skel/.config/i3/config

	# Bootloader customization
	cp -r /usr/share/live/build/bootloaders config/
	cp My_cephei_pxi.png config/bootloaders/grub-pc/splash.png

	# Build ISO
	sudo lb build 2>&1 | tee build.log

# --- VIM PLUGIN TARGETS --- #

vundle:
	@if [ ! -d "$(DIR)/plugin/Vundle.vim" ]; then \
		git clone https://github.com/gmarik/Vundle.vim.git $(DIR)/plugin/Vundle.vim; \
	else \
		echo "Vundle already exists, skipping"; \
	fi

vundle2:
	@if [ ! -d "$(DIR)/bundle/vundle.vim" ]; then \
		git clone https://github.com/VundleVim/Vundle.vim.git $(DIR)/bundle/vundle.vim; \
	else \
		echo "VundleVim already exists, skipping"; \
	fi

ycm:
	@if [ ! -d "$(DIR)/bundle/YouCompleteMe" ]; then \
		git clone https://github.com/ycm-core/YouCompleteMe.git $(DIR)/bundle/YouCompleteMe; \
	else \
		echo "YCM already exists, skipping"; \
	fi

fugitive:
	@if [ ! -d "$(DIR)/pack/tpope/start/fugitive" ]; then \
		git clone https://tpope.io/vim/fugitive.git $(DIR)/pack/tpope/start/fugitive; \
	else \
		echo "fugitive already exists, skipping"; \
	fi

nerdtree:
	@if [ ! -d "$(DIR)/nerdtree" ]; then \
		git clone https://github.com/preservim/nerdtree $(DIR)/nerdtree; \
	else \
		echo "nerdtree already exists, skipping"; \
	fi

all: vundle vundle2 ycm fugitive nerdtree
