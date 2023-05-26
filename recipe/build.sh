#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2023. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************
set -vex
source open-ce-common-utils.sh

# Build Tensorflow from source
SCRIPT_DIR=$RECIPE_DIR/../buildscripts

# Pick up additional variables defined from the conda build environment
$SCRIPT_DIR/set_python_path_for_bazelrc.sh $SRC_DIR

sh ${SRC_DIR}/configure.sh

# install using pip from the whl file
bazel --bazelrc=$SRC_DIR/python_configure.bazelrc build \
      --verbose_failures $BAZEL_OPTIMIZATION //tensorflow_io_gcs_filesystem/...

python setup.py bdist_wheel --data bazel-bin --project tensorflow-io-gcs-filesystem
python -m pip install dist/*.whl

PID=$(bazel info server_pid)
echo "PID: $PID"
cleanup_bazel $PID