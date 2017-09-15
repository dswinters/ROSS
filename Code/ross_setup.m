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

dir_base = fullfile(getenv('HOME'),'OSU/ROSS/');
Dirs = struct();
Dirs.data = fullfile(dir_base, 'Data/');
Dirs.figs = fullfile(dir_base, 'Figures/');
Dirs.maps = fullfile(dir_base, 'Maps/');
Dirs.logs = fullfile(dir_base, 'org/');
Dirs.meta = fullfile(dir_base, 'Metadata/');

for i = 1:length(cruise.kayaks)
    Config(i).name        = cruise.kayaks{i};
    Config(i).dirs        = Dirs;
    Config(i).cruise      = cruise;
    Config(i).deployments = deployments{i};
    %
    subdir = fullfile(cruise.name, cruise.kayaks{i}, '/');
    Config(i).dirs.data             = fullfile(Dirs.data, subdir);
    Config(i).dirs.figs             = fullfile(Dirs.figs, subdir);
    Config(i).dirs.proc.deployments = fullfile(Dirs.data, subdir, 'processed/');
    Config(i).dirs.raw              = fullfile(Dirs.data,subdir,'raw/');
    % Fill default options
    if ~isempty(Config(i).deployments)
        Config(i).deployments = ross_fill_defaults(Config(i).deployments,ross_defaults());
    end
    for d = 1:length(Config(i).deployments)
        dep = Config(i).deployments(d);
        subdir_raw    = dep.dirs.raw; % e.g. <recovery>/

        %% Make full directories
        dir_raw           = fullfile(Config(i).dirs.raw, subdir_raw, '/');
        gps_files         = dir(fullfile(dir_raw, dep.files.gps));
        adcp_files        = dir(fullfile(dir_raw, dep.files.adcp));
        dep.dirs.raw_gps  = fullfile(dir_raw, [fileparts(dep.files.gps) '/']);
        dep.dirs.raw_adcp = fullfile(dir_raw, [fileparts(dep.files.adcp) '/']);
        dep.dirs.figs     = fullfile(Config(i).dirs.figs, dep.name, '/');

        %% Make full file paths
        dep.files.gps       = fullfile(dir_raw, dep.dirs.raw_gps, {gps_files.name});
        dep.files.adcp      = fullfile(dir_raw, dep.dirs.raw_adcp, {adcp_files.name});
        dep.files.gps_mat   = fullfile(dir_raw, [dep.name '_gps.mat']);
        dep.files.adcp_mat  = fullfile(dir_raw, [dep.name '_adcp.mat']);
        dep.files.map       = fullfile(Dirs.maps,dep.files.map);
        dep.files.coastline = fullfile(Dirs.maps,dep.files.coastline);
        dep.files.gps_all   = fullfile(dep.dirs.raw_gps, ...
                                       [lower(Config(i).name) '_' subdir_raw '_gps.mat']);
        dep.files.adcp_all  = fullfile(dep.dirs.raw_adcp, ...
                                       [lower(Config(i).name) '_' subdir_raw '_adcp.mat']);
        % Update deployment
        dep.dirs = rmfield(dep.dirs,'raw');
        Config(i).deployments(d) = dep;
    end
end

Config = ross_post_setup(Config); % cruise-specific additional setup

