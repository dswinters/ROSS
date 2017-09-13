function defaults = ross_defaults();
defaults = struct();

% Plot options
defaults.plot.vlim          = [0.3 0.3 0.3];
defaults.plot.map.pos       = [963 708 723 630];
defaults.plot.map.latlim    = [NaN NaN];
defaults.plot.map.lonlim    = [NaN NaN];
defaults.plot.map.nx        = 75;
defaults.plot.map.ny        = 75;
defaults.plot.map.coastline = false;
defaults.files.map = 'none';
defaults.files.coastline = 'none';

% Make figures
defaults.plot.make_figure.all           = false;
defaults.plot.make_figure.summary       = true;
defaults.plot.make_figure.surface_vel   = false;
defaults.plot.make_figure.echo_intens   = true;
defaults.plot.make_figure.corr          = false;
defaults.plot.make_figure.coastline_map = false;

% Processing options
defaults.proc.ship_vel_removal = 'GPS';
defaults.proc.adcp_raw2mat = false;
defaults.proc.gps_raw2mat = false;


