function [DEP, adcp] = leconte_2017_may_post_rotation_hook(DEP,adcp)

switch DEP.vessel.name
  case 'Steller'
    %% Correct for offset between ADCP/GPS position
    d0 = 12.3; % distance (m) between ADCP/GPS
    h0 = 185;  % relative direction (deg T) from GPS to ADCP
    nd = adcp.config.n_cells;
    
    % First step is to undo the ship-speed correction we've already done
    ve = squeeze(adcp.vel(:,1,:)) - repmat(adcp.ship_vel_east,nd,1);
    vn = squeeze(adcp.vel(:,2,:)) - repmat(adcp.ship_vel_north,nd,1);

    % Compute the positional offset to apply
    arc = distdim(d0,'meters','degrees','earth'); % arclength of offset (deg); constant
    az = adcp.heading + h0; % azimuthal angle of offset (deg T); varies with heading

    % Compute true ADCP position
    [lat, lon] = reckon(adcp.gps.lat,adcp.gps.lon,arc,az);

    % Compute ADCP velocity from ADCP lat/lon
    [se sn] = nav_ltln2vel(lat,lon,adcp.mtime);
    se = reshape(smooth(se,3,'moving'),1,[]); % smooth a bit
    sn = reshape(smooth(sn,3,'moving'),1,[]);

    ve = ve + repmat(se,nd,1);
    vn = vn + repmat(sn,nd,1);

    adcp.vel(:,1,:) = ve;
    adcp.vel(:,2,:) = vn;
    msg = 'ADCP/GPS positional offset corrected';
    adcp.info = cat(1,adcp.info,msg);
end
