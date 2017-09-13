function [trip deployments] = leconte_2017_sep_deployments()

%========================================================
% Trip info
%========================================================
trip = struct();
trip.name = 'leconte_2017_sep';
trip.kayaks = {'Casey','Rosie','Swankie'};

%========================================================
% Define some filters
%========================================================
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);

%========================================================
% Trip default options
%========================================================
trip_defaults.map                   = 'leconte_terminus';
trip_defaults.files.coastline       = 'leconte2_grid_coastline.mat';
trip_defaults.proc.skip             = false;
trip_defaults.proc.trim_methods(1)  = notrim;
trip_defaults.proc.filters(1)       = notrim;
trip_defaults.plot.ylim             = [0 200];
trip_defaults.proc.adcp_raw2mat     = true;
trip_defaults.proc.gps_raw2mat      = true;


% Get deployments
casey = leconte_2017_sep_casey();
rosie = leconte_2017_sep_rosie();
swankie = leconte_2017_sep_swankie();

% Combine deployment structures into cell array
deployments = {casey, rosie, swankie};

for i = 1:length(deployments)
    if ~isempty(deployments{i})
        deployments{i} = ross_fill_defaults(deployments{i},trip_defaults);
    end
end
