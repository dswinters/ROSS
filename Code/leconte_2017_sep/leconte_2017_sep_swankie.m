function swankie = leconte_2017_sep_swankie()
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
swankie0.proc.skip = false;
swankie0.proc.use_3beam = false;

dep = dep+1;
swankie(dep).proc.skip = false;
swankie(dep).dir_raw = 'deployment_test';
swankie(dep).name = 'TEST';
swankie(dep).files.adcp = 'ADCP_timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];
swankie(dep).proc.adcp_raw2mat = false;


swankie = ross_fill_defaults(swankie,swankie0);
