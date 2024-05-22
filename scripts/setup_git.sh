#!/bin/bash

source vars.sh

git clone https://github.com/smiller123/enoki.git 
cd enoki 
git submodule update --init --recursive
cd enoki-kernel
git pull origin main
cd ..
cd enoki-schedulers
git pull origin main
