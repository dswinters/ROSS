function [DEP, adcp] = leconte_2017_sep_post_rotation_hook(DEP,adcp)

switch DEP.vessel.name
  case 'Steller'
    disp('Correcting Steller "wag"...')
    %% Correct for "wag"
    % Since the external heading source is mounted at an offset from the ADCP,
    % rotations about the heading source translate to lateral sensor motion.

    % wag_coeff = 0; % no correction
    % wag_coeff = 0.0634; % (m/s)/(deg/s), measured
    wag_coeff = 0.21; % (m/s)/(deg/s), estimated

    % Load GPS data to calculate rate of turn
    gps = load_gps(DEP);
    rot = interp1(gps.dn(1:end-1)/2 + gps.dn(2:end)/2,...
                  diff(gps.h)./diff(gps.dn)/86400,...
                  gps.dn);
    idx = abs(rot)>3;
    rot(idx) = interp1(gps.dn(~idx),rot(~idx),gps.dn(idx));
    rot = interp1(gps.dn,rot,adcp.mtime);

    % Rotate to ship coords by removing heading
    v = squeeze(adcp.vel(:,1,:)) + 1i*squeeze(adcp.vel(:,2,:));
    v = v .*  repmat(exp(1i*deg2rad(adcp.heading + 8.5)),adcp.config.n_cells,1);
    
    % Remove wag
    v = v + repmat(rot*wag_coeff,adcp.config.n_cells,1);
    
    % Rotate back to earth coords by adding heading
    v = v .*  repmat(exp(-1i*deg2rad(adcp.heading + 8.5)),adcp.config.n_cells,1);

    % Store new velocities in ADCP struct
    adcp.vel(:,1,:) = real(v);
    adcp.vel(:,2,:) = imag(v);
end
