function [ross adcp] = leconte_2017_may_proc_post_load(ross,ndep,adcp)

%% Fix timestamps
% Timestamps logged to the ROSS computers for each ADCP data ensemble appear to
% lag behind the true ensemble times. Use the 1st logged timestamp as the start
% time, but use the ADCP's internal clock for time since start.

for i = 1:length(adcp)
    adcp(i).mtime = adcp(i).mtime(1) + adcp(i).mtime_raw - adcp(i).mtime_raw(1);
end


