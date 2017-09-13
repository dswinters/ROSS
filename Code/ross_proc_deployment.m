%% ross_proc_deployment.m
% Usage: ross = ross_proc_deployment(ross,ndep)
% Description: Save a structure with processed ROSS deployment data
%              using the given ROSS control structure and deployment
%              number.
% Inputs: ross - one entry of ross control structure from ross_master.m
%         ndep - a deployment number
% Outputs: ross - modified ross control structure
% 
% Author: Dylan Winters
% Created: 2016-10-14

function ross = ross_proc_deployment(ross,ndep)
D = ross.deployments(ndep);

if checkfield(D.proc,'skip')
    disp(sprintf('\n*** %d. %s', ndep, D.name));
    disp('Skipped!')
    return
end

diary on
disp(sprintf('\n*** %d. %s', ndep, D.name));
diary off

%% Load ADCP data, load & pre-process GPS data
adcp = ross_load_adcp(ross,ndep);
gps = ross_load_gps(ross,ndep);
if ~isfield(adcp,'info')
    [adcp(:).info] = deal({});
end

%% Deployment-specific post-load function
fn = [ross.trip '_proc_post_load'];
if exist(fn) == 2
    [ross adcp] = feval(fn,ross,ndep,adcp);
end

%% Process GPS data for ADCP data
% For lat/lon/heading, this prioritizes:
%  1. GPS logged to ROSS computer
%  2. Pixhawk logs (using differential heading estimate)
[adcp(:).gps] = deal(struct());
for ia = 1:length(adcp)
    [ross, adcp(ia)] = ross_proc_gps(ross,ndep,adcp(ia),gps);
end

%% Trim data
for ia = 1:length(adcp)
    adcp(ia) = adcp_trim_data(adcp(ia),D.proc.trim_methods);    
end

%% Deployment-specific pre-rotation processing
fn = [ross.trip '_proc_pre_rotation'];
if exist(fn) == 2
    [ross adcp] = feval(fn,ross,ndep,adcp);
end

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
fn = [ross.trip '_proc_post_rotation'];
if exist(fn) == 2
    [ross adcp] = feval(fn,ross,ndep,adcp);
end

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
dirout = ross.dirs.proc.deployments;
if ~exist(dirout,'dir'); mkdir(dirout); end
fout = [D.name '.mat'];
ross.deployments(ndep).files.final = [dirout fout];
save(ross.deployments(ndep).files.final,'adcp')
fparts = strsplit(ross.deployments(ndep).files.final,'/');
flink = ['[[' fullfile('..',fparts{6:end}) ']]'];

diary on
disp(['- Processed deployment file: ', flink])
disp('- Processing information:')
for i = 1:length(adcp(1).info)
    disp(['  - ' adcp(1).info{i}])
end
diary off

%% Make figures
close all
ross = ross_figures(ross,ndep);

