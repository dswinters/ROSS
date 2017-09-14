%% ross_setup.m
% Usage: Config = ross_setup(cruise,deployments)
% Description: This function does all the heavy lifting for determining full
%              paths to files that will be loaded or saved during processing.
% Inputs: cruise,deployments - Cruise and deployment information from the cruise-
%         specific deployment file.
% Outputs: Config - The master control structure containing filepaths and 
%          processing instructions.
%
% Author: Dylan Winters
% Created: 2017-09-13

function Config = ross_setup(cruise,deployments)

Dirs = struct();
Dirs.base = fullfile(getenv('HOME'),'OSU/ROSS/');
Dirs.data = fullfile(Dirs.base, 'Data/');
Dirs.figs = fullfile(Dirs.base, 'Figures/');
Dirs.maps = fullfile(Dirs.base, 'Maps/');
Dirs.logs = fullfile(Dirs.base, 'org/');
Dirs.meta = fullfile(Dirs.base, 'Metadata/');

for i = 1:length(cruise.kayaks)
    Config(i).dirs        = Dirs;
    Config(i).name        = cruise.kayaks{i};
    Config(i).cruise      = cruise;
    Config(i).deployments = deployments{i};
    %
    subdir = fullfile(cruise.name, cruise.kayaks{i}, '/');
    Config(i).dirs.figs             = fullfile(Dirs.figs, subdir);
    Config(i).dirs.proc.deployments = fullfile(Dirs.data, subdir, 'processed/');
    Config(i).dirs.raw              = fullfile(Dirs.data,subdir,'raw/');
    % Fill default options
    if ~isempty(Config(i).deployments)
        Config(i).deployments = ross_fill_defaults(Config(i).deployments,ross_defaults());
    end
    for d = 1:length(Config(i).deployments)
        dep = Config(i).deployments(d);
        % Make full paths
        dir_raw       = fullfile(Config(i).dirs.raw, dep.dirs.raw, '/');
        dep.dirs.figs = fullfile(Config(i).dirs.figs, dep.name, '/');
        % Find GPS & ADCP files
        gps_files    = dir(fullfile(dir_raw, dep.files.gps));
        adcp_files   = dir(fullfile(dir_raw, dep.files.adcp));
        dep.dirs.raw_gps  = [fileparts(dep.files.gps) '/'];
        dep.dirs.raw_adcp = [fileparts(dep.files.adcp) '/'];
        % Make full file paths
        dep.files.gps  = fullfile(dir_raw, dep.dirs.raw_gps, {gps_files.name});
        dep.files.adcp = fullfile(dir_raw, dep.dirs.raw_adcp, {adcp_files.name});
        dep.files.map  = fullfile(Dirs.maps,dep.files.map);
        dep.files.coastline = fullfile(Dirs.maps,dep.files.coastline);
        % Full-deployment raw .mat files
        dep.files.gps_all  = fullfile(dir_raw, dep.dirs.raw_gps, ...
                                      [lower(Config(i).name) '_' dep.dirs.raw '_gps.mat']);
        dep.files.adcp_all = fullfile(dir_raw, dep.dirs.raw_adcp, ...
                                      [lower(Config(i).name) '_' dep.dirs.raw '_adcp.mat']);
        % Update deployment
        Config(i).deployments(d) = dep;
    end
end

Config = ross_post_setup(Config); % cruise-specific additional setup

