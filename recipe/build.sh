#!/bin/bash

set -xeuo pipefail

CMAKE_FLAGS="${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX=${HOME}/openmm -DCMAKE_BUILD_TYPE=Release"
CMAKE_FLAGS+=" -DBUILD_TESTING=OFF -DOPENMM_BUILD_HIP_LIB=ON -DOPENMM_BUILD_PYTHON_WRAPPERS=OFF"
CMAKE_FLAGS+=" -DOPENMM_BUILD_C_AND_FORTRAN_WRAPPERS=OFF -DOPENMM_GENERATE_API_DOCS=OFF"
CMAKE_FLAGS+=" -DOPENMM_BUILD_EXAMPLES=OFF"

if [[ "$target_platform" == linux* ]]; then
    MINIMAL_CFLAGS+=" -O3 -ldl"
    CFLAGS+=" $MINIMAL_CFLAGS"
    CXXFLAGS+=" $MINIMAL_CFLAGS"
fi

# Build in subdirectory and install.
mkdir -p build
cd build
cmake ${CMAKE_FLAGS} ${SRC_DIR}
make -j$CPU_COUNT
make -j$CPU_COUNT install

# Copy the HIP files into the conda environment.
mkdir -p ${PREFIX}/lib/plugins
mkdir -p ${PREFIX}/include/openmm
cp ${HOME}/openmm/lib/plugins/*HIP* ${PREFIX}/lib/plugins
cp -R ${HOME}/openmm/include/openmm/hip ${PREFIX}/include/openmm

# Fix some overlinking warnings/errors
for lib in ${PREFIX}/lib/plugins/*${SHLIB_EXT}; do
    ln -s $lib ${PREFIX}/lib/$(basename $lib) || true
done
