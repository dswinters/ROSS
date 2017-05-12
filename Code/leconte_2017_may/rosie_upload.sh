#!/bin/bash
dep=$1;

procdir="${HOME}/OSU/ROSS/Data/leconte_2017_may/Rosie/processed/"
matfile="${procdir}rosie_*2017${dep}*.mat"
rprocdir="/Volumes/data/20170507_Alaska/data/processed/ROSS_ADCP/"
figdir="${HOME}/OSU/ROSS/Figures/leconte_2017_may/Rosie/rosie_*_2017${dep}*";
rfigdir="/Volumes/data/20170507_Alaska/figures/ROSS/Rosie/"

cp -v $matfile $rprocdir
cp -rv $figdir $rfigdir
