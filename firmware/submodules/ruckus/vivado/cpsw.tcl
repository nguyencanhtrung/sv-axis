##############################################################################
## This file is part of 'SLAC Firmware Standard Library'.
## It is subject to the license terms in the LICENSE.txt file found in the
## top-level directory of this distribution and at:
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
## No part of 'SLAC Firmware Standard Library', including this file,
## may be copied, modified, propagated, or distributed except according to
## the terms contained in the LICENSE.txt file.
##############################################################################

## \file vivado/cpsw.tcl
# \brief This scripts tarballs all the cpsw yaml source code

# Get variables and Custom Procedures
source $::env(RUCKUS_DIR)/vivado/env_var.tcl

# Check for top level YAML file
if { [file exists ${PROJ_DIR}/yaml/000TopLevel.yaml] != 1 } {
   puts "\n\nERROR: ${PROJ_DIR}/yaml/000TopLevel.yaml does NOT exist\n\n"
   exit -1
}

# Common Variable
set ProjYamlDir "${OUT_DIR}/${PROJECT}_project.yaml"

# Remove old directory and files
exec rm -rf ${ProjYamlDir}
exec rm -rf ${IMAGES_DIR}/$::env(IMAGENAME).cpsw.tar.gz

# Create a new directory
exec mkdir ${ProjYamlDir}

# Get the ruckus.tcl directory list
set dirList [read [open ${OUT_DIR}/dirList.txt]]

# check for non-empty list
if { ${dirList} != "" } {
   # Loop through the list
   foreach dirPntr ${dirList} {
      # Check if yaml directory exist
      if { [file isdirectory ${dirPntr}/yaml/] == 1 } {
         # Create a list of files
         set fileList [glob -dir ${dirPntr}/yaml/ *]
         # check for non-empty list
         if { ${fileList} != "" } {
            # Loop through the list
            foreach filePntr ${fileList} {
               # Copy all the files
               exec cp -f ${filePntr} ${ProjYamlDir}/
            }
         }
      }
   }
}

# Copy the licensing file
exec cp -f ${RUCKUS_DIR}/LICENSE.txt ${ProjYamlDir}/.

# Copy the build.info
if { $::env(GIT_HASH_LONG) != "" } {
   if { [file exists ${PROJ_DIR}/build.info] == 1 } {
      exec cp -f ${PROJ_DIR}/build.info ${ProjYamlDir}/.
   }
}

# Copy the .ltx file
set filePath "$::env(OUT_DIR)/debugProbes.ltx"; # Vivado 2016 (or earlier)
if { [file exists ${filePath}] == 1 } {
   exec cp -f ${filePath} ${ProjYamlDir}/.
}
set filePath "$::env(IMPL_DIR)/debug_nets.ltx"; # Vivado 2017 (or later)
if { [file exists ${filePath}] == 1 } {
   exec cp -f ${filePath} ${ProjYamlDir}/.
}

# Set the defaults directory
if { [info exists ::env(DEFAULTS_DIR)] != 1 } {
   set defaultsDir "$::env(PROJ_DIR)/config"
} else {
   set defaultsDir "$::env(DEFAULTS_DIR)"
}

# Copy the defaults into the dump directory
if { [file isdirectory ${defaultsDir}] == 1 } {
	exec cp -rf ${defaultsDir} ${ProjYamlDir}/.
} else {
	puts "Note: ${defaultsDir} doesn't exist"
}

# Compress the project's YAML directory to the target's image directory
exec tar -zcvf  ${IMAGES_DIR}/$::env(IMAGENAME).cpsw.tar.gz -C ${OUT_DIR} ${PROJECT}_project.yaml
puts "${IMAGES_DIR}/$::env(IMAGENAME).cpsw.tar.gz"

# Create a copy of the tar.gz file with ones padding for PROM loading support (prevent Vivado from unzipping from the load)
if { [file isdirectory $::env(IMPL_DIR)] == 1 } {
   set onesFile "$::env(IMPL_DIR)/ones.bin"
   exec rm -f ${onesFile}
   exec printf "%b" '\xff\xff' > ${onesFile}
   exec cat ${onesFile} ${IMAGES_DIR}/$::env(IMAGENAME).cpsw.tar.gz > $::env(IMPL_DIR)/$::env(IMAGENAME).cpsw.tar.gz
}
