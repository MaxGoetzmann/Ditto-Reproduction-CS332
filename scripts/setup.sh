#!/bin/bash

source ./vars.sh

# install bento
cd $HOME/enoki/bento
git submodule update --init --recursive
git checkout enoki-support

# install scheduler
cd $HOME/enoki/enoki-schedulers
sudo apt install -y clang-11
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
sudo snap install rustup --classic
rustup default nightly
rustup install nightly-2022-08-21
rustup override set nightly-2022-08-21
rustup component add rust-src --toolchain nightly-2022-08-21-x86_64-unknown-linux-gnu
cd wfq
make
sudo mount -t ghost ghost /sys/fs/ghost/
sudo insmod kernel/enoki_wfq.ko

# run tests