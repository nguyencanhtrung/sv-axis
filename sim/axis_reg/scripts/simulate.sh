#!/bin/bash -f
# ------------------------------------------
# Author:   Nguyen Canh Trung
# Email:    nguyencanhtrung (at) me (dot) com
# Date:     2023-10-06 21:23:20
# Filename: simulate
# Last Modified by:   Nguyen Canh Trung
# Last Modified time: 2023-10-06 21:30:46
# ------------------------------------------
bin_path="/opt/Siemens/Questa/20.4/questasim/bin"
set -Eeuo pipefail
$bin_path/vsim -64 -do "do {./scripts/xsim.do}" -l ./log/simulate.log
