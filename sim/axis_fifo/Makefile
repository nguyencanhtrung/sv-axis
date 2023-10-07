# ------------------------------------------
# Author:   Nguyen Canh Trung
# Email:    trungnc@soc.one
# Date:     2023-01-06 04:56:10
# Filename: run
# Last Modified by:   Nguyen Canh Trung
# Last Modified time: 2023-01-08 16:20:02
# Description:
#   Guide :
#       1.Run make compile : compile TB/RTL code.
#       2.Run make simulate : Simulation.
#       3.Run make view : Invoke waveform.
# ------------------------------------------
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
