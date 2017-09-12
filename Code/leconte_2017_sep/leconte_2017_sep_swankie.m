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
defaults.proc.heading_offset = 45;
defaults.proc.adcp_load_function = 'adcp_parse';
defaults.proc.ross_timestamps = 'pre';
defaults.files.map = 'leconte_terminus';
defaults.tlim = [-inf inf];
defaults.plot.ylim = [0 200];
defaults.proc.skip = false;
defaults.proc.use_3beam = false;
defaults.proc.adcp_raw2mat = true;

% Deployments here
dep = dep+1;
swankie(dep).proc.skip = false;
swankie(dep).dirs.raw = 'deployment_fake';
swankie(dep).name = 'swankie_deployment_test';
swankie(dep).files.adcp = '*_timestamped*.bin';
swankie(dep).files.gps = '*.log';
swankie(dep).plot.ylim = [0 200];



swankie = ross_fill_defaults(swankie,defaults);
