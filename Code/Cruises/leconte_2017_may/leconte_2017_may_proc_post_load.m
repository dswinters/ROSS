function [ross adcp] = leconte_2017_may_proc_post_load(ross,ndep,adcp)

%% Create bottom-track profiles
% Match a deployment timestamp
id = regexp(ross.deployments(ndep).name,'(\d{12})','tokens');
id = str2num(id{1}{1});

dirin = [ross.dirs.proc 'bt_profiles/'];
bt_file = sprintf('%s%s_%d_bt.mat',dirin,lower(ross.name),id);
if ~exist(bt_file,'file')
    ross_make_bottom_profile(ross,ndep,adcp);
end

if exist(bt_file,'file')
    bt = load(bt_file);
    for i = 1:length(adcp)
        for b = 1:adcp(i).config.n_beams
            adcp(i).bt_range(b,:) = interp1(bt.dn,bt.depth(b,:),adcp(i).mtime);
        end
    end
end

