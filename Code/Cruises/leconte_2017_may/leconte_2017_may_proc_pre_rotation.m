%% Deployment-specific pre-rotation processing code

function [ross adcp] = leconte_2017_may_proc_pre_rotation(ross,ndep,adcp)

id = regexp(ross.deployment(ndep).name,'(\d{12})','tokens');
id = str2num(id{1}{1});

switch id
  case 201705121830
    %% Remove near-surface data w/ high echo intensities
    for ia = 1:length(adcp)
        d3 = repmat(adcp(ia).config.ranges,[1 5 length(adcp(ia).mtime)]);
        rm = false(size(adcp(ia).vel));
        rm(d3<50 & adcp(ia).intens>100) = true;
        adcp(ia).intens(rm) = NaN;
        adcp(ia).vel(rm) = NaN;

        rm = false(size(adcp(ia).vel));
        rm(d3<50 & adcp(ia).corr<85) = true;
        adcp(ia).corr(rm) = NaN;
        adcp(ia).vel(rm) = NaN;
    end
end
