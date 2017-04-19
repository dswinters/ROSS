function swankie = leconte_2017_may_swankie()
%        FORWARD
%  1   3    ^
%    5      |--> STARBOARD
%  4   2   
swankie0.heading_offset = 45;
swankie0.proc.adcp_load_function = 'rdradcp_s5_multi';
%--------------------------------------------------------%
dep = 1;
swankie(dep).name       = 'SWANKIE_test1';
swankie(dep).tlim       = datenum([;])
swankie(dep).files.adcp = {};
swankie(dep).files.gps  = {};
%--------------------------------------------------------%
swankie = ross_fill_defaults(swankie,swankie0);

