function DEP = proc_deployment(DEP)

if DEP.proc.skip
    disp(['% Skipping ' DEP.name])
    return
end

%% Load ADCP data, load & pre-process GPS data
adcp = load_adcp(DEP);
gps = load_gps(DEP);

% An ADCP structure may have multiple configurations...
% Loop through these.
for ia = 1:length(adcp)

    if ~isfield(adcp,'info'); [adcp.info] = deal({}); end

    % cruise-specific post-load hook function
    [DEP, adcp(ia), gps] = post_load_hook(DEP, adcp(ia), gps);

    % Interpolate GPS data to ADCP timestamps
    gpsflds = fields(gps);
    for i = 1:length(gpsflds)
        adcp(ia).gps.(gpsflds{i}) = ...
            interp1(gps.dn,gps.(gpsflds{i}),adcp(ia).mtime);
    end

    % Trim data
    adcp(ia) = adcp_trim_data(adcp(ia),DEP.proc.trim_methods);    

    % Set heading offset
    adcp(ia).config.xducer_misalign = DEP.proc.heading_offset;

    % Fill adcp data struct with external gyro data if available
    adcp(ia).heading_internal = adcp(ia).heading; % save raw heading
    adcp(ia).heading = adcp(ia).gps.h;
    % if isfield(gps,'p')
    %     adcp(ia).pitch_internal = adcp(ia).pitch;
    %     adcp(ia).pitch = adcp(ia).gps.p;
    % end
    % if isfield(gps,'r')
    %     adcp(ia).roll_internal = adcp(ia).roll;
    %     adcp(ia).roll = adcp(ia).gps.r;
    % end        

    % Deployment-specific pre-rotation processing
    [DEP, adcp(ia)] = pre_rotation_hook(DEP,adcp(ia));

    % Coordinate transformations
    ve = feval(DEP.proc.adcp_rotation_func, adcp(ia), ...
               DEP.proc.adcp_rotation_args{:});

    % Calculate ship speed from BT or GPS
    mes = ['Ship velocity corrected using '];
    switch DEP.proc.ship_vel_removal
      case 'BT'
        mes = [mes 'bottom-track velocity'];
        adcp(ia).ship_vel_east  = -ve.bt_vel(1,:);
        adcp(ia).ship_vel_north = -ve.bt_vel(2,:);
      case 'GPS'
        mes = [mes 'GPS track velocity'];
        adcp(ia).ship_vel_east  = adcp(ia).gps.vx;
        adcp(ia).ship_vel_north = adcp(ia).gps.vy;
      otherwise
        mes = ['Ship velocity not removed'];
        adcp(ia).ship_vel_east  = zeros(size(adcp(ia).mtime));
        adcp(ia).ship_vel_north = zeros(size(adcp(ia).mtime));
    end
    adcp(ia).info = cat(1,adcp(ia).info,mes);

    % Remove ship speed
    veast  = squeeze(ve.vel(:,1,:));
    vnorth = squeeze(ve.vel(:,2,:));
    veast  = veast + repmat(adcp(ia).ship_vel_east,adcp(ia).config.n_cells,1);
    vnorth = vnorth + repmat(adcp(ia).ship_vel_north,adcp(ia).config.n_cells,1);
    ve.vel(:,1,:) = veast;
    ve.vel(:,2,:) = vnorth;

    % Update ADCP data structure
    adcp(ia).vel = ve.vel;
    clear ve;

    % Deployment-specific post-rotation processing
    [DEP, adcp(ia)] = post_rotation_hook(DEP, adcp(ia));

    % Additional filters
    if isfield(DEP.proc,'filters')
        for i = 1:length(DEP.proc.filters)
            adcp(ia) = adcp_filter(adcp(ia),DEP.proc.filters(i));            
        end
    end

    % Remove manually-specified bad data segments
    if isfield(DEP.proc,'bad');
        bad = DEP.proc.bad;
        for i = 1:length(bad)
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

disp(['  - Saved ' DEP.files.processed])
for i = 1:length(adcp(1).info)
    disp(['    - ' adcp(1).info{i}])
end

%% Make figures
close all
DEP = adcp_figures(DEP);

