function swankie = petersburg_2017_apr_swankie()
%        FORWARD
%  1   3    ^
%    5      |--> STARBOARD
%  4   2   
swankie0.proc.heading_offset = 45;
swankie0.proc.adcp_load_func = 'adcp_parse';
%--------------------------------------------------------%
dep = 1;
swankie(dep).name       = 'SWANKIE_test1';
swankie(dep).tlim       = datenum([;]);
swankie(dep).files.adcp = {...
    'ADCP_raw_20170416194415.bin';
    'ADCP_raw_20170416200000.bin';
    'ADCP_raw_20170416210000.bin';
    'ADCP_raw_20170416220000.bin'};
swankie(dep).files.gps  = {...
    'GPS_20170416174002.log';
    'GPS_20170416184711.log';
    'GPS_20170416195729.log';
    'GPS_20170416210732.log'};
swankie(dep).tlim = datenum(...
    ['16-Apr-2017 19:47:50';
     '16-Apr-2017 21:53:59']);
%--------------------------------------------------------%
newfilt =@(n,p) struct('name',n,'params',p);
dep = 2;
swankie(dep).name       = 'SWANKIE_Pelican_0419';
swankie(dep).tlim = ...
    datenum(['19-Apr-2017 20:18:47';
             '19-Apr-2017 21:28:32']);
swankie(dep).files.adcp = {...
    'ADCP_raw_20170419200404.bin';
    'ADCP_raw_20170419210000.bin';
    'ADCP_raw_20170419220000.bin';
    'ADCP_raw_20170419220457.bin';
    'ADCP_raw_20170419230000.bin';
    'ADCP_raw_20170420000000.bin';
    'ADCP_raw_20170420010000.bin';
    'ADCP_raw_20170420020000.bin';
    'ADCP_raw_20170420025215.bin';
    'ADCP_raw_20170420025748.bin';
    'ADCP_raw_20170420025932.bin';
    'ADCP_raw_20170420030000.bin';
    'ADCP_raw_20170420030127.bin';
    'ADCP_raw_20170420030312.bin';
    'ADCP_raw_20170420110208.bin'};
swankie(dep).files.gps  = {...
    'GPS_20170419001055.log';
    'GPS_20170419200404.log';
    'GPS_20170419211343.log';
    'GPS_20170419220457.log';
    'GPS_20170419231427.log';
    'GPS_20170420002347.log';
    'GPS_20170420013315.log';
    'GPS_20170420024243.log';
    'GPS_20170420025215.log';
    'GPS_20170420025748.log';
    'GPS_20170420025932.log';
    'GPS_20170420030127.log';
    'GPS_20170420030312.log';
    'GPS_20170420110208.log'};
swankie(dep).plot.ylim = [0 100];
swankie(dep).proc.trim_methods = newfilt('none',[]);
% swankie(dep).proc.trim_methods = newfilt('ei_edge','beam');
swankie(dep).proc.filters(1) = newfilt('rotmax',3);
%--------------------------------------------------------%

swankie = fill_defaults(swankie,swankie0);

