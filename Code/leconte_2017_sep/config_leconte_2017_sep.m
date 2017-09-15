function Config = config_leconte_2017_sep()

%========================================================
% Define some filters
%========================================================
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);

%========================================================
% Cruise default options
%========================================================
cruise_defaults.map                   = 'leconte_terminus';
cruise_defaults.files.coastline       = 'leconte2_grid_coastline.mat';
cruise_defaults.proc.skip             = false;
cruise_defaults.proc.trim_methods(1)  = notrim;
cruise_defaults.proc.filters(1)       = notrim;
cruise_defaults.plot.ylim             = [0 200];
cruise_defaults.plot.lonlim           = [-132.3768 -132.3470];
cruise_defaults.plot.latlim           = [56.8228 56.8434];
cruise_defaults.proc.adcp_raw2mat     = false;
cruise_defaults.proc.gps_raw2mat      = false;
cruise_defaults.files.gps             = 'GPS/*.log';
cruise_defaults.files.adcp            = 'ADCP/*timestamped*.bin';

% Figures
cruise_defaults.plot.make_figure.summary       = true;
cruise_defaults.plot.make_figure.echo_intens   = true;
cruise_defaults.plot.make_figure.corr          = true;
cruise_defaults.plot.make_figure.coastline_map = true;
cruise_defaults.plot.make_figure.surface_vel   = false;

% Get deployments
Config(1).name = 'Casey';
Config(1).deployments = leconte_2017_sep_casey();
Config(2).name = 'Rosie';
Config(2).deployments = leconte_2017_sep_rosie();
Config(3).name = 'Swankie';
Config(3).deployments = leconte_2017_sep_swankie();

for i = 1:length(Config)
    if ~isempty(Config(i).deployments)
        Config(i).deployments = ross_fill_defaults(...
            Config(i).deployments,...
            cruise_defaults);
    end
end
