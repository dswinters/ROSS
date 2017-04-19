function [master deployments] = petersburg_2017_apr_deployments()

%========================================================
% Define some filters
%========================================================
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('cutoff',inf);

%========================================================
% Trip info
%========================================================
master                          = struct();
master.name                     = 'petersburg_2017_apr';
% master.kayaks                   = {'Rosie','Casey','Swankie'};
master.kayaks = {'Swankie'};
master.process_data             = true;
master.make_figures.summary     = true;
master.make_figures.surface_vel = false;

%========================================================
% Processing defaults
%========================================================
defaults.proc.skip             = false;
defaults.proc.trim_methods(1)  = notrim;
% defaults.proc.filters(1)       = filt_rotmax3;
defaults.proc.ship_vel_removal = 'GPS';
defaults.files.map             = 'petersburg_dock';
defaults.plot.ylim             = [0 20];

%=======================================================
% Rosie deployments (150 hHz PAVS, Alaska flag)
%========================================================
rosie = petersburg_2017_apr_rosie();
rosie = ross_fill_defaults(rosie,defaults);

%========================================================
% Casey deployments (300 kHz Workhorse, Norway flag)
%========================================================
casey = petersburg_2017_apr_casey();
casey = ross_fill_defaults(casey,defaults);

%========================================================
% Swankie deployments (300 kHz Sentinel V, Sweden flag)
%========================================================
swankie = petersburg_2017_apr_swankie();
swankie = ross_fill_defaults(swankie,defaults);

%========================================================
% Combine deployment structures into final cell array
%========================================================
% deployments = {rosie, casey, swankie};
deployments = {swankie};