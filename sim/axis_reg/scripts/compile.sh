#!/bin/bash -f
# ------------------------------------------
# Author:   Nguyen Canh Trung
# Email:    nguyencanhtrung (at) me (dot) com
# Date:     2023-10-06 21:23:20
# Filename: compile
# Last Modified by:   Nguyen Canh Trung
# Last Modified time: 2023-10-06 21:30:17
# ------------------------------------------
set -Eeuo pipefail
source ./scripts/xcomp.do 2>&1 | tee ./log/compile.log

