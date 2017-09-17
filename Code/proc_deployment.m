function DEP = proc_deployment(DEP)

if DEP.proc.skip
    disp(['% Skipping ' DEP.name])
    return
end

%% Load ADCP data, load & pre-process GPS data
adcp = load_adcp(DEP);
gps = load_gps(DEP);
if ~isfield(adcp,'info')
    [adcp(:).info] = deal({});
end

%% cruise-specific post-load hook function
[DEP, adcp, gps] = post_load_hook(DEP, adcp, gps);

%% Interpolate GPS data to ADCP timestamps
[adcp(:).gps] = deal(struct());
for ia = 1:length(adcp)
    adcp(ia).gps = struct(...
        'dn' , interp1(gps.dn, gps.dn , adcp(ia).mtime)  ,...
        'lat', interp1(gps.dn, gps.lat, adcp(ia).mtime)  ,...
        'lon', interp1(gps.dn, gps.lon, adcp(ia).mtime)  ,...
        'h'  , interp1(gps.dn, gps.h  , adcp(ia).mtime)  ,...
        'vx' , interp1(gps.dn, gps.vx , adcp(ia).mtime)  ,...
        'vy' , interp1(gps.dn, gps.vy , adcp(ia).mtime)) ;
end

%% Trim data
for ia = 1:length(adcp)
    adcp(ia) = adcp_trim_data(adcp(ia),DEP.proc.trim_methods);    
end

%% Deployment-specific pre-rotation processing
[DEP, adcp] = pre_rotation_hook(DEP,adcp);

%% Coordinate transformations
% save raw ADCP compass heading
for ia = 1:length(adcp)
    adcp(ia).heading_compass = adcp(ia).heading;
    adcp(ia).heading = adcp(ia).gps.h;
    adcp(ia).config.xducer_misalign = DEP.proc.heading_offset;
    if checkfield(DEP.proc,'use_3beam')
        ve(ia) = adcp_5beam2earth(adcp(ia));
    else
        ve(ia) = adcp_beam2earth(adcp(ia));
    end
end

%% Calculate ship speed from BT or GPS
mes = ['Ship velocity corrected using '];
for ia = 1:length(adcp)
    switch DEP.proc.ship_vel_removal
      case 'BT'
        mes = [mes 'bottom-track velocity'];
        adcp(ia).ship_vel_east  = -ve.bt_vel(1,:);
        adcp(ia).ship_vel_north = -ve.bt_vel(2,:);
      case 'GPS'
        mes = [mes 'GPS-based velocity estimate'];
        adcp(ia).ship_vel_east  = adcp(ia).gps.vx;
        adcp(ia).ship_vel_north = adcp(ia).gps.vy;
      otherwise
        mes = ['Ship velocity not removed'];
        adcp(ia).ship_vel_east  = zeros(size(adcp(ia).mtime));
        adcp(ia).ship_vel_north = zeros(size(adcp(ia).mtime));
    end
    adcp(ia).info = cat(1,adcp(ia).info,mes);
end

%% Remove ship speed
for ia = 1:length(adcp)
    veast  = squeeze(ve(ia).vel(:,1,:));
    vnorth = squeeze(ve(ia).vel(:,2,:));
    veast  = veast + repmat(adcp(ia).ship_vel_east,adcp(ia).config.n_cells,1);
    vnorth = vnorth + repmat(adcp(ia).ship_vel_north,adcp(ia).config.n_cells,1);
    ve(ia).vel(:,1,:) = veast;
    ve(ia).vel(:,2,:) = vnorth;
end

%% Update ADCP data structure
for ia = 1:length(adcp)
    adcp(ia).vel = ve(ia).vel;
end

%% Deployment-specific post-rotation processing
[DEP, adcp] = post_rotation_hook(DEP, adcp);

%% Additional filters
if isfield(DEP.proc,'filters')
    for i = 1:length(DEP.proc.filters)
        for ia = 1:length(adcp)
            adcp(ia) = adcp_filter(adcp(ia),DEP.proc.filters(i));            
        end
    end
end

%% Remove manually-specified bad data segments
if isfield(DEP.proc,'bad');
    bad = DEP.proc.bad;
    for i = 1:length(bad)
        for ia = 1:length(adcp)
            mes = sprintf('Data removed manually between %s and %s',...
                          datestr(bad{i}(1)),datestr(bad{i}(2)));
            idx = adcp(ia).mtime>=bad{i}(1) & adcp(ia).mtime<=bad{i}(2);
            adcp(ia).vel(:,:,idx) = NaN;
            adcp(ia).info = cat(1,adcp(ia).info,mes);
        end
    end
end

%% Save deployment file
dirout = fileparts(DEP.files.processed);
if ~exist(dirout,'dir'); mkdir(dirout); end
save(DEP.files.processed,'adcp')

fparts = strsplit(DEP.files.processed,'/');
flink = fullfile('..',fparts{6:end});

diary on
disp(sprintf('- [[%s][Processed deployment file]]', flink))
fprintf('\n- Processing information:\n')
for i = 1:length(adcp(1).info)
    disp(['  - ' adcp(1).info{i}])
end
diary off

%% Make figures
close all
DEP = adcp_figures(DEP);

