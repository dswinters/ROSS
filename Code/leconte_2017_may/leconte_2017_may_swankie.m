function swankie = leconte_2017_may_swankie()
%        FORWARD
%  1   3    ^
%    5      |--> STARBOARD
%  4   2   
swankie0.proc.heading_offset = 45;
swankie0.proc.adcp_load_function = 'adcp_parse';
%--------------------------------------------------------%
dep = 1;
swankie(dep).name       = 'dock_transects_20170503';
swankie(dep).tlim       = [-inf inf];
swankie(dep).files.adcp = {...
    'ADCP_raw_20170503050911.bin';
    'ADCP_raw_20170503210616.bin';
    'ADCP_raw_20170503220000.bin';
    'ADCP_raw_20170503235237.bin';
    'ADCP_raw_20170504003107.bin';
    'ADCP_raw_20170504010000.bin';
    'ADCP_raw_20170504013814.bin';
    'ADCP_raw_20170504020000.bin';
    'ADCP_raw_20170504024831.bin';
    'ADCP_raw_20170504030000.bin';
    'ADCP_raw_20170504034734.bin';
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
swankie = ross_fill_defaults(swankie,swankie0);

