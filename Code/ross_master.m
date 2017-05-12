function f_out = ross_master(tripname)
f_out = {};

%% Write output to log file?
make_logfile = true;

%% Get information about trip and deployments
addpath(tripname);
fn = [tripname '_deployments'];
[master, deployments] = feval(fn);

%% Global deployment defaults
defaults = struct();
% defaults.proc.adcp_raw2mat = true; % re-parse ADCP data?
% defaults.proc.gps_raw2mat  = true; % re-parse GPS data?

%% Set up directories and filepaths
addpath('figures/');
dirs = struct();
dirs.base = fullfile(getenv('HOME'),'OSU/ROSS/');
dirs.data = fullfile(dirs.base, 'Data/');
dirs.figs = fullfile(dirs.base, 'Figures/');
dirs.maps = fullfile(dirs.base, 'Maps/');
dirs.logs = fullfile(dirs.base, 'org/');

for i = 1:length(master.kayaks)
    Ross(i).name                  = master.kayaks{i};
    Ross(i).master                = rmfield(master,'kayaks');
    Ross(i).deployments           = deployments{i};
    %
    subdir                        = fullfile(master.name, master.kayaks{i}, '/');
    Ross(i).dirs.figs             = fullfile(dirs.figs, subdir);
    rawdir                        = fullfile(dirs.data, subdir, 'raw/');
    Ross(i).dirs.raw.gps          = fullfile(rawdir, 'GPS/');
    Ross(i).dirs.raw.pixhawk      = fullfile(rawdir, 'Pixhawk/');
    Ross(i).dirs.raw.adcp         = fullfile(rawdir, 'ADCP/');
    procdir                       = fullfile(dirs.data, subdir, 'processed/');
    Ross(i).dirs.proc.deployments = fullfile(procdir);
    Ross(i).dirs.proc.pixhawk     = fullfile(procdir, 'Pixhawk/');
    %
    for d = 1:length(Ross(i).deployments)
        Ross(i).deployments(d).files.map = fullfile(...
            dirs.maps,Ross(i).deployments(d).files.map);
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
    % Fill with default options
    Ross(i).deployments = ross_fill_defaults(Ross(i).deployments,defaults);
end

%% Trip-specific setup
switch tripname
  case 'leconte_2016_aug'
    disp('Calibrating 600khz ADCP compass')
    Ross = leconte_2016_aug_calibrate_compass(Ross);
end

%% Process deployments
if master.process_data
    for k = 1:length(master.kayaks)
        % Set up logfile
        if make_logfile
            logfile = fullfile(dirs.logs,...
                               [master.name,...
                                '_' lower(master.kayaks{k}) '.org']);
            eval(['!rm ' logfile])
            diary(logfile);
        end
        disp(sprintf('\n** Deployment Processing: %s ',master.kayaks{k}))
        for ndep = 1:length(Ross(k).deployments)
            disp(sprintf('\n*** Deployment %d: %s', ndep ,...
                         Ross(k).deployments(ndep).name))
            Ross(k) = ross_proc_deployment(Ross(k),ndep);
        end
    end
end
diary off

for i = 1:length(Ross)
    for d = 1:length(Ross(i).deployments)
        if isfield(Ross(i).deployments(d).files,'final')
            f_out{end+1} = Ross(i).deployments(d).files.final;
        end
    end
end

