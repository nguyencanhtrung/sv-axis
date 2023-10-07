# ------------------------------------------
# Author:   Nguyen Canh Trung
# Email:    nguyencanhtrung (at) me (dot) com
# Date:     2023-10-06 21:23:20
# Filename: xelab
# Last Modified by:   Nguyen Canh Trung
# Last Modified time: 2023-10-06 21:29:37
# ------------------------------------------
vopt -64 +acc=npr -suppress 10016 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -work xil_defaultlib xil_defaultlib.tb xil_defaultlib.glbl -o tb_opt
