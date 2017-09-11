#!/usr/bin/env bash

remote="/Volumes/data/20170911_Alaska"

dep=$1;
trip="leconte_2017_sep"
base="${HOME}/OSU/ROSS"

datadir="${base}/Data/${trip}/Swankie"
procdir="${datadir}/processed"
figdir="${base}/Figures/${trip}/Swankie/swankie_*_*2017${dep}*"
matfile="${procdir}/swankie_*2017${dep}*.mat"

rproc="${remote}/data/processed/ROSS_ADCP/"
rfig="${remote}/figures/ROSS/Swankie/"

cp -v $matfile $rprocdir
cp -rv $figdir $rfigdir
