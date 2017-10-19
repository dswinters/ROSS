function vessel = config_asiri_2015_aug()

% Vessel info
vessel.name = 'ROSS';
vessel.dirs.raw = fullfile(getenv('DROPBOX'),'ROSS/');
vessel.dirs.proc = '/Volumes/Norgannon/Data/asiri_2015_aug/';
vessel.dirs.figs = '/Volumes/Norgannon/Data/asiri_2015_aug/figures/';

% define filters
newfilt =@(n,p) struct('name',n,'params',p);
filt_rotmax  = newfilt('rotmax',5);


% Initialize deployment info
deployment = [];
dep = 0;
defaults.dirs.raw = '';
defaults.proc.nmea = {'GPRMC'};
defaults.proc.filters(1) = filt_rotmax;
% defaults.proc.adcp_raw2mat = true;
defaults.plot.vlim = [1 1 1];
defaults.proc.heading_offset = -136; % beam 3 backward-port
defaults.plot.zlim = [0 60];

% heading offsets
h0 = [-139.5, -135.7, -131.2, -137.7, -136.4, -134.8];

% files & folders
for dep = 1:6
    deployment(dep).name = sprintf('Deploy%d',dep);
    gpsdir = dir(fullfile(vessel.dirs.raw,deployment(dep).name,'gps','Downloaded*'));
    deployment(dep).files.gps  = [deployment(dep).name '/gps/' gpsdir.name '/*.TXT'];
    deployment(dep).files.adcp = [deployment(dep).name '/adcp/raw/*.000'];
    deployment(dep).proc.heading_offset = h0(dep);
end

% time limits
deployment(1).tlim = datenum(['24-Aug-2015 05:40:34'; '25-Aug-2015 05:56:47']);
deployment(2).tlim = datenum(['25-Aug-2015 23:42:56'; '26-Aug-2015 11:30:25']);
deployment(3).tlim = datenum(['05-Sep-2015 03:01:55'; '05-Sep-2015 10:37:15']);
deployment(4).tlim = datenum(['07-Sep-2015 13:43:57'; '08-Sep-2015 08:45:45']);
deployment(5).tlim = datenum(['10-Sep-2015 03:14:03'; '10-Sep-2015 08:22:37']);
deployment(6).tlim = datenum(['14-Sep-2015 04:17:00'; '14-Sep-2015 15:11:59']);

% fill defaults and return
deployment = fill_defaults(deployment,defaults);
% deployment = deployment(4);
vessel.deployment = deployment;