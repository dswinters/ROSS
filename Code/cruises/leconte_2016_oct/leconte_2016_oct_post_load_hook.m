function [dep, adcp, gps] = leconte_2016_oct_post_load_hook(dep,adcp,gps)

switch dep.vessel.name
  case 'Pelican'
    for ia = 1:length(adcp)
        [~,idx] = sort(adcp(ia).mtime);
        adcp(ia) = adcp_index(adcp(ia),idx);
    end
    [~,idx] = sort(gps.dn);
    flds = fields(gps);
    for i = 1:length(flds)
        if ~isempty(gps.(flds{i}))
            gps.(flds{i}) = gps.(flds{i})(idx);
        end
    end

    %% Assign $PADCP timestamps lines from .N1R files to ADCP pings from ADCP data structure
    afiles = adcp.files;

    % Load PADCP data
    gps_all = load(dep.files.gps_mat);
    if ~isfield(gps_all,'PADCP');
        gps_all = nav_read(dep.files.gps,{'PADCP'});
    end

    nfiles = gps_all.files;
    padcp = gps_all.PADCP;

    % Identify unique file prefixes
    prefixes = cell(length(afiles),1);
    for i = 1:length(afiles)
        prefix = regexp(adcp.files{i},'(.*)_\d{6}.ENR','tokens');
        prefixes{i} = prefix{1}{1};
    end
    prefixes = unique(prefixes);

    % Assign PADCP timestamps to ADCP pings
    has_timestamp = false(size(adcp.mtime));
    dn_new = nan(size(adcp.mtime));
    for i = 1:length(prefixes)
        nfidx = find(~cellfun(@isempty,regexp(nfiles,prefixes{i})));
        afidx = find(~cellfun(@isempty,regexp(afiles,prefixes{i})));
        nidx = find(ismember(padcp.fnum,nfidx));
        aidx = find(ismember(adcp.file,afidx));
        for ia = 1:length(aidx)
            in = find(padcp.num(nidx) == adcp.number(aidx(ia)));
            if length(in)==1
                has_timestamp(aidx(ia)) = true;
                % Re-correct PC timestamps with average GPS offset
                offset = padcp.dn - padcp.dn_pc;
                idx = abs(offset-nanmean(offset)) < nanstd(offset); % exclude outliers
                avg_offset = nanmean(offset(idx));
                dn_new(aidx(ia)) = padcp.dn_pc(nidx(in)) + avg_offset;
            end
        end
    end

    adcp.mtime = dn_new;
    mes = sprintf(['Assigned $PADCP timestamps from .N1R files to', ...
                   ' ADCP pings from .ENR files. %.2f%% success.'],...
                  100*nanmean(has_timestamp));
    adcp.info = cat(1,adcp.info,mes);
end
