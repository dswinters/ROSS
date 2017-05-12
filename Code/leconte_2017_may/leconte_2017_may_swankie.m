function swankie = leconte_2017_may_swankie()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  1   3    ^
%    5      |--> STARBOARD
%  4   2   

%--------------------------------------------------------%
% Default deployment options                             %
%--------------------------------------------------------%
swankie0.proc.heading_offset = 45;
swankie0.proc.adcp_load_function = 'adcp_parse';
swankie0.proc.skip = false;
swankie0.tlim = [-inf inf];
swankie0.proc.ross_timestamps = 'pre';

%--------------------------------------------------------%
% Define some filters                                    %
%--------------------------------------------------------%
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
trim_corr_edge_b = newfilt('corr_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);


%--------------------------------------------------------%
% "Deployment" 1: Petersburg dock shallow transects      %
%--------------------------------------------------------%
dep = 1;
swankie(dep).proc.skip = true;
swankie(dep).name       = 'dock_transects_20170503';
swankie(dep).tlim       = [-inf inf];
swankie(dep).files.adcp = {...
    'ADCP_timestamped_20170503050911.bin';
    'ADCP_timestamped_20170503210616.bin';
    'ADCP_timestamped_20170503220000.bin';
    'ADCP_timestamped_20170503235237.bin';
    'ADCP_timestamped_20170504003107.bin';
    'ADCP_timestamped_20170504010000.bin';
    'ADCP_timestamped_20170504013814.bin';
    'ADCP_timestamped_20170504020000.bin';
    'ADCP_timestamped_20170504024831.bin';
    'ADCP_timestamped_20170504030000.bin';
    'ADCP_timestamped_20170504034734.bin';
                   };
swankie(dep).files.gps = {...
    'GPS_20170503050911.log';
    'GPS_20170503210616.log';
    'GPS_20170503221549.log';
    'GPS_20170503235237.log';
    'GPS_20170504003107.log';
    'GPS_20170504013814.log';
    'GPS_20170504024747.log';
    'GPS_20170504024831.log';
    'GPS_20170504034734.log';
                   };
swankie(dep).plot.ylim = [0 20];

%--------------------------------------------------------%
% "Deployment" 2: Looks like ADCP was out of water       %
%--------------------------------------------------------%
dep = 2;
swankie(dep).proc.skip = true;
swankie(dep).name = 'swankie_deployment_201705081400';
swankie(dep).files.adcp = {...
    'deployment_201705081400';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705081400'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';

%--------------------------------------------------------%
%                    Deployment 3                        %
%--------------------------------------------------------%
dep = 3;
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
%                    Deployment 4                        %
%--------------------------------------------------------%
dep = 4;
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
%                    Deployment 5                        %
%--------------------------------------------------------%
dep = 5;
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
%                    Deployment 6                        %
%--------------------------------------------------------%
dep = 6;
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
% swankie(dep).proc.filters(1).name = 'velmax';
% swankie(dep).proc.filters(1).params = 0.6;


%--------------------------------------------------------%
%                    Deployment 7                        %
%--------------------------------------------------------%
dep = 7;
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
% swankie(dep).proc.filters(1).name = 'velmax';
% swankie(dep).proc.filters(1).params = 0.6;

%--------------------------------------------------------%
%                    Deployment 8                        %
%--------------------------------------------------------%
dep = 8;
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

%--------------------------------------------------------%
%                    Deployment 9                        %
%--------------------------------------------------------%
dep = 9;
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

%--------------------------------------------------------%
%                    Deployment 10   (trash)             %
%--------------------------------------------------------%
dep = 10;
swankie(dep).proc.skip = true;
swankie(dep).name = 'swankie_deployment_201705111840';
swankie(dep).files.adcp = {...
    'deployment_201705111840';
    'timestamped'};
swankie(dep).files.gps = {'deployment_201705111840'};
swankie(dep).plot.ylim = [0 200];
swankie(dep).files.map = 'leconte_terminus';

%--------------------------------------------------------%
%                    Deployment 11                       %
%--------------------------------------------------------%
dep = 10;
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





swankie = ross_fill_defaults(swankie,swankie0);

