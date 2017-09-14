function [cruise, deployments] = config_leconte_2017_sep()

%========================================================
% Cruise info
%========================================================
cruise = struct();
cruise.name = 'leconte_2017_sep';
cruise.kayaks = {'Casey','Rosie','Swankie'};

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
casey = leconte_2017_sep_casey();
rosie = leconte_2017_sep_rosie();
swankie = leconte_2017_sep_swankie();

% Combine deployment structures into cell array
deployments = {casey, rosie, swankie};

for i = 1:length(deployments)
    if ~isempty(deployments{i})
        deployments{i} = ross_fill_defaults(deployments{i},cruise_defaults);
    end
end
