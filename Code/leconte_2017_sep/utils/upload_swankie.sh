#!/usr/bin/env bash

dep="201709${1}"
base="${HOME}/OSU/ROSS"

# Local files/directories
matfile="${base}/Data/${TRIP}/Swankie/processed/swankie_*_${dep}*.mat"
figdir="${base}/Figures/${TRIP}/Swankie/swankie_*_${dep}*"

# Remote directories
rprocdir="${SCISHARE}/data/processed/ADCP_ROSS/"
rfigdir="${SCISHARE}/figures/ROSS/Swankie/"

# Copy local files to remote
cp -v $matfile $rprocdir
cp -rv $figdir $rfigdir

