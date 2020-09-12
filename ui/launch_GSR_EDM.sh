#!/bin/bash

source /reg/g/pcds/setup/epicsenv-3.15.5-2.0.sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR
edm -x -noedit -m P=EM1K0:GMD:GSR:1 srg3.edl &
