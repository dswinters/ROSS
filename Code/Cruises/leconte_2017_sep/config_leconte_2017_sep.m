function Config = config_leconte_2017_sep()

%========================================================
% Define some filters
%========================================================
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);

%========================================================
% Initialize Config struct
%========================================================
Config(1) = leconte_2017_sep_casey();
Config(2) = leconte_2017_sep_rosie();
Config(3) = leconte_2017_sep_swankie();
Config(4) = leconte_2017_sep_steller();

%========================================================
% Set up directories
%========================================================
scishare = '/Volumes/data/20170912_Alaska/';
for i = 1:4
    switch i
      case {1,2,3} % ROSS kayaks
        subdir = [Config(i).name '/'];
        Config(i).dirs.raw  = [scishare 'data/raw/ROSS/' subdir];
        Config(i).dirs.proc = [scishare 'data/processed/ADCP_ROSS/' subdir];
        Config(i).dirs.figs = [scishare 'figures/ROSS/' subdir];
      case 4       % Steller
        Config(i).dirs.raw  = [scishare 'data/raw/ADCP_steller/'];
        Config(i).dirs.proc = [scishare 'data/processed/ADCP_steller/'];
        Config(i).dirs.figs = [scishare 'figures/ADCP_steller/'];
    end        
    Config(i).dirs.maps = fullfile(getenv('HOME'),'OSU/ROSS/Maps/');
    Config(i).dirs.logs = fullfile(getenv('HOME'),'OSU/ROSS/org/');
end

%========================================================
% Default options
%========================================================
% Global
all_defaults.files.map         = 'leconte_terminus';
all_defaults.files.coastline   = 'leconte2_grid_coastline.mat';
all_defaults.proc.skip         = false; % only skip if explicitly directed
all_defaults.plot.ylim         = [0 200];
all_defaults.proc.adcp_raw2mat = false;
all_defaults.proc.gps_raw2mat  = false;
all_defaults.proc.use_3beam    = false;
% ROSS
ross_defaults.plot.lonlim         = [-132.3768 -132.3470];
ross_defaults.plot.latlim         = [56.8228 56.8434];
ross_defaults.proc.adcp_load_func = 'adcp_parse';
ross_defaults.proc.adcp_load_args = {'ross','pre'};
ross_defaults.proc.nmea           = {'GPRMC','HEHDT','PASHR','GPGGA'};
ross_defaults.files.gps           = 'GPS/*.log';
ross_defaults.files.adcp          = 'ADCP/*timestamped*.bin';
% Figures
fig_defaults.plot.make_figure.summary       = true;
fig_defaults.plot.make_figure.echo_intens   = true;
fig_defaults.plot.make_figure.corr          = true;
fig_defaults.plot.make_figure.coastline_map = true;
fig_defaults.plot.make_figure.surface_vel   = false;

% Fill ROSS defaults
for i = 1:4
    if ~isempty(Config(i).deployment)
        switch i
          case {1,2,3}
            Config(i).deployment = fill_defaults(Config(i).deployment,ross_defaults);
        end
        Config(i).deployment = fill_defaults(Config(i).deployment,fig_defaults);
        Config(i).deployment = fill_defaults(Config(i).deployment,all_defaults);
    end
end

