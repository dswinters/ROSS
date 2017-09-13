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
    subdir = fullfile(trip.name, trip.kayaks{i}, '/');
    Ross(i).dirs.figs             = fullfile(dirs.figs, subdir);
    Ross(i).dirs.proc.deployments = fullfile(dirs.data, subdir, 'processed/');
    Ross(i).dirs.raw              = fullfile(dirs.data,subdir,'raw/');
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
        dep.files.map  = fullfile(dirs.maps,dep.files.map);
        dep.files.coastline = fullfile(dirs.maps,dep.files.coastline);
        % Update deployment
        Ross(i).deployments(d) = dep;
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
    disp(sprintf('* Deployment Processing: %s ',trip.kayaks{k}))
    for ndep = 1:length(Ross(k).deployments)
        Ross(k) = ross_proc_deployment(Ross(k),ndep);
    end
end

metadat = struct();
for k = 1:length(Ross)
    metadat.(lower(Ross(k).name)) = Ross(k).deployments;
end
f_out = fullfile(dirs.meta,[tripname '.mat']);
save(f_out,'-struct','metadat')
disp(['Saved ' f_out])

