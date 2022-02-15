#!/bin/bash

# obtain number of CPUs
# - set it manually, if you prefer, or if auto detection fails
export BUILD_NPROC=$([ $(uname) = 'Darwin' ] && sysctl -n hw.ncpu || nproc)
if [ "$BUILD_NPROC" = "" ]; then export BUILD_NPROC=1; fi
echo "detected $BUILD_NPROC cpus"

# juggler paths
#export JUGGLER_INSTALL_PREFIX=$(pwd)/juggler/install
export JUGGLER_INSTALL_PREFIX=$ATHENA_PREFIX
export LD_LIBRARY_PATH=$JUGGLER_INSTALL_PREFIX/lib:$LD_LIBRARY_PATH
export PYTHONPATH=${JUGGLER_INSTALL_PREFIX}/python:${PYTHONPATH} # make sure gaudirun.py prioritizes local juggler installation

# cmake packages
export IRT_ROOT=$ATHENA_PREFIX # overrides container version with local version
export EICD_ROOT=$ATHENA_PREFIX # overrides container version with local version

# juggler config vars
export JUGGLER_DETECTOR="athena"
export BEAMLINE_CONFIG="ip6"
export JUGGLER_SIM_FILE=$(pwd)/out/sim_run.root
export JUGGLER_REC_FILE=test.root
export JUGGLER_N_EVENTS=100
export JUGGLER_RNG_SEED=1
export JUGGLER_N_THREADS=$BUILD_NPROC

# environment from reconstruction_benchmarks
if [ -f "reconstruction_benchmarks/.local/bin/env.sh" ]; then
  pushd reconstruction_benchmarks
  source .local/bin/env.sh
  popd
fi

# fix juggler config vars which would have been overwritten by 
# `reconstruction_benchmarks/.local/bin/env.sh`:
export DETECTOR_PATH=$(pwd)/athena
#export BEAMLINE_CONFIG_VERSION=master
#export JUGGLER_DETECTOR_VERSION=master
#export DETECTOR_VERSION=master

if [ -f "reconstruction_benchmarks/.local/bin/env.sh" ]; then
  printf "\n\n--------------------------------\n"
  print_env.sh
  echo "--------------------------------"
fi
