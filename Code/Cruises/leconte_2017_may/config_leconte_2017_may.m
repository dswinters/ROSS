function Vessels = config_leconte_2017_may()

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
defaults.files.coastline       = 'leconte2_grid_coastline.mat';
defaults.proc.skip             = false;
defaults.proc.trim_methods(1)  = trim_ei_edge_b;
defaults.proc.filters(1)       = filt_rotmax3;
defaults.plot.ylim             = [0 200];
defaults.proc.adcp_raw2mat     = false;
defaults.proc.gps_raw2mat      = false;
defaults.plot.map.coastline    = '../Maps/leconte2_grid_coastline.mat';

Vessels(1) = leconte_2017_may_rosie();
Vessels(2) = leconte_2017_may_swankie();

for i = 1:length(Vessels)
    if ~isempty(Vessels(i).deployment)
        Vessels(i).deployment = fill_defaults(...
            Vessels(i).deployment,...
            defaults);
    end
end

%% Pelican and Steller
Vessels(3) = leconte_2017_may_pelican();
Vessels(4) = leconte_2017_may_steller();
