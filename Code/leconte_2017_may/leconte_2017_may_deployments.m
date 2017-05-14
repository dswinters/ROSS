function [master deployments] = leconte_2017_may_deployments()

%========================================================
% Trip info
%========================================================
master                          = struct();
master.name                     = 'leconte_2017_may';
master.kayaks                   = {'Rosie','Swankie'};
master.process_data             = true;
master.make_figures.summary     = false;
master.make_figures.surface_vel = false;
master.make_figures.echo_intens = false;
master.make_figures.corr        = false;

%========================================================
% Define some filters
%========================================================
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);

%========================================================
% Processing defaults
%========================================================
defaults.proc.skip             = false;
defaults.proc.trim_methods(1)  = trim_ei_edge_b;
% defaults.proc.filters(1)       = filt_rotmax3;
defaults.proc.ship_vel_removal = 'GPS';
defaults.files.map             = 'none';
defaults.plot.ylim             = [0 200];
defaults.proc.adcp_raw2mat     = false;
defaults.proc.gps_raw2mat      = false;

%=======================================================
% Rosie deployments (150 hHz PAVS, Alaska flag)
%========================================================
rosie = leconte_2017_may_rosie();
rosie = ross_fill_defaults(rosie,defaults);

%========================================================
% Casey deployments (300 kHz Workhorse, Norway flag)
%========================================================
casey = leconte_2017_may_casey();
casey = ross_fill_defaults(casey,defaults);

%========================================================
% Swankie deployments (300 kHz Sentinel V, Sweden flag)
%========================================================
swankie = leconte_2017_may_swankie();
swankie = ross_fill_defaults(swankie,defaults);

%========================================================
% Combine deployment structures into final cell array
%========================================================
deployments = {rosie, swankie};

