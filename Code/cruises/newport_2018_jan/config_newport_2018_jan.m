function vessel = config_newport_2018_jan()

vessel.name = 'ROSS3';
dbox = getenv('DROPBOX');
vessel.dirs.raw = fullfile(getenv('HOME'),'Downloads/Data/20180131-Newport/');
vessel.dirs.proc = fullfile(getenv('HOME'),'Downloads/Data/20180131-Newport/Processed/');
vessel.dirs.figs = fullfile(getenv('HOME'),'Downloads/Data/20180131-Newport/Figures/');

defaults.proc.heading_offset      = 45;
defaults.proc.adcp_rotation_func  = 'adcp_beam2earth';
defaults.proc.filters(1)          = struct('name','corrmin','params',255);
defaults.proc.adcp_raw2mat        = true;
defaults.proc.gps_raw2mat         = true;
defaults.proc.adcp_load_func      = 'adcp_parse';
defaults.proc.adcp_load_args      = {'ross','pre'};
defaults.proc.nmea                = {'GPRMC','HEHDT','PASHR','GPGGA'};
defaults.files.gps                = 'GPS/*.log';
defaults.files.adcp               = 'ADCP/*timestamped*.bin';
defaults.plot.make_figure.summary = true;

dep = struct();

dnames = {
    'ROSS3_deploy_20180131_164400';
    'ROSS3_deploy_20180131_170735';
    'ROSS3_deploy_20180131_185000';
    'ROSS3_deploy_20180131_185258';
    'ROSS3_deploy_20180131_191729';
    'ROSS3_deploy_20180131_193421';
    'ROSS3_deploy_20180131_194342';
    'ROSS3_deploy_20180131_194444';
         };

for i = 1:length(dnames)
    dep(i).name = dnames{i};
    dep(i).dirs.raw = dnames{i};
    % dep(i).tlim = datenum([]);
end

vessel.deployment = fill_defaults(dep,defaults);
