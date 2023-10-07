#!/bin/bash -f
# ------------------------------------------
# Author:   Nguyen Canh Trung
# Email:    nguyencanhtrung (at) me (dot) com
# Date:     2023-10-06 21:23:20
# Filename: elaborate
# Last Modified by:   Nguyen Canh Trung
# Last Modified time: 2023-10-06 21:30:32
# ------------------------------------------
set -Eeuo pipefail
source ./scripts/xelab.do 2>&1 | tee ./log/elaborate.log