function defaults = config_defaults();
defaults = struct();
nofilt = struct('name','none','params',[]);

% Plot options
defaults.tlim            = [-inf inf];
defaults.plot.vlim       = [0.3 0.3 0.3];
defaults.plot.map.pos    = [963 708 723 630];
defaults.plot.map.latlim = [NaN NaN];
defaults.plot.map.lonlim = [NaN NaN];
defaults.plot.map.nx     = 75;
defaults.plot.map.ny     = 75;
defaults.files.map       = 'none';
defaults.files.coastline = 'none';

% Figures
defaults.plot.make_figure.summary       = true;
defaults.plot.make_figure.surface_vel   = false;
defaults.plot.make_figure.echo_intens   = false;
defaults.plot.make_figure.corr          = false;
defaults.plot.make_figure.coastline_map = false;

% Processing options
defaults.proc.skip = false;
defaults.proc.ship_vel_removal = 'GPS';
defaults.proc.adcp_raw2mat = false;
defaults.proc.gps_raw2mat = false;
defaults.proc.adcp_load_func = 'adcp_rdradcp_multi';
defaults.proc.adcp_load_args = {};
defaults.proc.trim_methods = nofilt;
defaults.proc.filters = nofilt;
defaults.proc.adcp_rotation_func = 'adcp_beam2earth';
defaults.proc.adcp_rotation_args = {};
defaults.proc.imu_load_args = {};
