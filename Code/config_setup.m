function Config = config_setup(cruise_name,varargin)

% Ensure that necessary directories are in MATLAB's search path
addpath('figures/'); % add figure functions to path
addpath('misc/');    % misc helper functions
addpath('hooks/');   % hooks

Config = config_cruise(cruise_name,varargin{:}); % Cruise configuration

for i = 1:length(Config)

    % Fill default options
    if ~isempty(Config(i).deployments)
        Config(i).deployments = fill_defaults(Config(i).deployments,config_defaults());
    end
    [Config(i).deployments.cruise] = deal(struct());
    [Config(i).deployments.vessel] = deal(struct());

    % Set up deployments
    for d = 1:length(Config(i).deployments)
        dep = Config(i).deployments(d);
        subdir_raw    = dep.dirs.raw;

        %% Make full directories
        dir_raw     = fullfile(Config(i).dirs.raw, subdir_raw, '/');
        gps_files   = dir(fullfile(dir_raw, dep.files.gps));
        adcp_files  = dir(fullfile(dir_raw, dep.files.adcp));
        %
        dep.dirs.raw_gps  = fullfile(dir_raw, [fileparts(dep.files.gps) '/']);
        dep.dirs.raw_adcp = fullfile(dir_raw, [fileparts(dep.files.adcp) '/']);
        dep.dirs.figs     = fullfile(Config(i).dirs.figs, dep.name, '/');

        %% Make full file paths
        gps_all  = [lower(Config(i).name) '_' subdir_raw '_gps.mat'];
        adcp_all = [lower(Config(i).name) '_' subdir_raw '_adcp.mat'];
        %
        dep.files.gps       = fullfile(dep.dirs.raw_gps, {gps_files.name});
        dep.files.adcp      = fullfile(dep.dirs.raw_adcp, {adcp_files.name});
        dep.files.gps_mat   = fullfile(dep.dirs.raw_gps, [dep.name '_gps.mat']);
        dep.files.adcp_mat  = fullfile(dep.dirs.raw_adcp, [dep.name '_adcp.mat']);
        dep.files.map       = fullfile(Config(i).dirs.maps,dep.files.map);
        dep.files.coastline = fullfile(Config(i).dirs.maps,dep.files.coastline);
        dep.files.gps_all   = fullfile(dep.dirs.raw_gps, gps_all);
        dep.files.adcp_all  = fullfile(dep.dirs.raw_adcp, adcp_all);
        dep.files.processed = fullfile(Config(i).dirs.proc, [dep.name '.mat']);

        %% Add cruise and vessel information
        dep.cruise.name = Config(i).cruise;
        dep.vessel.name = Config(i).name;

        % Update deployment
        dep.dirs = rmfield(dep.dirs,'raw');
        Config(i).deployments(d) = dep;

    end
end

for i = 1:length(Config)
    Config(i) = post_setup_hook(Config(i));
end

