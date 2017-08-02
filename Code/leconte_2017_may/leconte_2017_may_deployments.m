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
% Processing options
%========================================================
opts.proc.skip             = false;
opts.proc.trim_methods(1)  = trim_ei_edge_b;
opts.proc.filters(1)       = filt_rotmax3;
opts.plot.ylim             = [0 200];
opts.proc.adcp_raw2mat     = false;
opts.proc.gps_raw2mat      = false;
opts.plot.map.coastline    = '../Maps/leconte2_grid_coastline.mat';

%=======================================================
% Rosie deployments (150 hHz PAVS, Alaska flag)
%========================================================
rosie = leconte_2017_may_rosie();
rosie = ross_fill_defaults(rosie,opts);

%========================================================
% Swankie deployments (300 kHz Sentinel V, Sweden flag)
%========================================================
swankie = leconte_2017_may_swankie();
swankie = ross_fill_defaults(swankie,opts);

%========================================================
% Combine deployment structures into final cell array
%========================================================
deployments = {rosie, swankie};

