%% proc_deployment.m
% Usage: config = proc_deployment(config,ndep)
% Description: Save a structure with processed ROSS deployment data
%              using the given ROSS control structure and deployment
%              number.
% Inputs: config - one entry of ross config structure from adcp_master.m
%         ndep - a deployment number
% Outputs: config - modified ross confign structure
% 
% Author: Dylan Winters
% Created: 2016-10-14

function config = proc_deployment(config,ndep)
D = config.deployments(ndep);

%% Set up logging on first deployment
if ndep == 1
    logfile = fullfile(config.dirs.logs, [config.cruise,'_',lower(config.name),'.org']);
    eval(['!rm ' logfile])
    diary(logfile);
    disp(sprintf('* Deployment Processing: %s ',config.name))
    diary off
end

if checkfield(D.proc,'skip')
    disp(sprintf('\n** %d. %s', ndep, D.name));
    disp('Skipped!')
    return
end

diary on
disp(sprintf('\n** %d. %s', ndep, D.name));
diary off

%% Load ADCP data, load & pre-process GPS data
adcp = load_adcp(config,ndep);
gps = load_gps(config,ndep);
if ~isfield(adcp,'info')
    [adcp(:).info] = deal({});
end

%% cruise-specific post-load hook function
[config, adcp, gps] = post_load_hook(config,adcp,gps);

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
    adcp(ia) = adcp_trim_data(adcp(ia),D.proc.trim_methods);    
end

%% Deployment-specific pre-rotation processing
[config, adcp] = pre_rotation_hook(config,adcp);

%% Coordinate transformations
% save raw ADCP compass heading
for ia = 1:length(adcp)
    adcp(ia).heading_compass = adcp(ia).heading;
    adcp(ia).heading = adcp(ia).gps.h;
    adcp(ia).config.xducer_misalign = D.proc.heading_offset;
    if checkfield(D.proc,'use_3beam')
        ve(ia) = adcp_5beam2earth(adcp(ia));
    else
        ve(ia) = adcp_beam2earth(adcp(ia));
    end
end

%% Calculate ship speed from BT or GPS
mes = ['Ship velocity corrected using '];
for ia = 1:length(adcp)
    switch D.proc.ship_vel_removal
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
[config, adcp] = post_rotation_hook(config,adcp);

%% Additional filters
if isfield(D.proc,'filters')
    for i = 1:length(D.proc.filters)
        for ia = 1:length(adcp)
            adcp(ia) = adcp_filter(adcp(ia),D.proc.filters(i));            
        end
    end
end

%% Remove manually-specified bad data segments
if isfield(D.proc,'bad');
    bad = D.proc.bad;
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
dirout = fileparts(D.files.processed);
if ~exist(dirout,'dir'); mkdir(dirout); end
save(D.files.processed,'adcp')

fparts = strsplit(D.files.processed,'/');
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
config = ross_figures(config,ndep);

