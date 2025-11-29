This repository contain the files to build a costumized live-linux ISO.


```sh
sudo apt update
sudo apt install live-build
```

You can easily copy the iso onto an USB-stick for booting.

During boot you can choose between boot into Live System (more information about Debian Live: https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html), tart Debian Installation or using Hadware Detection Tool (HDT) or Memory Diagnostic Tool (memtest86+).

To build the live-linux ISO make sure live-build is installed on your machine. 

You can start the build process with 
```sh
make
``` 
or 
```sh
sudo make
```

Feel free to change the configurationen fitting to your needs and wishes. There for change the makefile (more information about makefile: https://makefiletutorial.com/), add or remove packages listed inside packages.list or change the configurations for vim (vimrc) and bash (.bashrc, bash_profile).

Feel free to make changes to i3config to fit the system to your needs and wishes.


Credit to [ananke](https://codeberg.org/ananke/Live-Debian-12-bookworm-i3)
