function swankie = leconte_2017_may_swankie()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  1   3    ^
%    5      |--> STARBOARD
%  4   2   
dep = 0;

%--------------------------------------------------------%
% Default deployment options                             %
%--------------------------------------------------------%
swankie0.proc.heading_offset = 45;
swankie0.proc.adcp_load_function = 'adcp_parse';
swankie0.tlim = [-inf inf];
swankie0.proc.ross_timestamps = 'pre';
% swankie0.proc.skip = false;

%--------------------------------------------------------%
% Define some filters                                    %
%--------------------------------------------------------%
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
trim_corr_edge_b = newfilt('corr_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);
swankie0.proc.trim_methods(1) = trim_ei_edge_b;


%--------------------------------------------------------%
% Deployments                                            %
%--------------------------------------------------------%

% Petersburg dock shallow transects
% Too shallow, not much to see here...
dep = dep+1;
swankie(dep).proc.skip = true;
swankie(dep).name       = 'swankie_dock_transects_20170503';
swankie(dep).tlim       = [-inf inf];
swankie(dep).files.adcp = {...
    'dock_transects_20170503';
    'timestamped'};
swankie(dep).files.gps = {'dock_transects_20170503'};
swankie(dep).plot.ylim = [0 20];

%--------------------------------------------------------%
% Looks like ADCP was out of water
dep = dep+1;
swankie(dep).proc.skip = true;
swankie(dep).name = 'swankie_deployment_201705081400';
swankie(dep).files.adcp = {...
    'deployment_201705081400';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705081400'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705091345';
swankie(dep).tlim       = datenum([...
    2017 05 09 13 40 00;
    2017 05 09 14 20 00]);
swankie(dep).files.adcp = {...
    'deployment_201705091345';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705091345'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705091550';
swankie(dep).tlim       = datenum([...
    2017 05 09 15 50 00;
    2017 05 09 16 30 00]);
swankie(dep).files.adcp = {...
    'deployment_201705091550';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705091550'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705091830';
swankie(dep).tlim       = datenum([...
    2017 05 09 18 30 00;
    2017 05 09 19 38 00]);
swankie(dep).files.adcp = {...
    'deployment_201705091830';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705091830'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';
swankie(dep).proc.filters(1).name = 'velmax';
swankie(dep).proc.filters(1).params = 0.6;

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705101700';
swankie(dep).tlim       = datenum([...
    2017 05 10 16 18 00;
    2017 05 10 17 10 00]);
swankie(dep).files.adcp = {...
    'deployment_201705101700';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705101700'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705102100';
swankie(dep).tlim       = datenum([...
    2017 05 10 20 57 00;
    2017 05 10 21 37 00]);
swankie(dep).files.adcp = {...
    'deployment_201705102100';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705102100'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705102200';
swankie(dep).tlim       = datenum([...
    2017 05 10 22 03 00;
    2017 05 10 22 55 00]);
swankie(dep).files.adcp = {...
    'deployment_201705102200';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705102200'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';
swankie(dep).proc.adcp_raw2mat = true;
% Sections
secs = datenum(['10-May-2017 22:22:44';
                '10-May-2017 22:32:47']);
namefmt = 'swankie_section_201705102200_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705111800';
swankie(dep).tlim       = datenum([...
    2017 05 11 18 02 00;
    2017 05 11 18 22 00]);
swankie(dep).files.adcp = {...
    'deployment_201705111800';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705111800'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';
% Sections
secs = datenum([...
    '11-May-2017 18:04:42';
    '11-May-2017 18:05:34';
    '11-May-2017 18:05:39';
    '11-May-2017 18:06:10';
    '11-May-2017 18:06:19';
    '11-May-2017 18:07:13';
    '11-May-2017 18:08:13';
    '11-May-2017 18:09:43';
    '11-May-2017 18:10:37';
    '11-May-2017 18:11:22']);
namefmt = 'swankie_section_201705111800_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);

%--------------------------------------------------------%
% very short, out of water?
dep = dep+1;
swankie(dep).proc.skip = true;
swankie(dep).name = 'swankie_deployment_201705111840';
swankie(dep).files.adcp = {...
    'deployment_201705111840';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705111840'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705112250';
swankie(dep).tlim       = datenum([...
    2017 05 11 22 52 00;
    2017 05 11 23 58 00]);
swankie(dep).files.adcp = {...
    'deployment_201705112250';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705112250'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';
% Sections
secs = datenum([...
    '11-May-2017 23:17:45';
    '11-May-2017 23:21:20';
    '11-May-2017 23:23:25';
    '11-May-2017 23:25:11';
    '11-May-2017 23:26:02';
    '11-May-2017 23:30:28';
    '11-May-2017 23:30:32';
    '11-May-2017 23:32:25';
    '11-May-2017 23:32:57';
    '11-May-2017 23:35:37';
    '11-May-2017 23:36:59';
    '11-May-2017 23:38:17';
    '11-May-2017 23:38:53';
    '11-May-2017 23:41:33']);
namefmt = 'swankie_section_201705112250_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705120000';
% swankie(dep).tlim       = datenum([...
%     2017 05 11 22 52 00;
%     2017 05 11 23 58 00]);
swankie(dep).files.adcp = {...
    'deployment_201705120000';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705120000'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';
% Sections
secs = datenum([...
    '12-May-2017 00:31:50';
    '12-May-2017 00:34:15';
    '12-May-2017 00:34:20';
    '12-May-2017 00:36:25';
    '12-May-2017 00:37:22';
    '12-May-2017 00:40:55';
    '12-May-2017 00:44:13';
    '12-May-2017 00:46:59']);
namefmt = 'swankie_section_201705120000_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705121830';
swankie(dep).tlim = datenum([...
    '12-May-2017 18:31:24';
    '12-May-2017 19:41:36']);
swankie(dep).files.adcp = {...
    'deployment_201705121830';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705121830'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';
swankie(dep).proc.trim_methods(1) = notrim;
% Sections
secs = datenum([...
    '12-May-2017 18:34:45';
    '12-May-2017 18:43:00';
    '12-May-2017 18:43:08';
    '12-May-2017 18:50:50';
    '12-May-2017 18:51:46';
    '12-May-2017 18:56:50';
    '12-May-2017 19:00:25';
    '12-May-2017 19:15:19';
    '12-May-2017 19:15:51';
    '12-May-2017 19:29:49']);
namefmt = 'swankie_section_201705121830_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);
%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705132100';
swankie(dep).tlim = datenum([...
    '13-May-2017 21:06:00';
    '13-May-2017 22:15:00']);
swankie(dep).files.adcp = {...
    'deployment_201705132100';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705132100'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';
swankie(dep).plot.vlim = [1 1 0.25];
swankie(dep).proc.skip = false;
%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705131810';
swankie(dep).tlim = datenum([...
    '13-May-2017 18:13:00';
    '13-May-2017 19:30:00']);
swankie(dep).files.adcp = {...
    'deployment_201705131810';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705131810'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'none';
swankie(dep).plot.vlim = [0.5 0.5 0.25];
swankie(dep).proc.skip = false;
%--------------------------------------------------------%
% Fill defaults                                          %
%--------------------------------------------------------%
swankie = ross_fill_defaults(swankie,swankie0);
