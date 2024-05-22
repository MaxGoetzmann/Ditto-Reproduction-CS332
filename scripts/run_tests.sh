#!/bin/bash

source ./vars.sh

# Run perf benchmark
cd $HOME/enoki/enoki-schedulers/perf_test
make
sudo ./enoki_test
sudo ./cfs_test