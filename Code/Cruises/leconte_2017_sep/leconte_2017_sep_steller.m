function vessel = leconte_2017_sep_steller()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  1   3    ^
%    x      |--> STARBOARD
%  4   2   
vessel.name = 'Steller';
dbox = fullfile([getenv('DROPBOX'), '/']);
scishare = '/Volumes/Norgannon/ScienceShare/20170912_Alaska/';
vessel.dirs.raw  = [scishare 'data/raw/ADCP_steller/'];
vessel.dirs.proc = [dbox 'LeConte/Data/ocean/september2017/processed/ADCP_steller/'];
vessel.dirs.figs = [dbox 'LeConte/Data/ocean/september2017/processed/ADCP_steller/figures/'];

dep = 0;

defaults.proc.heading_offset = 40.86 - 9.22; % adcp mounting offset + hemisphere mounting offset
defaults.proc.adcp_load_func = 'adcp_rdradcp_multi';
defaults.proc.nmea = {'GPRMC','HEHDT'};
defaults.dirs.raw = ''; % All raw data is in the same folder

dep = dep+1;
deployment(dep).name = 'ADCP_steller';
deployment(dep).files.gps = '*.N1R';
deployment(dep).files.adcp = '*.ENR';
deployment(dep).proc.adcp_raw2mat = true; % refresh ADCP mat files
deployment(dep).proc.gps_raw2mat  = true; % refresh GPS mat files;
deployment(dep).plot.lonlim = [-132.5350,-132.3470];
deployment(dep).plot.latlim = [56.7164, 56.8462];
deployment(dep).plot.make_figure.summary = true;
deployment(dep).plot.make_figure.surface_vel = false;
deployment(dep).plot.make_figure.echo_intens = false;
deployment(dep).plot.make_figure.corr = false;
deployment(dep).plot.make_figure.coastline_map = true;

%* Diagnostics
% deployment(dep).proc.diagnostic = true;

dep = dep+1;
deployment(dep).name = 'steller_test';
deployment(dep).tlim = datenum([2017 09 16 14 00 00;
                                2017 09 16 16 30 00]);
deployment(dep).files.gps = '*.N1R';
deployment(dep).files.adcp = '*.ENR';
deployment(dep).plot.make_figure.summary = true;
deployment(dep).plot.make_figure.surface_vel = false;
deployment(dep).plot.make_figure.echo_intens = false;
deployment(dep).plot.make_figure.corr = false;
deployment(dep).plot.make_figure.coastline_map = false;


deployment = fill_defaults(deployment,defaults);
vessel.deployment = deployment;
