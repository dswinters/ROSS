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
gdep.proc.adcp_load_func = 'adcp_parse';
gdep.proc.adcp_load_args = {'ross','pre'};
gdep.files.gps = 'GPS/*.log';
gdep.files.adcp = 'ADCP/*timestamped*.bin';
gdep.files.imu = 'IMU/*timestamped*.bin';
gdep.proc.nmea = {'GPRMC','HEHDT','PASHR','GPGGA'};

% Deployment-specific options
nd = 1;
deps(nd).dirs.raw = 'ROSS3_deploy_20180523_103154';
deps(nd).name = 'ROSE_0523_1031';

nd = 2;
deps(nd).dirs.raw = 'ROSS3_deploy_20180523_103154A';
deps(nd).name = 'ROSE_0523_1031A';

nd = 3;
deps(nd).dirs.raw = 'ROSS3_deploy_20180523_163854';
deps(nd).name = 'ROSE_0523_1638';

nd = 4;
deps(nd).dirs.raw = 'ROSS3_deploy_20180525_073327';
deps(nd).name = 'ROSE_0525_0733';

nd = 5;
deps(nd).dirs.raw = 'ROSS3_deploy_20180526_121030';
deps(nd).name = 'ROSE_0526_1210';

nd = 6;
deps(nd).dirs.raw = 'ROSS3_deploy_20180526_141431';
deps(nd).name = 'ROSE_0526_1414';

nd = 7;
deps(nd).dirs.raw = 'ROSS3_deploy_20180526_215224';
deps(nd).name = 'ROSE_0526_2152';

nd = 8;
deps(nd).dirs.raw = 'ROSS6_deploy_20180520_165032';
deps(nd).name = 'ROSE_0520_1650';

nd = 9;
deps(nd).dirs.raw = 'ROSS6_deploy_20180521_110827';
deps(nd).name = 'ROSE_0521_1108';

% Fill deployment structure entries with defaults
rose.deployment = fill_defaults(deps,gdep);

