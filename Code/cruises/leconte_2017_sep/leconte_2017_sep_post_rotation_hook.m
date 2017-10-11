function [DEP, adcp] = leconte_2017_sep_post_rotation_hook(DEP,adcp)

return




switch DEP.vessel.name
  case 'Steller'
    disp('Correcting Steller "wag"...')
    %% Correct for "wag"
    % Since the external heading source is mounted at an offset from the ADCP,
    % rotations about the heading source translate to lateral sensor motion.

    d = -0.9 - 12.6i; % ADCP/Hemisphere separation

    % Load GPS data to calculate rate of turn
    gps = load_gps(DEP);
    rot = interp1(gps.dn(1:end-1)/2 + gps.dn(2:end)/2,...
                  diff(gps.h)./diff(gps.dn)/86400,...
                  gps.dn);
    idx = abs(rot)>3;
    rot(idx) = interp1(gps.dn(~idx),rot(~idx),gps.dn(idx));
    rot = interp1(gps.dn,rot,adcp.mtime);

    % Caclulate rotation-induced translation at ADCP
    %               heading  *     components   *   radial velocity
    rotvel = exp(1i*deg2rad(90-h)) * d/abs(d) * 2*pi*abs(d) * rot/360;
    v = squeeze(adcp.vel(:,1,:)) + 1i*squeeze(adcp.vel(:,2,:));
    v = v + repmat(rotvel,adcp.config.n_cells,1);

    % % Rotate to ship coords by removing heading
    % v = v .*  repmat(exp(1i*deg2rad(adcp.heading + 8.5)),adcp.config.n_cells,1);
    
    % % Remove wag
    % v = v + repmat(rot*wag_coeff,adcp.config.n_cells,1);
    
    % % Rotate back to earth coords by adding heading
    % v = v .*  repmat(exp(-1i*deg2rad(adcp.heading + 8.5)),adcp.config.n_cells,1);

    % Store new velocities in ADCP struct

    adcp.vel(:,1,:) = real(v);
    adcp.vel(:,2,:) = imag(v);
end

