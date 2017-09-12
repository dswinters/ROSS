#!/usr/bin/env bash
dep=$1
kayak=$2

base="${HOME}/OSU/ROSS"
rdep="${SCISHARE}/data/raw/ROSS/${kayak}/deployment_201709${dep}/"
ldep="${base}/Data/${TRIP}/${kayak}/raw/deployment_201709${dep}/"

echo cp -rv $rdep $ldep

