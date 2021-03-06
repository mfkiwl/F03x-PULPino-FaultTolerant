#!/bin/tcsh
source ${PULP_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=klessydra-t0-2th

##############################################################################
# Check settings
##############################################################################

# check if environment variables are defined
if (! $?MSIM_LIBS_PATH ) then
  echo "${Red} MSIM_LIBS_PATH is not defined ${NC}"
  exit 1
endif

if (! $?IPS_PATH ) then
  echo "${Red} IPS_PATH is not defined ${NC}"
  exit 1
endif

set LIB_NAME="${IP}_lib"
set LIB_PATH="${MSIM_LIBS_PATH}/${LIB_NAME}"
set IP_PATH="${IPS_PATH}/klessydra-t0-2th"
set RTL_PATH="${RTL_PATH}"

##############################################################################
# Preparing library
##############################################################################

rm -rf $LIB_PATH

vlib $LIB_PATH
vmap $LIB_NAME $LIB_PATH

##############################################################################
# Compiling RTL
##############################################################################

if (-d $IP_PATH ) then
else	
	exit 0
endif

echo "${Green}--> Compiling ${IP}... ${NC}"
echo "${Green}Compiling component: ${Brown} klessydra-t0-2th ${NC}"
echo "${Red}"
vcom -2008 -quiet -suppress 2583 -work ${LIB_PATH}   ${IP_PATH}/PKG_RiscV_Klessydra_thread_parameters.vhd || goto error
vcom -2008 -quiet -suppress 2583 -work ${LIB_PATH}   ${IP_PATH}/PKG_RiscV_Klessydra.vhd || goto error
vcom -2008 -quiet -suppress 2583 -work ${LIB_PATH}   ${IP_PATH}/RTL-CSR_Unit.vhd || goto error
vcom -2008 -quiet -suppress 2583 -work ${LIB_PATH}   ${IP_PATH}/RTL-Debug_Unit.vhd || goto error
vcom -2008 -quiet -suppress 2583 -work ${LIB_PATH}   ${IP_PATH}/RTL-Processing_Pipeline.vhd || goto error
vcom -2008 -quiet -suppress 2583 -work ${LIB_PATH}   ${IP_PATH}/RTL-Program_Counter_unit.vhd || goto error
vcom -2008 -quiet -suppress 2583 -work ${LIB_PATH}   ${IP_PATH}/STR-Klessydra_top.vhd || goto error

echo "${Cyan}--> ${IP} compilation complete! ${NC}"

exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
