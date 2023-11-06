##############################################################################
## This file is part of 'SLAC Firmware Standard Library'.
## It is subject to the license terms in the LICENSE.txt file found in the
## top-level directory of this distribution and at:
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
## No part of 'SLAC Firmware Standard Library', including this file,
## may be copied, modified, propagated, or distributed except according to
## the terms contained in the LICENSE.txt file.
##############################################################################

## \file vivado/dcp.tcl
# \brief This script writes the Vivado .DCP export file

## Get variables and Custom Procedures
source -quiet $::env(RUCKUS_DIR)/vivado/env_var.tcl
source -quiet $::env(RUCKUS_DIR)/vivado/proc.tcl

## Get the ouput file path
set filepath "${IMAGES_DIR}/${PRJ_TOP}"

## Open the synthesis design
open_run synth_1 -name synth_1

## Check if we need to remove the timing cosntraints
set RemoveTimingConstraints [expr {[info exists ::env(DCP_REMOVE_TIMING_CONSTRAINT)] && [string is true -strict $::env(DCP_REMOVE_TIMING_CONSTRAINT)]}]
puts "RemoveTimingConstraints = ${RemoveTimingConstraints}"
if { ${RemoveTimingConstraints} == 1 } {
   ## Delete all timing constraint for importing into a target vivado project
   reset_timing
}

## Create synth_stub
write_vhdl    -force -mode synth_stub ${filepath}_stub.vhd
write_verilog -force -mode synth_stub ${filepath}_stub.v

## Overwrite the checkpoint
write_checkpoint -force ${filepath}.dcp

## Close the checkpoint
close_design

## Parse the synth_stub
exec rm -f  ${filepath}.vho
exec python ${RUCKUS_DIR}/scripts/write_vhd_synth_stub_parser.py ${filepath}_stub.vhd

# Target specific dcp script
SourceTclFile ${VIVADO_DIR}/dcp.tcl

## Print Build complete reminder
DcpCompleteMessage ${filepath}.dcp

## IP is ready for use in target firmware project
exit 0
