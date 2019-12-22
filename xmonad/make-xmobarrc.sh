#!/usr/bin/env bash

set -euf -o pipefail

wiiface=$(cat /proc/net/wireless | tail -n1 | awk '{print $1}' | sed -e s/://g)
cpuvendor=$(grep vendor_id /proc/cpuinfo | head -n1 | cut -d: -f2 | sed 's/ *//g')

echo WIFI interface detected: ${wiiface}
echo CPU Vendor: ${cpuvendor}

cp xmobar.hs xmobarrc

sed -i 's/{wiiface}/'${wiiface}'/g' xmobarrc
temp="%multicoretemp% | "
[[ "${cpuvendor}" == "AuthenticAMD" ]] && temp=""
sed -i 's/{temp}/'"${temp}"'/g' xmobarrc
