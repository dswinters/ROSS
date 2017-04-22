#!/bin/bash
SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`
kayak=$(echo "$SSID" | sed -e 's:^ROSS3$:Rosie:' -e 's:^ROSS6$:Swankie:')

echo "Collecting data from ${kayak}"
echo -n "ADCP..."
rsync -v "ross:~/data/${SSID}_deploy*/ADCP/*" "${kayak}/raw/ADCP/"
echo " done!"

echo -n "GPS..."
rsync -v "ross:~/data/${SSID}_deploy*/GPS/*" "${kayak}/raw/GPS/"
echo " done!"

