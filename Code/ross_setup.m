%% ross_setup.m
% Usage: Ross = ross_setup(cruise,deployments)
% Description: This function does all the heavy lifting for determining full
%              paths to files that will be loaded or saved during processing.
% Inputs: cruise,deployments - Cruise and deployment information from the cruise-
%         specific deployment file.
% Outputs: Ross - The master control structure containing filepaths and 
%          processing instructions.
%
% Author: Dylan Winters
% Created: 2017-09-13

function Ross = ross_setup(cruise,deployments)

Dirs = struct();
Dirs.base = fullfile(getenv('HOME'),'OSU/ROSS/');
Dirs.data = fullfile(Dirs.base, 'Data/');
Dirs.figs = fullfile(Dirs.base, 'Figures/');
Dirs.maps = fullfile(Dirs.base, 'Maps/');
Dirs.logs = fullfile(Dirs.base, 'org/');
Dirs.meta = fullfile(Dirs.base, 'Metadata/');

for i = 1:length(cruise.kayaks)
    Ross(i).dirs        = Dirs;
    Ross(i).name        = cruise.kayaks{i};
    Ross(i).cruise      = cruise;
    Ross(i).deployments = deployments{i};
    %
    subdir = fullfile(cruise.name, cruise.kayaks{i}, '/');
    Ross(i).dirs.figs             = fullfile(Dirs.figs, subdir);
    Ross(i).dirs.proc.deployments = fullfile(Dirs.data, subdir, 'processed/');
    Ross(i).dirs.raw              = fullfile(Dirs.data,subdir,'raw/');
    % Fill default options
    if ~isempty(Ross(i).deployments)
        Ross(i).deployments = ross_fill_defaults(Ross(i).deployments,ross_defaults());
    end
    for d = 1:length(Ross(i).deployments)
        dep = Ross(i).deployments(d);
        % Make full paths
        dep.dirs.raw_gps  = [Ross(i).dirs.raw, dep.dirs.raw_gps];
        dep.dirs.raw_adcp = [Ross(i).dirs.raw, dep.dirs.raw_adcp];
        dep.dirs.figs     = [Ross(i).dirs.figs, dep.name '/'];
        % Find GPS & ADCP files
        gps_files  = dir([dep.dirs.raw_gps, dep.files.gps]);
        adcp_files = dir([dep.dirs.raw_adcp, dep.files.adcp]);
        % Make full file paths
        dep.files.gps  = strcat(dep.dirs.raw_gps, {gps_files.name});
        dep.files.adcp = strcat(dep.dirs.raw_adcp, {adcp_files.name});
        dep.files.map  = fullfile(Dirs.maps,dep.files.map);
        dep.files.coastline = fullfile(Dirs.maps,dep.files.coastline);
        % Update deployment
        Ross(i).deployments(d) = dep;
    end
end
