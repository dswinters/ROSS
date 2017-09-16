%% leconte_2017_may_ROSS_gps_raw2mat.m
% Usage: leconte_2017_may_ROSS_gps_raw2mat
% Description: Combine gps .log files from ROSIE and SWANKIE
%              deployments and convert them to .mat files.
%              Output files are saved to:
%              20170507_Alaska/data/raw/ROSS/KAYAK/DEP/GPS/gps_DEP.mat
% Inputs: none
% Outputs: none
% Requires: nav_read.m
% Author: Dylan Winters
% Created: 2017-05-11

clear all, close all
reprocess_all = true;

% Set scishare to however your computer sees it
scishare = '/Volumes/data/';
dir_in = fullfile(scishare,'20170507_Alaska/data/raw/ROSS/');
kayaks = {'Rosie','Swankie'};
nmea_prefixes = {'GPGGA','GPRMC','GPHEV','HEHDT','GPHEV','PASHR'};

for k = 1:length(kayaks)
    deps = dir(fullfile(dir_in,kayaks{k},'deployment_2017*'));
    dep_dirs = fullfile(dir_in,kayaks{k},{deps.name});

    for d = 1:length(dep_dirs)
        gps_logs = dir(fullfile(dep_dirs{d},'GPS','*.log'));
        f_names = fullfile(dep_dirs{d},'GPS',{gps_logs.name});

        dir_out = fullfile(scishare,'20170507_Alaska/data/processed/ROSS_GPS/');
        f_out = fullfile(dir_out,[lower(kayaks{k}) '_' deps(d).name '_gps.mat']);
        if ~exist(f_out,'file') | reprocess_all
            gps = nav_read(f_names,nmea_prefixes);
            save(f_out,'gps');
            disp(['Saved ' f_out])
        end

    end
end