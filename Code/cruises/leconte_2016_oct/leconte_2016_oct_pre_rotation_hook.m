function [dep, adcp] = leconte_2016_oct_pre_rotation_hook(dep,adcp)

%% The ADCP was re-mounted several times and requires a non-uniform heading offset
switch dep.name
  case 'Pelican_300kHz_all'
    % initialize as zeros
    h0 = zeros(size(adcp.heading));
    offsets = {[45,-inf,inf];
               [135, datenum([2016 10 09 18 54 05; 2016 10 09 20 46 36])']; % 06001
               [135, datenum([2016 10 11 15 09 54; 2016 10 11 17 07 35])'];  
               [135, datenum([2016 10 09 22 16 00; 2016 10 10 01 13 20])']}; % 09001
    for i = 1:length(offsets)
        idx = adcp.mtime > offsets{i}(2) & adcp.mtime < offsets{i}(3);
        h0(idx) = offsets{i}(1);
    end
    adcp.heading = adcp.heading + h0;
    adcp.config.xducer_misalign = 0;
end



