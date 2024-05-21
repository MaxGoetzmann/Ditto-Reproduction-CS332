#!/bin/bash

source ./vars.sh

# Set the desired kernel version
KERNEL_VERSION="5.11.0-$KERNEL_NUM"

# Install the kernel image and headers
sudo apt install -y linux-image-${KERNEL_VERSION}-generic linux-headers-${KERNEL_VERSION}-generic

# Check if GRUB_TIMEOUT_STYLE is set to 'menu' in /etc/default/grub
if ! grep -q '^GRUB_TIMEOUT_STYLE=menu' /etc/default/grub; then
    sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub
fi

# Check if GRUB_TIMEOUT is set to 5 in /etc/default/grub
if ! grep -q '^GRUB_TIMEOUT=5' /etc/default/grub; then
    sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' /etc/default/grub
fi

# Update GRUB configuration
sudo update-grub

# Set the default boot entry to the new kernel
sudo grub-reboot "Ubuntu, with Linux ${KERNEL_VERSION}-generic"

# Reboot the system
sudo reboot
