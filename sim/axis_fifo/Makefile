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
#  Description
#       1.Run make compile : compile TB/RTL code.
#       2.Run make simulate : Simulation.
#       3.Run make view : Invoke waveform.
# ---------------------------------------------------------------------------
SHELL := /bin/bash

#—————————————————————————–
#SIM directory
SIM_DIR = .

SCRIPTS_DIR = $(SIM_DIR)/scripts

#—————————————————————————–
# *.sh files
COMP_SH_FILE = compile.sh
ELAB_SH_FILE = elaborate.sh
SIM_SH_FILE = simulate.sh

#—————————————————————————–
#Questa scripts
# COMP_SCRIPT_FILE = run.do
COMP_FILE = xcomp.do
ELAB_FILE = xelab.do
SIM_FILE = xsim.do

#—————————————————————————–
#Script full path
# COMP_SCRIPT_SRC = $(SIM_DIR)/$(COMP_SCRIPT_FILE)
COMP_SCRIPT_SRC = $(SCRIPTS_DIR)/$(COMP_FILE)
ELAB_SCRIPT_SRC = $(SCRIPTS_DIR)/$(ELAB_FILE)
SIM_SCRIPT_SRC = $(SCRIPTS_DIR)/$(SIM_FILE)


COMP_SH_SCRIPT_SRC = $(SCRIPTS_DIR)/$(COMP_SH_FILE)
ELAB_SH_SCRIPT_SRC = $(SCRIPTS_DIR)/$(ELAB_SH_FILE)
SIM_SH_SCRIPT_SRC = $(SCRIPTS_DIR)/$(SIM_SH_FILE)

#—————————————————————————–
#Tool output
#—————————————————————————–
#PHONY
.PHONY : all
#—————————————————————————–
#MAKE DIRECTIVES
all: compile elaborate simulate

compile: $(COMP_SCRIPT_SRC) $(COMP_SH_SCRIPT_SRC)
	source $(COMP_SH_SCRIPT_SRC)

elaborate: $(ELAB_SCRIPT_SRC) $(ELAB_SH_SCRIPT_SRC)
	source $(ELAB_SH_SCRIPT_SRC)

simulate: $(SIM_SCRIPT_SRC) $(SIM_SH_SCRIPT_SRC)
	source $(SIM_SH_SCRIPT_SRC)

view :
	vsim -i -view vsim.wlf &
	
clean :
	rm -rf questa_lib/*
	rm -rf log/*
	rm *.wlf wlft*
