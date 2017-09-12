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
swankie0.files.map = 'none';
swankie0.proc.skip = true;

%--------------------------------------------------------%
% Define some filters                                    %
%--------------------------------------------------------%
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
trim_corr_edge_b = newfilt('corr_edge','beam');
trim_bt90 = newfilt('BT',90);
trim_bt50 = newfilt('BT',50);
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);
swankie0.proc.trim_methods(1) = trim_bt90;


%--------------------------------------------------------%
% Deployments                                            %
%--------------------------------------------------------%

% Petersburg dock shallow transects
% Too shallow, not much to see here...
dep = dep+1;
swankie(dep).proc.skip = true; % SKIP ALWAYS
swankie(dep).name       = 'swankie_dock_transects_20170503';
swankie(dep).tlim       = [-inf inf];
swankie(dep).dir_raw = 'dock_transects_20170503';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 20];

%--------------------------------------------------------%
% Looks like ADCP was out of water
dep = dep+1;
swankie(dep).proc.skip = true; % SKIP ALWAYS
swankie(dep).name = 'swankie_deployment_201705081400';
swankie(dep).dir_raw = 'deployment_201705081400';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705091345';
swankie(dep).tlim       = datenum([...
    '09-May-2017 13:43:22';
    '09-May-2017 14:16:08']);
swankie(dep).dir_raw = 'deployment_201705091345';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705091550';
swankie(dep).tlim       = datenum([...
    '09-May-2017 15:51:31';
    '09-May-2017 16:30:00']);
swankie(dep).dir_raw = 'deployment_201705091550';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705091830';
swankie(dep).tlim       = datenum([...
    '09-May-2017 18:30:29';
    '09-May-2017 19:37:19']);
swankie(dep).dir_raw = 'deployment_201705091830';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
swankie(dep).proc.filters(1).name = 'velmax';
swankie(dep).proc.filters(1).params = 0.6;

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705101700';
swankie(dep).tlim       = datenum([...
    2017 05 10 16 18 00;
    2017 05 10 17 10 00]);
swankie(dep).dir_raw = 'deployment_201705101700';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705102100';
swankie(dep).tlim       = datenum([...
    '10-May-2017 20:57:00';
    '10-May-2017 21:37:04']);
swankie(dep).dir_raw = 'deployment_201705102100';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705102200';
% swankie(dep).tlim       = datenum([... % actual deployment tlim
%     2017 05 10 22 03 00;
%     2017 05 10 22 55 00]);
swankie(dep).tlim       = datenum([... % temp deployment tlim
    2017 05 10 22 10 00;
    2017 05 10 22 35 00]);
swankie(dep).dir_raw = 'deployment_201705102200';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
swankie(dep).proc.skip = false;
swankie(dep).proc.filters(1) = newfilt('none',nan);
% swankie(dep).proc.trim_methods(1) = trim_bt50;
% % Sections
% secs = datenum(['10-May-2017 22:22:44';
%                 '10-May-2017 22:32:47']);
% namefmt = 'swankie_section_201705102200_%02d';
% [swankie dep] = ross_deployment_sections(...
%     swankie,dep,secs,namefmt);

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705111800';
swankie(dep).tlim       = datenum([...
    2017 05 11 18 02 00;
    2017 05 11 18 22 00]);
swankie(dep).dir_raw = 'deployment_201705111800';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
% Sections
secs = datenum([...
    '11-May-2017 18:04:42'; '11-May-2017 18:05:34';
    '11-May-2017 18:05:39'; '11-May-2017 18:06:10';
    '11-May-2017 18:06:19'; '11-May-2017 18:07:13';
    '11-May-2017 18:08:13'; '11-May-2017 18:09:43';
    '11-May-2017 18:10:37'; '11-May-2017 18:11:22']);
namefmt = 'swankie_section_201705111800_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);

%--------------------------------------------------------%
% very short, out of water?
dep = dep+1;
swankie(dep).proc.skip = true; % SKIP ALWAYS
swankie(dep).name = 'swankie_deployment_201705111840';
swankie(dep).dir_raw = 'deployment_201705111840';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705112250';
swankie(dep).tlim       = datenum([...
    2017 05 11 22 52 00;
    2017 05 11 23 58 00]);
swankie(dep).dir_raw = 'deployment_201705112250';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
% Sections
secs = datenum([...
    '11-May-2017 23:17:45'; '11-May-2017 23:21:20';
    '11-May-2017 23:23:25'; '11-May-2017 23:25:11';
    '11-May-2017 23:26:02'; '11-May-2017 23:30:28';
    '11-May-2017 23:30:32'; '11-May-2017 23:32:25';
    '11-May-2017 23:32:57'; '11-May-2017 23:35:37';
    '11-May-2017 23:36:59'; '11-May-2017 23:38:17';
    '11-May-2017 23:38:53'; '11-May-2017 23:41:33']);
