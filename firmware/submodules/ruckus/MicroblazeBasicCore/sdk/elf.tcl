##############################################################################
## This file is part of 'SLAC Firmware Standard Library'.
## It is subject to the license terms in the LICENSE.txt file found in the
## top-level directory of this distribution and at:
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
## No part of 'SLAC Firmware Standard Library', including this file,
## may be copied, modified, propagated, or distributed except according to
## the terms contained in the LICENSE.txt file.
##############################################################################

## \file sdk/elf.tcl
# \brief This script builds the .elf file

# Project SDK Run Script

#############################
## Get build system variables
#############################
source $::env(RUCKUS_DIR)/vivado/env_var.tcl

# Check the Vivado version (Refer to AR#66629)
if { [expr { ${VIVADO_VERSION} < 2016.1 }] } {
   # Generate .ELF for Vivado 2015.4 (or earlier) ....  Refer to AR#66629
   sdk set_workspace ${SDK_PRJ}
   sdk build_project  -type all
} else {
   # Generate .ELF for Vivado 2016.1 (or later) ....  Refer to AR#66629
   sdk setws ${SDK_PRJ}
   sdk projects -build  -type all
}

# Copy over .ELF file to image directory
exec cp -f ${SDK_PRJ}/app_0/Release/app_0.elf ${SDK_ELF}
exec chmod 664 ${SDK_ELF}
