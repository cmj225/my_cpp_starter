#!/bin/bash -e
#
# http://eh.meklu.org/script/meksysinfo

if [ -f /etc/os-release ]
then
  source /etc/os-release
  if [ -n "${PRETTY_NAME}" ]
  then
    printf "${PRETTY_NAME}\n"
  else
    printf "${NAME}"
    [[ -n "${VERSION}" ]] && printf " ${VERSION}"
    printf "\n"
  fi
# now looking at distro-specific files
elif [ -f /etc/arch-release ]
then
  printf "Arch Linux\n"
elif [ -f /etc/gentoo-release ]
then
  cat /etc/gentoo-release
elif [ -f /etc/fedora-release ]
then
  cat /etc/fedora-release
elif [ -f /etc/redhat-release ]
then
  cat /etc/redhat-release
elif [ -f /etc/debian_version ]
then
  printf "Debian GNU/Linux " ; cat /etc/debian_version
else
  printf "Unknown\n"
fi
