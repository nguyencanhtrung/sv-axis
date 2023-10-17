# ---------------------------------------------------------------------------
#            ___  _    __         =        ___  _  __    __ ___            --   
#           / ._\| |  / /         =       /   | \\/ /   / // ._\           --         
#           \ __ | | / /          =      / /| |  / /   / / \ __            --
#         ____. \| |/ /           =     / /_| | / /\  / /____. \           --
#        /______/|___/            =    /_/  |_|/_/ \\/_//______/           --
#                               =====                                      --
#                                ===                                       --
# ------------------------------  =  ----------------------------------------
#  Copyright © 2023, 2024 - Nguyen Canh Trung
#  (nguyencanhtrung 'at' me 'dot' com)
# 
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and associated documentation files (the "Software"),
#  to deal in the Software without restriction, including without limitation
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,
#  and/or sell copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following conditions:
# 
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
# 
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
#  DEALINGS IN THE SOFTWARE.
# 
#  DEPENDENCIES: none
# 
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
"$repo_imp/tb_axis_reg.sv" \

# compile glbl module
vlog -work xil_defaultlib "glbl.v"

