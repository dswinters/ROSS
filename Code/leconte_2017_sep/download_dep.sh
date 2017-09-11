#!/usr/bin/env bash
kayak=$1
dep=$2

base="${HOME}/OSU/ROSS/"
trip="leconte_2017_sep"
remote="/Volumes/data/20170911_Alaska"

rdep="${remote}/data/raw/ROSS/${kayak}/deployment_2017${dep}/"
ldep="${base}/Data/${trip}/${kayak}/raw/deployment_2017${dep}/"
mkdir $local

cp -rv $rdep $local

