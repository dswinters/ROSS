function [dep, adcp, gps] = leconte_2017_sep_post_load_hook(dep,adcp,gps)

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
    if true
        %% Load custom BT files
        if exist(dep.files.bt_profile,'file') == 2;
            bt = load(dep.files.bt_profile);
            bt.dn(year(bt.dn)<2000) = bt.dn(year(bt.dn)<2000) + datenum([2000 0 0 0 0 0]);
            adcp.bt_range = interp1(bt.dn',bt.depth',adcp.mtime')';
            adcp.info = cat(1,adcp.info,{'Bottom contours defined manually'});
            adcp = adcp_trim_data(adcp,struct('name','BT','params',90));
        end
    end

    if false
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
end

%% Pitch/roll offsets

% Default offsets, calculated while using internal ADPC gyro
p0 = -0.9;
r0 = -1.0;
t0h = 2.087;

X=@(h) [ones(length(h),1) ,...
        sind(h(:))        ,...
        cosd(h(:))];
func = @(C,h) mod(h + [X(h(:))*C]', 360);

switch dep.vessel.name
  case 'Swankie'
    switch dep.name
      case 'swankie_deployment_20170913_132345'
        coeffs = [-22.3329;
                  -16.8558;
                    9.0458];
        % h0 = 46.1008; % when using internal gyro
        gh0 = 11.81;
        gp0 = -1.18;
        gr0 = 1.05;
        h0 = 46.16; % when using PixHawk IMU
        t0h = 1.03;
      case 'swankie_deployment_20170916_002146'
        coeffs = [-20.2622;
                  -14.3820;
                    9.0112];
        % h0 = 43.2711;
        h0 = 44.75;
        t0h = -4.03;
        gh0 = -5.24;
        gp0 = -1.28;
        gr0 = 1.05;
      case 'swankie_deployment_20170916_232943'
        coeffs = [-23.1366;
                  -16.2305;
                    7.5486];
        h0 = 44.6899;
      case 'swankie_deployment_20170917_202349'
        coeffs = [-22.6119
                  -14.6621
                  9.1032];
        % h0 = 45.9735;
        t0h = 2.11;
        h0 = 44.31;
        gh0=12.61;
        gp0=-1.16;
        gr0=0.44;
    end
    gps.h = nav_interp_heading(gps.dn+t0h/86400,gps.h,gps.dn);
    dep.proc.heading_offset = h0;
    adcp.config.heading_cal_coeffs = coeffs;
    adcp.config.heading_cal_func = func;

    adcp.config.gyro_h0 = gh0
    adcp.config.gyro_p0 = gp0;
    adcp.config.gyro_r0 = gr0;

    % adcp.pitch = adcp.pitch + p0;
    % adcp.roll = adcp.roll + r0;
    % adcp.info = cat(1,adcp.info,{sprintf('Pitch offset: %.2f',p0)});
    % adcp.info = cat(1,adcp.info,{sprintf('Roll offset: %.2f',r0)});
end

