#!/bin/bash
kayak=$1
dep=$2

rdir="/Volumes/data/20170507_Alaska/data/raw/ROSS/${kayak}/deployment_2017${dep}/"
radcp="${rdir}ADCP/*"
rgps="${rdir}GPS/*"

ladcpdir="${HOME}/OSU/ROSS/Data/leconte_2017_may/${kayak}/raw/ADCP/deployment_2017${dep}/"
lgpsdir="${HOME}/OSU/ROSS/Data/leconte_2017_may/${kayak}/raw/GPS/deployment_2017${dep}/"

mkdir $ladcpdir
mkdir $lgpsdir

cp -v $radcp $ladcpdir
cp -v $rgps $lgpsdir

