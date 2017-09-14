function [trip deployments] = leconte_2017_may_deployments()

%========================================================
% Trip info
%========================================================
trip = struct();
trip.name   = 'leconte_2017_may';
trip.kayaks = {'Rosie','Swankie'};

%========================================================
% Define some filters
%========================================================
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);

%========================================================
% Default options
%========================================================
defaults.files.map             = 'leconte_terminus';
defaults.proc.skip             = false;
defaults.proc.trim_methods(1)  = trim_ei_edge_b;
defaults.proc.filters(1)       = filt_rotmax3;
defaults.plot.ylim             = [0 200];
defaults.proc.adcp_raw2mat     = false;
defaults.proc.gps_raw2mat      = false;
defaults.plot.map.coastline    = '../Maps/leconte2_grid_coastline.mat';

%=======================================================
% Rosie deployments (150 hHz PAVS, Alaska flag)
%========================================================
rosie = leconte_2017_may_rosie();
rosie = ross_fill_defaults(rosie,defaults);

%========================================================
% Swankie deployments (300 kHz Sentinel V, Sweden flag)
%========================================================
swankie = leconte_2017_may_swankie();
swankie = ross_fill_defaults(swankie,defaults);

%========================================================
% Combine deployment structures into final cell array
%========================================================
deployments = {rosie, swankie};

