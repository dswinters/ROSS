function vessel = leconte_2017_sep_post_setup_hook(vessel)

%% Assign map and coastline files for spatial figures
if ~strcmp(vessel.name,'Pelican')
    for d = 1:length(vessel.deployment)
        dep                  = vessel.deployment(d);
        dep.files.map        = fullfile(vessel.dirs.maps,dep.files.map);
        dep.files.coastline  = fullfile(vessel.dirs.maps,dep.files.coastline);
        vessel.deployment(d) = dep;
    end
end

%% Assign a BT profile files
switch vessel.name
  case {'Swankie','Steller'}
    bt_profiles_dir = fullfile(vessel.dirs.proc,'bt_profiles/');
    for i = 1:length(vessel.deployment)
        dep = vessel.deployment(i);
        dep.files.bt_profile = fullfile(bt_profiles_dir,[dep.dirs.raw '.mat']);
        vessel.deployment(i) = dep;
    end
end







