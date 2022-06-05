#!/bin/bash -
set -o nounset # Treat unset variables as an error

STM32CP_CLI=
ADDRESS=0x8000000
ERASE=""
MODE=""
PORT=""
OPTS=""

ST_FLASH=/usr/bin/st-flash
STM32_FLASH=/usr/bin/stm32flash
DFU_UTIL=/usr/bin/dfu-util

###############################################################################
## Help function
usage() {
  echo "############################################################"
  echo "##"
  echo "## $(basename "$0") <protocol> <file_path> [OPTIONS]"
  echo "##"
  echo "## protocol:"
  echo "##   0: SWD"
  echo "##   1: Serial"
  echo "##   2: DFU"
  echo "##   Note: prefix it by 1 to erase all sectors."
  echo "##         Ex: 10 erase all sectors using SWD interface."
  echo "## file_path: file path name to be downloaded: (bin, hex)"
  echo "## Options:"
  echo "##   For SWD and DFU: no mandatory options"
  echo "##   For Serial: <com_port>"
  echo "##     com_port: serial identifier (mandatory). Ex: /dev/ttyS0 or COM1"
  echo "##"
  echo "## stm32 tools needed. run:"  
  echo "##   sudo apt-get install stlink-tools stm32flash dfu-util"
  echo "##"
  echo "## Note: all trailing arguments will be passed to the $STM32CP_CLI"
  echo "##   They have to be valid commands for STM32 MCU"
  echo "##   Ex: -g: Run the code at the specified address"
  echo "##       -rst: Reset system"
  echo "##       -s: start automatically (optional)"
  echo "############################################################"
  exit "$1"
}

if [[ ! -x ${ST_FLASH} || ! -x ${STM32_FLASH} || ! -x ${DFU_UTIL} ]]; \
then \
  echo install stm32 tools first. run; \
  echo "sudo apt-get install stlink-tools stm32flash dfu-util" ; 
fi

if [ $# -lt 2 ]; then
  echo "Not enough arguments!"
  usage 2
fi

# Parse options
PROTOCOL=$1
FILEPATH=$2

# Protocol $1
# 1x: Erase all sectors
# Protocol $1
# 0: SWD
# 1: Serial
# 2: DFU

case $PROTOCOL in
  0)
    # swd
     ${ST_FLASH} write ${FILEPATH} ${ADDRESS}
    ;;
  1)
    # serial
    if [ $# -lt 3 ]; then
      usage 3
    else
      PORT=$3
      ${STM32_FLASH} -g ${ADDRESS} -b 115200 -w ${FILEPATH} /dev/${PORT}
    fi
    ;;
  2)
    # dfu
    ${DFU_UTIL} -d 0483:df11 -a 0 --dfuse-address ${ADDRESS} -D ${FILEPATH}
    ;;
  10)
    # swd with erase
    ${ST_FLASH} erase
    ${ST_FLASH} write ${FILEPATH} ${ADDRESS}
    ;;
  11)
    # serial with erase
    if [ $# -lt 3 ]; then
      usage 3
    else
      PORT=$3
      ${STM32_FLASH} -o -R /dev/${PORT}
      ${STM32_FLASH} -g ${ADDRESS} -b 115200 -w ${FILEPATH} /dev/${PORT}
    fi
    ;;
  12)
    # dfu with erase
    ${DFU_UTIL} -d 0483:df11 -a 0 --dfuse-address ${ADDRESS}:mass-erase:force -D ${FILEPATH}
    ;;
  *)
    echo "Protocol ${PROTOCOL} unknown!"
    usage 4
    ;;
esac

exit $?
