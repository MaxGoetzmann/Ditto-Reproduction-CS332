#!/bin/bash

source vars.sh

sudo sed -i '/^deb-src/s/^# //g' /etc/apt/sources.list
sudo apt-get update # refresh sources.list changes
sudo apt-get build-dep -y linux linux-image-$(uname -r)
sudo apt-get install -y libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm zstd
cd enoki/enoki-kernel
sed -i 's/CONFIG_FRAME_WARN=1024/CONFIG_FRAME_WARN=2048/' .config # prevent frame warning
sed -i 's/^CONFIG_DEBUG_INFO_BTF=.*/CONFIG_DEBUG_INFO_BTF=n/' .config
yes '' | make clean -j $(getconf _NPROCESSORS_ONLN) bindeb-pkg LOCALVERSION=-custom
cd ..
sudo dpkg -i *.deb 
sudo sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' /etc/default/grub
sudo grub-set-default "Advanced options for Ubuntu>Ubuntu, with Linux 5.11.0-custom"
sudo update-grub
sudo reboot