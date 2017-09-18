function vessel = leconte_2017_sep_post_setup_hook(vessel)

switch vessel.name
  case 'Swankie'
    %% Assign a BT profile file
    bt_profiles_dir = fullfile(vessel.dirs.proc,'bt_profiles/');
    for i = 1:length(vessel.deployment)
        dep = vessel.deployment(i);
        dep.files.bt_profile = fullfile(bt_profiles_dir,[dep.dirs.raw '.mat']);
        vessel.deployment(i) = dep;
    end
end







