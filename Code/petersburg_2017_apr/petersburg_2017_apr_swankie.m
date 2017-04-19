function swankie = petersburg_2017_apr_swankie()
%        FORWARD
%  1   3    ^
%    5      |--> STARBOARD
%  4   2   
swankie0.proc.heading_offset = 45;
swankie0.proc.adcp_load_function = 'adcp_parse';
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
swankie = ross_fill_defaults(swankie,swankie0);

% % return
% dir_in = '~/OSU/ROSS/Data/petersburg_2017_apr/Swankie/raw/ADCP/';
% adcp = adcp_parse(strcat(dir_in,swankie(1).files.adcp));
% save ~/Desktop/swankie_psg_test_adcp.mat adcp


% dir_in = '~/OSU/ROSS/Data/petersburg_2017_apr/Swankie/raw/GPS/';
% nmea_types = {'GPRMC','HEHDT','HEROT','GPGGA','GPRMC','PASHR'};
% nav = nav_read(strcat(dir_in,swankie(1).files.gps),nmea_types);

% a(1) = adcp_beam2earth(adcp(1));
% a(2) = adcp_beam2earth(adcp(2));
















