function Vessels = config_setup(cruise_name,varargin)

% Ensure that necessary directories are in MATLAB's search path
addpath('figures/'); % add figure functions to path
addpath('misc/');    % misc helper functions
addpath('hooks/');   % hooks

Vessels = config_cruise(cruise_name,varargin{:}); % Cruise configuration

for i = 1:length(Vessels)

    % Fill default options
    if ~isempty(Vessels(i).deployments)
        Vessels(i).deployments = fill_defaults(Vessels(i).deployments,config_defaults());
    end

    % Add 'cruise' field if there isn't one already
    if ~isfield(Vessels(i).deployments,'cruise')
        [Vessels(i).deployments.cruise] = deal(struct());
    end

    % Add 'vessel' field if there isn't one already
    if ~isfield(Vessels(i).deployments,'vessel')
        [Vessels(i).deployments.vessel] = deal(struct());
    end

    % Set up deployments
    for d = 1:length(Vessels(i).deployments)
        dep = Vessels(i).deployments(d);
        subdir_raw    = dep.dirs.raw;

        %% Make full directories
        dir_raw     = fullfile(Vessels(i).dirs.raw, subdir_raw, '/');
        gps_files   = dir(fullfile(dir_raw, dep.files.gps));
        adcp_files  = dir(fullfile(dir_raw, dep.files.adcp));
        %
        dep.dirs.raw_gps  = fullfile(dir_raw, [fileparts(dep.files.gps) '/']);
        dep.dirs.raw_adcp = fullfile(dir_raw, [fileparts(dep.files.adcp) '/']);
        dep.dirs.figs     = fullfile(Vessels(i).dirs.figs, dep.name, '/');

        %% Make full file paths
        [~,dirname] = fileparts(fileparts(fullfile(dep.dirs.raw_adcp,'/')));
        adcp_all = [dirname '_adcp.mat'];
        [~,dirname] = fileparts(fileparts(fullfile(dep.dirs.raw_gps,'/')));
        gps_all = [dirname '_gps.mat'];
        dep.files.gps       = fullfile(dep.dirs.raw_gps, {gps_files.name});
        dep.files.adcp      = fullfile(dep.dirs.raw_adcp, {adcp_files.name});
        dep.files.gps_mat   = fullfile(dep.dirs.raw_gps, [dep.name '_gps.mat']);
        dep.files.adcp_mat  = fullfile(dep.dirs.raw_adcp, [dep.name '_adcp.mat']);
        dep.files.map       = fullfile(Vessels(i).dirs.maps,dep.files.map);
        dep.files.coastline = fullfile(Vessels(i).dirs.maps,dep.files.coastline);
        dep.files.gps_all   = fullfile(dep.dirs.raw_gps, gps_all);
        dep.files.adcp_all  = fullfile(dep.dirs.raw_adcp, adcp_all);
        dep.files.processed = fullfile(Vessels(i).dirs.proc, [dep.name '.mat']);

        %% Add cruise and vessel information
        dep.cruise.name = Vessels(i).cruise;
        dep.vessel.name = Vessels(i).name;

        % Update deployment
        dep.dirs = rmfield(dep.dirs,'raw');
        Vessels(i).deployments(d) = dep;

    end
end

for i = 1:length(Vessels)
    Vessels(i) = post_setup_hook(Vessels(i));
end

