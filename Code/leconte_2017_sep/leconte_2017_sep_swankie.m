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
swankie0.proc.ross_timestamps = 'pre';
swankie0.files.map = 'leconte_terminus';
swankie0.tlim = [-inf inf];
rosie0.plot.ylim = [0 200];
swankie0.proc.skip = false;
swankie0.proc.use_3beam = false;

% Deployments here

swankie = ross_fill_defaults(swankie,swankie0);
