##############################################################################
## This file is part of 'SLAC Firmware Standard Library'.
## It is subject to the license terms in the LICENSE.txt file found in the
## top-level directory of this distribution and at:
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
## No part of 'SLAC Firmware Standard Library', including this file,
## may be copied, modified, propagated, or distributed except according to
## the terms contained in the LICENSE.txt file.
##############################################################################

## \file vitis/hls/sources.tcl
# \brief This script loads the source code into the Vitis HLS project

## Get variables and Custom Procedures
set RUCKUS_DIR $::env(RUCKUS_DIR)
source ${RUCKUS_DIR}/vitis/hls/env_var.tcl
source ${RUCKUS_DIR}/vitis/hls/proc.tcl

## Check for unsupported Vitis_HLS versions
if { [HlsVersionCheck] < 0 } {
   exit -1
}

## Create a Project
open_project ${PROJECT}_project

## Set the top level module
set_top ${PROJECT}

## Add sources
source ${PROJ_DIR}/sources.tcl

## Create a solution
open_solution "solution1"

## Setup the csim ldflags
if { $::env(SKIP_CSIM) == 0 } {

   set retVal [catch { \
      csim_design -O -setup \
      -ldflags ${LDFLAGS} \
      -mflags ${MFLAGS} \
      -argv ${ARGV} \
   }]

   CheckProcRetVal ${retVal} "csim setup" "vitis/hls/sources"

}

## Target specific solution setup script
source ${PROJ_DIR}/solution.tcl

## Close the solution
close_solution

## Close the project
close_project

## Check if directives.tcl exists in the source tree
if { [file exists  ${PROJ_DIR}/directives.tcl] == 0 } {
   exec echo  > ${PROJ_DIR}/directives.tcl
}

## Check if solution1.directive exists in the source tree
if { [file exists  ${PROJ_DIR}/solution1.directive] == 0 } {
   exec echo  > ${PROJ_DIR}/solution1.directive
}

exit 0
