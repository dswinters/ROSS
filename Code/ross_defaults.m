function defaults = ross_defaults();
defaults = struct();

% Plot options
defaults.plot.vlim = [0.3 0.3 0.3];
defaults.plot.map.pos = [963 708 723 630];
defaults.plot.map.latlim = [NaN NaN];
defaults.plot.map.lonlim = [NaN NaN];
defaults.plot.map.nx = 75;
defaults.plot.map.ny = 75;
defaults.plot.map.coastline = false;

% Processing options
defaults.proc.
