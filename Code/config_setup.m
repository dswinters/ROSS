function Vessels = config_setup(cruise_name,varargin)

% Ensure that necessary directories are in MATLAB's search path
addpath('figures/'); % add figure functions to path
addpath('misc/');    % misc helper functions
addpath('hooks/');   % hooks

Vessels = config_cruise(cruise_name,varargin{:}); % Cruise configuration

for i = 1:length(Vessels)

    % Fill default options
    if ~isempty(Vessels(i).deployment)
        Vessels(i).deployment = fill_defaults(Vessels(i).deployment,config_defaults());
    end

    % Set up deployments
    for d = 1:length(Vessels(i).deployment)
        dep = Vessels(i).deployment(d);

        %% Add cruise and vessel info into deployment structure
        if ~isfield(Vessels(i).deployment,'cruise')
            [Vessels(i).deployment.cruise] = deal(struct());
        end
        if ~isfield(Vessels(i).deployment,'vessel')
            [Vessels(i).deployment.vessel] = deal(struct());
        end
        dep.cruise.name = Vessels(i).cruise;
        dep.vessel.name = Vessels(i).name;
        dep.vessel.dirs.raw  = Vessels(i).dirs.raw;
        dep.vessel.dirs.proc = Vessels(i).dirs.proc;

        %% Make full directories
        dir_raw     = fullfile(Vessels(i).dirs.raw, dep.dirs.raw, '/');
        gps_files   = dir(fullfile(dir_raw, dep.files.gps));
        adcp_files  = dir(fullfile(dir_raw, dep.files.adcp));
        %
        dep.dirs.raw_gps  = fullfile(dir_raw, [fileparts(dep.files.gps) '/']);
        dep.dirs.raw_adcp = fullfile(dir_raw, [fileparts(dep.files.adcp) '/']);
        dep.dirs.figs     = fullfile(Vessels(i).dirs.figs, dep.name, '/');

        %% Make full file paths
        dep.files.gps       = fullfile(dep.dirs.raw_gps, {gps_files.name});
        dep.files.adcp      = fullfile(dep.dirs.raw_adcp, {adcp_files.name});
        dep.files.gps_mat   = fullfile(dep.dirs.raw_gps, [dep.name '_gps.mat']);
        dep.files.adcp_mat  = fullfile(dep.dirs.raw_adcp, [dep.name '_adcp.mat']);
        dep.files.processed = fullfile(Vessels(i).dirs.proc, [dep.name '.mat']);

        %% Check for kayak log files
        if isfield(dep.files,'logs') && ~isempty(dep.files.logs)
            log_files = dir(fullfile(dir_raw, dep.files.logs));
            dep.files.logs = fullfile({log_files.folder},{log_files.name});
        end

        %% Full-deployment files
        % Create these if the deployment name ends with the name of the
        % subfolder containing the deployment's raw data. If any later
        % deployments (e.g. specific sections) use the same raw data subfolder,
        % these will be loaded.
        dep.files.gps_all   = fullfile(dep.dirs.raw_gps,'gps_all.mat');
        dep.files.adcp_all  = fullfile(dep.dirs.raw_adcp,'adcp_all.mat');
        [~,dirname] = fileparts(fileparts(dir_raw));
        if endsWith(dep.name,dirname)
            dep.files.gps_mat = dep.files.gps_all;
            dep.files.adcp_mat = dep.files.adcp_all;
        end

        % Update deployment
        Vessels(i).deployment(d) = dep;
    end
    Vessels(i) = post_setup_hook(Vessels(i));
end

% Remove dirs and cruise fields
Vessels = rmfield(Vessels,{'dirs','cruise'});
