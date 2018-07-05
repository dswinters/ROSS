function rose = config_iceland_2018_may()

rose = struct();
rose.name = 'ROSE';

%% ROSE directory configuration
tripdir = '~/Data/gdrive/ROSE/Deployments/201805_Iceland/';
rose.dirs.raw = fullfile(tripdir,'data/');
rose.dirs.proc = fullfile(tripdir,'processed/ADCP/ROSE/');
rose.dirs.figs = fullfile(tripdir,'figures/ADCP/ROSE/');

%% ROSE deployment configuration

% Global deployment options
nd = 0;
gdep.proc.adcp_load_func = 'adcp_parse';
gdep.proc.adcp_load_args = {'ross','pre'};
gdep.proc.adcp_raw2mat = true;

gdep.files.gps = 'GPS/*.log';
gdep.files.adcp = 'ADCP/*timestamped*.bin';
gdep.files.imu = 'IMU/*timestamped*.bin';
gdep.proc.nmea = {'GPRMC','HEHDT','PASHR','GPGGA'};
gdep.proc.heading_offset = 45;
gdep.plot.make_figure.echo_intens = true;
gdep.plot.make_figure.corr = true;


% Deployment-specific options
nd = nd + 1;
deps(nd).dirs.raw = 'ROSS3_deploy_20180523_103154';
deps(nd).name = 'ROSE_0523_1031';
deps(nd).tlim = datenum(['23-May-2018 10:28:42'; '23-May-2018 14:35:19']);

% nd = nd + 1;
% deps(nd).dirs.raw = 'ROSS3_deploy_20180523_103154A';
% deps(nd).name = 'ROSE_0523_1031A';

nd = nd + 1;
deps(nd).dirs.raw = 'ROSS3_deploy_20180523_163854';
deps(nd).name = 'ROSE_0523_1638';
deps(nd).tlim = datenum(['23-May-2018 16:45:13'; '23-May-2018 18:41:03']);


nd = nd + 1;
deps(nd).dirs.raw = 'ROSS3_deploy_20180525_073327';
deps(nd).name = 'ROSE_0525_0733';
deps(nd).tlim = datenum(['25-May-2018 07:35:01'; '25-May-2018 13:51:45']);

nd = nd + 1;
deps(nd).dirs.raw = 'ROSS3_deploy_20180526_121030';
deps(nd).name = 'ROSE_0526_1210';
deps(nd).tlim = datenum(['26-May-2018 12:28:07'; '26-May-2018 12:48:32']);

nd = nd + 1;
deps(nd).dirs.raw = 'ROSS3_deploy_20180526_141431';
deps(nd).name = 'ROSE_0526_1414';
deps(nd).tlim = datenum(['26-May-2018 14:26:46'; '26-May-2018 17:18:33']);

nd = nd + 1;
deps(nd).dirs.raw = 'ROSS3_deploy_20180526_215224';
deps(nd).name = 'ROSE_0526_2152';
deps(nd).tlim = datenum(['26-May-2018 22:02:51'; '27-May-2018 00:15:43']);

nd = nd + 1;
deps(nd).dirs.raw = 'ROSS6_deploy_20180520_165032';
deps(nd).name = 'ROSE_0520_1650';
deps(nd).tlim = datenum(['20-May-2018 17:01:26'; '20-May-2018 18:09:28']);

% % I think there's an errant timestamp in this one
% nd = nd + 1;
% deps(nd).dirs.raw = 'ROSS6_deploy_20180521_110827';
% deps(nd).name = 'ROSE_0521_1108';
% deps(nd).tlim = datenum(['04-Jun-0008 03:03:28'; '08-Apr-2018 01:11:00']);

% Fill deployment structure entries with defaults
rose.deployment = fill_defaults(deps,gdep);

