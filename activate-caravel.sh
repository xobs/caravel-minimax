#!/bin/sh
if [ "$0" = "activate-caravel.sh" ]
then
    echo "Don't run $0, source it by running '. $0'"
    echo "Alternately, set the 'OPENLANE_ROOT', 'PDK_ROOT', and 'PDK' environment variables manually"
    exit 1
fi

export PDK=gf180mcuC
export OPENLANE_ROOT=$(realpath $(pwd)/..)/dependencies/openlane_src
export TIMING_ROOT=$(realpath $(pwd)/..)/dependencies/timing-scripts
export PDK_ROOT=$(realpath $(pwd)/..)/dependencies/pdks
export PRECHECK_ROOT=$(realpath $(pwd)/..)/dependencies/precheck
export CARAVEL_ROOT=$(realpath $(pwd)/..)/dependencies/caravel
export MCW_ROOT=$(realpath $(pwd)/..)/dependencies/mgmt_core_wrapper
