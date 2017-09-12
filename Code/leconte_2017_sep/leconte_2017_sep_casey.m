function swankie = leconte_2017_sep_casey()
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


casey = ross_fill_defaults(casey,defaults);
