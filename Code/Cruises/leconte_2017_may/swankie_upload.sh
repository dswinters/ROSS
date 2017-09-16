#!/bin/bash
dep=$1;

procdir="${HOME}/OSU/ROSS/Data/leconte_2017_may/Swankie/processed/"
matfile="${procdir}swankie_*2017${dep}*.mat"
rprocdir="/Volumes/data/20170507_Alaska/data/processed/ROSS_ADCP/"
figdir="${HOME}/OSU/ROSS/Figures/leconte_2017_may/Swankie/swankie_*_2017${dep}*";
rfigdir="/Volumes/data/20170507_Alaska/figures/ROSS/Swankie/"

cp -v $matfile $rprocdir
cp -rv $figdir $rfigdir
