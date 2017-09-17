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

defaults.proc.heading_offset = 31.23;
defaults.proc.adcp_load_func = 'adcp_rdradcp_multi';
defaults.proc.nmea = {'GPRMC','HEHDT'};
defaults.dirs.raw = ''; % All raw data is in the same folder

dep = dep+1;
steller(dep).name = 'ADCP_steller';
steller(dep).files.gps = '*.N1R';
steller(dep).files.adcp = '*.ENR';
steller(dep).proc.adcp_raw2mat = false; % refresh ADCP mat files
steller(dep).proc.gps_raw2mat  = false; % refresh GPS mat files;
steller(dep).plot.lonlim = [-132.5350,-132.3470];
steller(dep).plot.latlim = [56.7164, 56.8462];
steller(dep).plot.make_figure.summary = true;
steller(dep).plot.make_figure.surface_vel = false;
steller(dep).plot.make_figure.echo_intens = false;
steller(dep).plot.make_figure.corr = false;
steller(dep).plot.make_figure.coastline_map = true;

%* Diagnostics
% steller(dep).proc.diagnostic = true;

steller = fill_defaults(steller,defaults);
config.deployment = steller;
