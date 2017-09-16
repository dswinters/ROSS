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
      case 4         % Steller
        Config(i).dirs.raw  = [scishare 'data/raw/ADCP_steller/'];
        Config(i).dirs.proc = [scishare 'data/processed/ADCP_steller/'];
        Config(i).dirs.figs = [scishare 'figures/ADCP_steller/'];
    end        
    Config(i).dirs.maps = fullfile(getenv('HOME'),'OSU/ROSS/Maps/');
    Config(i).dirs.logs = fullfile(getenv('HOME'),'OSU/ROSS/org/');
end
% Steller

%========================================================
% ROSS default options
%========================================================
ross_defaults.map                   = 'leconte_terminus';
ross_defaults.files.coastline       = 'leconte2_grid_coastline.mat';
ross_defaults.proc.skip             = false;
ross_defaults.proc.trim_methods(1)  = notrim;
ross_defaults.proc.filters(1)       = notrim;
ross_defaults.proc.nmea             = {'GPRMC','HEHDT','PASHR','GPGGA'};
ross_defaults.plot.ylim             = [0 200];
ross_defaults.plot.lonlim           = [-132.3768 -132.3470];
ross_defaults.plot.latlim           = [56.8228 56.8434];
ross_defaults.proc.adcp_raw2mat     = false;
ross_defaults.proc.gps_raw2mat      = false;
ross_defaults.files.gps             = 'GPS/*.log';
ross_defaults.files.adcp            = 'ADCP/*timestamped*.bin';
% Figures
ross_defaults.plot.make_figure.summary       = true;
ross_defaults.plot.make_figure.echo_intens   = true;
ross_defaults.plot.make_figure.corr          = true;
ross_defaults.plot.make_figure.coastline_map = true;
ross_defaults.plot.make_figure.surface_vel   = false;

% Fill ROSS defaults
for i = 1:3
    if ~isempty(Config(i).deployments)
        Config(i).deployments = ross_fill_defaults(...
            Config(i).deployments,...
            ross_defaults);
    end
end

