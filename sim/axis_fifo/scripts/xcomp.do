# ------------------------------------------
# Author:   Nguyen Canh Trung
# Email:    nguyencanhtrung (at) me (dot) com
# Date:     2023-10-06 21:28:51
# Filename: xcomp
# Last Modified by:   Nguyen Canh Trung
# Last Modified time: 2023-10-06 21:41:11
# ------------------------------------------
repo_lib="/home/tesla/workspace/05.Soc/03.rtl/00.libs"
repo_imp="/home/tesla/workspace/05.Soc/03.rtl/00.libs/sv-axis/tb"

vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

# Libraries
vlog -64 -incr -mfcu -suppress 7061 -sv -work xil_defaultlib \
"$repo_lib/sv-axis/rtl/axis_fifo.sv" \
"$repo_lib/sv-axis/rtl/axis_reg.sv" \
"$repo_lib/sv-common/rtl/ifc_axis.sv" \
"$repo_lib/sv-common/rtl/sof_detect.sv" \

# Design
vlog -64 -incr -mfcu -suppress 7061 -sv -work xil_defaultlib \
"$repo_imp/tb_axis_fifo.sv" \

# compile glbl module
vlog -work xil_defaultlib "glbl.v"

