#!/usr/bin/env bash

dep="201709${1}"
base="${HOME}/OSU/ROSS"

# Local files/directories
matfile="${base}/Data/${TRIP}/Casey/processed/casey_*_${dep}*.mat"
figdir="${base}/Figures/${TRIP}/Casey/casey_*_201709${dep}*"

# Remote directories
rprocdir="${SCISHARE}/data/processed/ADCP_ROSS/"
rfigdir="${SCISHARE}/figures/ROSS/Casey/"

# Copy local files to remote
cp -v $matfile $rprocdir
cp -rv $figdir $rfigdir

