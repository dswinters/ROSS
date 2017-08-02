function [ross adcp] = leconte_2017_may_proc_post_load(ross,ndep,adcp)

%% Fix timestamps
% Timestamps logged to the ROSS computers for each ADCP data ensemble appear to
% lag behind the true ensemble times. Use the 1st logged timestamp as the start
% time, but use the ADCP's internal clock for time since start.

% is_section = length(regexp(ross.deployments(ndep).name,'section'))>0;
% if ~is_section
%     for i = 1:length(adcp)
%         adcp(i).mtime = adcp(i).mtime(1) + adcp(i).mtime_raw - adcp(i).mtime_raw(1);
%     end
% end
%% Note: This has been moved into ross_load_adcp


%% Create bottom-track profiles
% Match a deployment timestamp
id = regexp(ross.deployments(ndep).name,'(\d{12})','tokens');
id = str2num(id{1}{1});

dirin = [ross.dirs.proc.deployments 'bt_profiles/'];
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

