function vessel = config_asiri_2015_aug()

% Vessel info
vessel.name = 'ROSS';
vessel.dirs.raw = fullfile(getenv('DROPBOX'),'ROSS/');
vessel.dirs.proc = '/Volumes/Norgannon/Data/asiri_2015_aug/';
vessel.dirs.figs = '/Volumes/Norgannon/Data/asiri_2015_aug/figures/';

% Initialize deployment info
deployment = [];
dep = 0;

% Deployment info
dep = dep+1;
deployment(dep).name = 'Deploy1';
deployment(dep).dirs.raw = '';
deployment(dep).files.gps = 'Deploy1/gps/Downloaded 8_25_2015/*.TXT';
deployment(dep).files.adcp = 'Deploy1/adcp/raw/*.000';
% deployment(dep).tlim = [];

% Add deployment info to vessel info
vessel.deployment = deployment;
