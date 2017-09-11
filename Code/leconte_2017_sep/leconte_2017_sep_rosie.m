function rosie = leconte_2017_sep_rosie()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
dep = 0;

%--------------------------------------------------------%
% Default deployment options                             %
%--------------------------------------------------------%
defaults.proc.heading_offset = 135;
defaults.proc.adcp_load_function = 'adcp_parse';
defaults.proc.ross_timestamps = 'pre';
defaults.files.map = 'leconte_terminus';
defaults.tlim = [-inf inf];
defaults.plot.ylim = [0 200];
defaults.proc.skip = false;
defaults.proc.use_3beam = false;

% Deployments here

rosie = ross_fill_defaults(rosie,defaults);
