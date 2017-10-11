function vessel = config_asiri_2015_aug()

% Vessel info
vessel.name = 'ROSS';
vessel.dirs.raw = fullfile(getenv('DROPBOX'),'ROSS/');
vessel.dirs.proc = '/Volumes/Norgannon/Data/asiri_2015_aug/';
vessel.dirs.figs = '/Volumes/Norgannon/Data/asiri_2015_aug/figures/';

% Initialize deployment info
deployment = [];
dep = 0;
defaults.dirs.raw = '';
defaults.proc.nmea = {'GPRMC'};
defaults.proc.gps_raw2mat = true;

for dep = 1:6
    deployment(dep).name = sprintf('Deploy%d',dep);
    gpsdir = dir(fullfile(vessel.dirs.raw,deployment(dep).name,'gps','Downloaded*'));
    deployment(dep).files.gps  = [deployment(dep).name '/gps/' gpsdir.name '/*.TXT'];
    deployment(dep).files.adcp = [deployment(dep).name '/adcp/raw/*.000'];
end

deployment = fill_defaults(deployment,defaults);

% Add deployment info to vessel info
vessel.deployment = deployment;
