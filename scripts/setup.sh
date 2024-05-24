#!/bin/bash

source vars.sh

# Verify
echo ""
echo "The current kernel version below should be 5.11.0-custom:"
echo $(uname -r)
echo ""

# install bento
cd $HOME/enoki/bento
git submodule update --init --recursive
git checkout enoki-support

# install scheduler
cd $HOME/enoki/enoki-schedulers
sudo apt-get update
sudo apt-get install -y clang-11
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
sudo snap install rustup --classic
rustup default nightly
rustup install nightly-2022-08-21
rustup override set nightly-2022-08-21
rustup component add rust-src --toolchain nightly-2022-08-21-x86_64-unknown-linux-gnu
cd wfq

# Install rust home package 0.5.5
cd kernel
cargo update -p home@0.5.9 --precise 0.5.5
cd ..

make
sudo mount -t ghost ghost /sys/fs/ghost/

# Install enoki kernel module manually (VM freezes and needs hardboot when using insmod)
KERNEL_MODS=/lib/modules/5.11.0-custom/
sudo cp kernel/enoki_wfq.ko $KERNEL_MODS/kernel/enoki_wfq.ko
echo "kernel/enoki_wfq.ko" | sudo tee -a $KERNEL_MODS/modules.dep
sudo depmod

# Install perf
cd $HOME/enoki/enoki-kernel
sudo make -C tools/perf install