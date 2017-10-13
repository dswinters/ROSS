function [dep, adcp] = asiri_2015_aug_pre_rotation_hook(dep,adcp)
% This function is called before rotation ADCP velocities to earth corodinates.
% Since we don't have any external heading data, we transform the raw heading
% data with a fit:

% Fit info
comps =@(h) [ones(length(h),1) ,...
             sind(h(:))        ,...
             cosd(h(:))        ,...
             sind(2*h(:))      ,...
             cosd(2*h(:))];
fitfmt = '%.1f + %.1fsin(c) + %.1fcos(c) + %.1fsin(2c) + %.1fcos(2c)';
coeffs = [201.8
          31.5
          13.3
          -4.4
          1.0];
fitstr = sprintf(fitfmt,coeffs);

adcp.heading = mod(adcp.heading + [comps(adcp.heading)*coeffs]', 360);
adcp.gps.heading = adcp.heading;

info = {'Heading obtained by calibrating internal ADCP compass to GPS track heading';
        'Heading calibration speed threshold: > 2.5 m/s';
        ['Compass -> heading equation: h = ' fitstr]};
adcp.info = cat(1,adcp.info,info);

