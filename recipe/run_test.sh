#!/bin/bash

if [[ ! -f ${PREFIX}/lib/plugins/libOpenMMHIP.so ]]; then
    exit 1
fi
if [[ ! -f ${PREFIX}/lib/plugins/libOpenMMAmoebaHIP.so ]]; then
    exit 1
fi
if [[ ! -f ${PREFIX}/lib/plugins/libOpenMMDrudeHIP.so ]]; then
    exit 1
fi
if [[ ! -f ${PREFIX}/lib/plugins/libOpenMMRPMDHIP.so ]]; then
    exit 1
fi
python -c "from openmm import *; assert \"$PKG_VERSION\".startswith(Platform.getOpenMMVersion())"