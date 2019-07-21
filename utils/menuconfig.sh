#!/bin/bash

IFS=
path="diff"
rpi="> # "
x86="< # "

function build_config() {
  echo "[+] Running the build process ..."
  cp -f base-firmware.config /tmp/base-firmware.config
  while read -r line; do
   if [[ "$(echo $line | head -c 1)" == $2 ]];
   then
    line=$(tr -s $1 '@' <<< "$line")
    line=$(cut -d "@" -f 2 <<< "$line")
    echo -e "$line" >> /tmp/base-firmware.config
    echo "[*] Written '$line' to base-firmware.config"
   fi
  done < "$3"
}

printf "[+] Vulnerable arch config build script\n\n"
echo "What arch do you want to build (?)"
echo "        1. x86 (generic)"
echo "        2. Raspberry Pi (Broadcom BCM27xx)"
read -p "Enter number to choose arch build type (i.e. 1, 2): " opt
read -p "    Continue build? (Y/N): " \
    confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] \
    || { echo "Script aborted. Quitting."; exit 0; }
printf "\n\n"
if [[ $opt = "1" ]]
then
  type="$(echo $x86 | head -c 1)"
  build_config $x86 $type $path
elif [[ $opt = "2" ]]
then
  type="$(echo $rpi | head -c 1)"
  echo $type
  build_config $rpi $type $path
else
  echo "[-] Invalid input."
fi
mv -f /tmp/base-firmware.config OpenWrt/openwrt-18.06.2/.config
printf "\n\n[+] Generated the .config.\n[*] Moving to target location.\n[+] Configuration successfully written.\n"