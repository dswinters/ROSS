function rosie = leconte_2017_sep_rosie()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
dep=0;

%--------------------------------------------------------%
% Default deployment options                             %
%--------------------------------------------------------%
rosie0.proc.heading_offset = 135;
rosie0.proc.adcp_load_function = 'adcp_parse';
rosie0.proc.ross_timestamps = 'pre';
swankie0.files.map = 'leconte_terminus';
rosie0.tlim = [-inf inf];
rosie0.plot.ylim = [0 200];
rosie0.proc.skip = false;
rosie0.proc.use_3beam = false;

% Deployments here

rosie = ross_fill_defaults(rosie,rosie0);
