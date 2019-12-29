#!/usr/bin/env bash

set -ev # exit on first error, print commands

if [ "${PYTHON_ARCH}" == "32" ]; then
  set CONDA_FORCE_32BIT=1
fi
if [ -n "${TEST_RUN}" ]; then
    TEST_NAME="test-${TEST_RUN}-python-${PYTHON_VERSION}_${PYTHON_ARCH}bit"
else
    TEST_NAME="test-python-${PYTHON_VERSION}_${PYTHON_ARCH}bit"
fi
export TEST_NAME
# split dependencies into separate packages
IFS=" " TEST_DEPS=(${TEST_DEPS})
echo "Creating environment '${TEST_NAME}'..."
conda create -q -n "${TEST_NAME}" python="${PYTHON_VERSION}" "${TEST_DEPS[@]}"

set +v # we dont want to see commands in the conda script

source activate "${TEST_NAME}"
conda update pip
conda info -a
conda list

if [ -n "${PIP_DEPS}" ]; then
    pip install --upgrade pip
    # Install numpy via pip for python=3.5 and numpy=1.16
    pip install ${PIP_DEPS}
fi
