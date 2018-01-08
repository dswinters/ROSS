function [dep, adcp, gps] = leconte_2017_sep_post_load_hook(dep,adcp,gps)

switch dep.vessel.name
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

    %% Assign $PADCP timestamps lines from .N1R files to ADCP pings from ADCP data structure
    afiles = adcp.files;

    % Load PADCP data
    gps_all = load(dep.files.gps_all);
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


  case 'Swankie'
    %% Load custom BT files
    if exist(dep.files.bt_profile,'file') == 2;
        bt = load(dep.files.bt_profile);
        bt.dn(year(bt.dn)<2000) = bt.dn(year(bt.dn)<2000) + datenum([2000 0 0 0 0 0]);
        adcp.bt_range = interp1(bt.dn',bt.depth',adcp.mtime')';
        adcp.info = cat(1,adcp.info,{'Bottom contours defined manually'});
        adcp = adcp_trim_data(adcp,struct('name','BT','params',90));
    end

    %% Reduce "bottom" depth for near-terminus positions
    tmp = load(dep.files.terminus);
    t = tmp.termini; clear tmp

    [~,nt] = min(abs([t.dn] - mean(dep.tlim)));
    lat = interp1(gps.dn,gps.lat,adcp.mtime);
    lon = interp1(gps.dn,gps.lon,adcp.mtime);
    dist = nan*lat;
    i = 1;
    for i = 1:length(dist)
        dist(i) = 1000*min(lldistkm([lat(i) lon(i)],[t(nt).lat', t(nt).lon']));
    end
    for i = 1:size(adcp.bt_range,1)
        adcp.bt_range(i,:) = min(adcp.bt_range(i,:),dist);
    end
    adcp.info = cat(1,adcp.info,{'Glacier distance used in place of bottom depth where distance<depth'});
    adcp.info = cat(1,adcp.info,{sprintf('Terminus measured at %s',datestr(t(nt).dn))});
end