namefmt = 'swankie_section_201705112250_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705120000';
swankie(dep).tlim = datenum([...
    '12-May-2017 00:25:02';
    '12-May-2017 01:07:34']);
swankie(dep).dir_raw = 'deployment_201705120000';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
% Sections
secs = datenum([...
    '12-May-2017 00:31:50'; '12-May-2017 00:34:15';
    '12-May-2017 00:34:20'; '12-May-2017 00:36:25';
    '12-May-2017 00:37:22'; '12-May-2017 00:40:55';
    '12-May-2017 00:44:13'; '12-May-2017 00:46:59']);
namefmt = 'swankie_section_201705120000_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705121830';
swankie(dep).tlim = datenum([...
    '12-May-2017 18:31:24';
    '12-May-2017 19:41:36']);
swankie(dep).dir_raw = 'deployment_201705121830';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
swankie(dep).proc.bad = ...
    {datenum(['12-May-2017 19:26:52';
             '12-May-2017 19:27:18'])};

% Sections
secs = datenum([...
    '12-May-2017 18:34:45'; '12-May-2017 18:43:00';
    '12-May-2017 18:43:08'; '12-May-2017 18:50:50';
    '12-May-2017 18:51:46'; '12-May-2017 18:56:50';
    '12-May-2017 19:00:25'; '12-May-2017 19:15:19';
    '12-May-2017 19:15:51'; '12-May-2017 19:29:49']);
namefmt = 'swankie_section_201705121830_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);
%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705132100';
swankie(dep).tlim = datenum([...
    '13-May-2017 21:06:00';
    '13-May-2017 22:15:00']);
swankie(dep).dir_raw = 'deployment_201705132100';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'none';
swankie(dep).plot.vlim = [1 1 0.25];
swankie(dep).plot.ylim = [0 60];
swankie(dep).proc.filters(1) = filt_rotmax3;
% Sections
secs = datenum(...
    ['13-May-2017 21:07:24'; '13-May-2017 21:10:35';
     '13-May-2017 21:10:39'; '13-May-2017 21:13:03';
     '13-May-2017 21:13:13'; '13-May-2017 21:16:18';
     '13-May-2017 21:17:51'; '13-May-2017 21:19:15';
     '13-May-2017 21:19:34'; '13-May-2017 21:23:07';
     '13-May-2017 21:25:31'; '13-May-2017 21:30:47';
     '13-May-2017 21:30:47'; '13-May-2017 21:33:58';
     '13-May-2017 21:34:07'; '13-May-2017 21:40:23';
     '13-May-2017 21:47:35'; '13-May-2017 21:49:31';
     '13-May-2017 21:49:36'; '13-May-2017 21:54:29';
     '13-May-2017 21:56:15'; '13-May-2017 22:01:54';
     '13-May-2017 22:03:37'; '13-May-2017 22:11:07';
     '13-May-2017 22:11:17'; '13-May-2017 22:14:55']);
namefmt = 'swankie_section_201705132100_%02d';
[swankie dep] = ross_deployment_sections(...
    swankie,dep,secs,namefmt);
nsecs = length(secs)/2;
for i = 1:(length(secs))/2
    swankie(end-i+1).plot.map.nx = 25;
    swankie(end-i+1).plot.map.ny = 25;
end
%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705131810';
swankie(dep).tlim = datenum([...
    '13-May-2017 18:13:00';
    '13-May-2017 19:30:00']);
swankie(dep).dir_raw = 'deployment_201705131810';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'none';
swankie(dep).plot.vlim = [0.5 0.5 0.25];
%--------------------------------------------------------%
% T-Chain
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705141300';
swankie(dep).tlim = datenum([...
    '14-May-2017 12:58:46';
    '14-May-2017 14:59:44']);
swankie(dep).dir_raw = 'deployment_201705141300';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'none';
swankie(dep).plot.vlim = [0.5 0.5 0.25];
swankie(dep).plot.ylim = [0 100];
% swankie(dep).proc.skip = false;
% swankie(dep).plot.make_figure.all = true;
%--------------------------------------------------------%
% T-Chain
dep = dep+1;
swankie(dep).name = 'swankie_deployment_201705141620';
swankie(dep).tlim = datenum([...
    '14-May-2017 16:28:00';
    '14-May-2017 18:40:02']);
swankie(dep).dir_raw = 'deployment_201705141620';
swankie(dep).files.adcp = '*timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'none';
swankie(dep).plot.vlim = [0.5 0.5 0.25];
swankie(dep).plot.ylim = [0 100];
% swankie(dep).proc.skip = false;
% swankie(dep).plot.make_figure.all = true;

%--------------------------------------------------------%
% Fill defaults                                          %
%--------------------------------------------------------%
swankie = ross_fill_defaults(swankie,swankie0);

