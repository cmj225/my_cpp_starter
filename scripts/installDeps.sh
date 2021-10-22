#!/bin/bash -e
SCRIPT=`pwd`/$0
FILENAME=`basename $SCRIPT`
PATHNAME=`dirname $SCRIPT`
ROOT=$PATHNAME/..
BUILD_DIR=$ROOT/build
CURRENT_DIR=`pwd`

LIB_DIR=$BUILD_DIR/libdeps
PREFIX_DIR=$LIB_DIR/build/
DISABLE_NONFREE=true
CLEANUP=false
NO_INTERNAL=false
INCR_INSTALL=false
ONLY_INSTALL=""
ENABLE_WEBTRANSPORT=false
SUDO=""

if [[ $EUID -ne 0 ]]; then
  SUDO="sudo -E"
fi

parse_arguments(){
  while [ "$1" != "" ]; do
    case $1 in
      "--with-nonfree-libs")
        DISABLE_NONFREE=false
        ;;
      "--cleanup")
        CLEANUP=true
        ;;
      "--no-internal")
        NO_INTERNAL=true
        ;;
      "--incremental")
        INCR_INSTALL=true
        ;;
      "--enable-webtransport")
        ENABLE_WEBTRANSPORT=true
        ;;
      "--only")
        shift
        ONLY_INSTALL=$1
        ;;
    esac
    shift
  done
}

OS=`$PATHNAME/detectOS.sh | awk '{print tolower($0)}'`
OS_VERSION=`$PATHNAME/detectOS.sh | awk '{print tolower($2)}'`
echo $OS

cd $PATHNAME
. installCommonDeps.sh

mkdir -p $PREFIX_DIR

if [[ "$OS" =~ .*ubuntu.* ]]
then
  . installUbuntuDeps.sh
  pause "Installing deps via apt-get... [press Enter]"
  install_apt_deps
  if [[ "$OS_VERSION" =~ 20.04.* ]]
  then
    install_gcc_7
    install_boost
  fi
else
  exit 0
fi

parse_arguments $*

if [ ! -z $ONLY_INSTALL ]; then
  type install_${ONLY_INSTALL} > /dev/null 2>&1
  [[ $? -eq 0 ]] && install_${ONLY_INSTALL} || echo "${ONLY_INSTALL} not found"
  exit 0
fi

pause "Installing Node.js ... [press Enter]"
install_node

if [ "$DISABLE_NONFREE" = "true" ]; then
  pause "Nonfree libraries disabled: aac transcoding unavailable. [press Enter]"
  install_mediadeps
else
  pause "Nonfree libraries enabled (DO NOT redistribute these libraries!!); to disable nonfree please use the \`--disable-nonfree' option. [press Enter]"
  install_mediadeps_nonfree
fi

${NO_INTERNAL} || (pause "Installing webrtc library... [press Enter]" && install_webrtc)

if [ "$CLEANUP" = "true" ]; then
  echo "Cleaning up..."
  cleanup
fi
