# ------------------------------------------
# Author:   Nguyen Canh Trung
# Email:    nguyencanhtrung (at) me (dot) com
# Date:     2023-10-06 21:23:20
# Filename: xsim
# Last Modified by:   Nguyen Canh Trung
# Last Modified time: 2023-10-06 21:29:50
# ------------------------------------------
vsim -lib xil_defaultlib tb_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

run -all
