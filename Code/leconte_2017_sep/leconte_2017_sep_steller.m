function config = leconte_2017_sep_steller()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  1   3    ^
%    x      |--> STARBOARD
%  4   2   
config.name = 'Steller';
dep = 0;

defaults.proc.heading_offset = 55;
defaults.proc.adcp_load_func = 'adcp_rdradcp_multi';
defaults.proc.nmea = {'GPRMC','HEHDT'};
defaults.dirs.raw = ''; % All raw data is in the same folder

dep = dep+1;
steller(dep).name = 'ADCP_steller';
steller(dep).files.gps = '*.N1R';
steller(dep).files.adcp = '*.ENR';
steller(dep).proc.adcp_raw2mat = true; % refresh ADCP mat files
steller(dep).proc.gps_raw2mat = true; % refresh GPS mat files;

steller = ross_fill_defaults(steller,defaults);
config.deployments = steller;
