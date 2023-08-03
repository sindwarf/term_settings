#!/bin/bash

# Update pacman (Note: can take quite a while)
pacman -Syu

# Install Event Calendar 
# Right Click on task bar > Add Widgets > Get New Widgets > Download
# Search for Event Calendar

# Install basic packages
sudo pacman -Sy git vim tmux xclip cmake

# General building instructions
# 1) makepkg -s
# 2) sudo pacman -U <Name>.pkg.tar.xz

# Install VS Code
git clone https://AUR.archlinux.org/visual-studio-code-bin.git

# Install Real VNC
git clone https://aur.archlinux.org/realvnc-vnc-viewer.git
