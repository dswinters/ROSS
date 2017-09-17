function [DEP, adcp, gps] = leconte_2017_sep_post_load_hook(DEP,adcp,gps)

switch DEP.vessel.name
  case 'Steller'
    % The ADCP output file naming convention was changed mid-cruise. This causes
    % files to be out of order when loaded. Sort by timestamps to fix this.
    [~,idx] = sort(adcp.mtime);
    adcp = adcp_index(adcp,idx);
    [~,idx] = sort(gps.dn);
    flds = fields(gps);
    for i = 1:length(flds)
        if ~isempty(gps.(flds{i}))
            gps.(flds{i}) = gps.(flds{i})(idx);
        end
    end
end


