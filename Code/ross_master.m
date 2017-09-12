function ross_master(tripname)
f_out = {};

%% Write output to log file?
make_logfile = true;

%% Get information about trip and deployments
addpath(tripname);
fn = [tripname '_deployments'];
[trip, deployments] = feval(fn);

%% Set up directories and filepaths
addpath('figures/');
dirs = struct();
dirs.base = fullfile(getenv('HOME'),'OSU/ROSS/');
dirs.data = fullfile(dirs.base, 'Data/');
dirs.figs = fullfile(dirs.base, 'Figures/');
dirs.maps = fullfile(dirs.base, 'Maps/');
dirs.logs = fullfile(dirs.base, 'org/');
dirs.meta = fullfile(dirs.base, 'Metadata/');

for i = 1:length(trip.kayaks)
    Ross(i).name        = trip.kayaks{i};
    Ross(i).trip        = trip.name;
    Ross(i).deployments = deployments{i};
    %
    subdir              = fullfile(trip.name, trip.kayaks{i}, '/');
    Ross(i).dirs.figs   = fullfile(dirs.figs, subdir);

    % By default, look for data in:
    %
    % ADCP: ROSS/Data/<TRIP>/<KAYAK>/raw/<DIR_RAW>/ADCP/
    % GPS: ROSS/Data/<TRIP>/<KAYAK>/raw/<DIR_RAW>/GPS/
    %
    % The string provided in the deployment's "files.gps" and "files.adcp"
    % fields are used as matching criteria for MATLAB's "dir" function within
    % these folders. If raw data are not organized in this way, use a
    % trip-specific file finding function.
    if exist(fullfile(dirs.base,'Code',trip.name,[trip.name '_find_files.m']),'file') == 2
        % TODO: implement this
    else
        Ross(i).dirs.proc.deployments = fullfile(dirs.data, subdir, 'processed/');
        Ross(i).dirs.raw = fullfile(dirs.data,subdir,'raw/');
        for d = 1:length(Ross(i).deployments)
            dep = Ross(i).deployments(d);
            dep.dirs.raw_gps  = ...
                fullfile(Ross(i).dirs.raw, dep.dirs.raw, 'GPS/');
            dep.dirs.raw_adcp = ...
                fullfile(Ross(i).dirs.raw, dep.dirs.raw, 'ADCP/');
            % GPS files
            files = dir([dep.dirs.raw_gps, dep.files.gps]);
            dep.files.gps = strcat(dep.dirs.raw_gps, {files.name});
            % ADCP files
            files = dir([dep.dirs.raw_adcp, dep.files.adcp]);
            dep.files.adcp = strcat(dep.dirs.raw_adcp, {files.name});
            % Map file
            dep.files.map = fullfile(dirs.maps,dep.files.map);
            % update deployment structure
            Ross(i).deployments(d) = dep;
        end
        % Fill default options
        Ross(i).deployments = ross_fill_defaults(Ross(i).deployments,ross_defaults());
    end
end

%% Trip-specific setup
switch tripname
  case 'leconte_2016_aug'
    disp('Calibrating 600khz ADCP compass')
    Ross = leconte_2016_aug_calibrate_compass(Ross);
end

%% Process deployments
for k = 1:length(trip.kayaks)
    % Set up logfile
    if make_logfile
        logfile = fullfile(dirs.logs, [trip.name,'_',lower(trip.kayaks{k}),'.org']);
        eval(['!rm ' logfile])
        diary(logfile);
    end
    disp(sprintf('\n** Deployment Processing: %s ',trip.kayaks{k}))
    for ndep = 1:length(Ross(k).deployments)
        disp(sprintf('\n*** %n) %s', ndep ,...
                     Ross(k).deployments(ndep).name))
        Ross(k) = ross_proc_deployment(Ross(k),ndep);
    end
end
diary off

metadat = struct();
for k = 1:length(Ross)
    metadat.(lower(Ross(k).name)) = Ross(k).deployments;
end
f_out = fullfile(dirs.meta,[tripname '.mat']);
save(f_out,'-struct','metadat')
disp(['Saved ' f_out])


