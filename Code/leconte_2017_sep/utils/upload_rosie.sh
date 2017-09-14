#!/usr/bin/env bash

dep="201709${1}"
base="${HOME}/OSU/ROSS"

# Local files/directories
matfile="${base}/Data/${TRIP}/Rosie/processed/rosie_*_${dep}*.mat"
figdir="${base}/Figures/${TRIP}/Rosie/rosie_*_${dep}*"

# Remote directories
rprocdir="${SCISHARE}/data/processed/ADCP_ROSS/"
rfigdir="${SCISHARE}/figures/ROSS/Rosie/"

# Copy local files to remote
cp -v $matfile $rprocdir
cp -rv $figdir $rfigdir

