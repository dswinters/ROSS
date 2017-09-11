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
    Ross(i).name                  = trip.kayaks{i};
    Ross(i).trip                  = trip.name;
    Ross(i).deployments           = deployments{i};
    %
    subdir                        = fullfile(trip.name, trip.kayaks{i}, '/');
    Ross(i).dirs.figs             = fullfile(dirs.figs, subdir);

    if isfield(Ross(i).deployments,'dir_raw')
        rawdir = fullfile(dirs.data, subdir, 'raw', Ross(i).deployments.dir_raw); 
        Ross(i).dirs.raw.gps = fullfile(rawdir,'GPS/');
        Ross(i).dirs.raw.adcp = fullfile(rawdir, 'ADCP/');
        Ross(i).dirs.proc.deployments = fullfile(dirs.data, subdir, 'processed/');
        for d = 1:length(Ross(i).deployments)
            dep = Ross(i).deployments(d);
            files = dir([Ross(i).dirs.raw.gps,dep.files.gps]);
            Ross(i).deployments(d).files.gps = strcat(Ross(i).dirs.raw.gps,{files.name});
            files = dir([Ross(i).dirs.raw.adcp,dep.files.adcp]);
            Ross(i).deployments(d).files.adcp = strcat(Ross(i).dirs.raw.adcp,{files.name});
        end
    else
        rawdir                        = fullfile(dirs.data, subdir, 'raw/');
        Ross(i).dirs.raw.gps          = fullfile(rawdir, 'GPS/');
        Ross(i).dirs.raw.pixhawk      = fullfile(rawdir, 'Pixhawk/');
        Ross(i).dirs.raw.adcp         = fullfile(rawdir, 'ADCP/');
        procdir                       = fullfile(dirs.data, subdir, 'processed/');
        Ross(i).dirs.proc.deployments = fullfile(procdir);
        Ross(i).dirs.proc.pixhawk     = fullfile(procdir, 'Pixhawk/');
        %
        % Fill with default options
        Ross(i).deployments = ross_fill_defaults(...
            Ross(i).deployments,...
            ross_defaults());
        for d = 1:length(Ross(i).deployments)
            Ross(i).deployments(d).files.map = fullfile(...
                dirs.maps,Ross(i).deployments(d).files.map);
            
            % Check whether an ADCP directory was given instead of a list of files
            if isdir([Ross(i).dirs.raw.adcp ...
                      Ross(i).deployments(d).files.adcp{1}])
                files = dir(fullfile(...
                    Ross(i).dirs.raw.adcp,...
                    Ross(i).deployments(d).files.adcp{1},...
                    ['*' Ross(i).deployments(d).files.adcp{2} '*']));
                Ross(i).deployments(d).files.adcp = fullfile(...
                    Ross(i).deployments(d).files.adcp{1},...
                    {files.name});
            end
            Ross(i).deployments(d).files.adcp = ...
                fullfile(Ross(i).dirs.raw.adcp ,...
                         Ross(i).deployments(d).files.adcp);

            % Check whether a GPS directory was given instead of a list of files
            if isdir([Ross(i).dirs.raw.gps ...
                      Ross(i).deployments(d).files.gps{1}])
                files = dir(fullfile(...
                    Ross(i).dirs.raw.gps,...
                    Ross(i).deployments(d).files.gps{1},...
                    'GPS_*'));
                Ross(i).deployments(d).files.gps = fullfile(...
                    Ross(i).deployments(d).files.gps{1},...
                    {files.name});
            end
            Ross(i).deployments(d).files.gps = ...
                fullfile(Ross(i).dirs.raw.gps ,...
                         Ross(i).deployments(d).files.gps);
        end
    end
    % Fill default options
    Ross(i).deployments = ross_fill_defaults(Ross(i).deployments,ross_defaults());
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
        disp(sprintf('\n*** Deployment %d: %s', ndep ,...
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


