function [dep, adcp] = asiri_2015_aug_pre_rotation_hook(dep,adcp)

%% Apply compass calibration for true heading
comps =@(h) [ones(length(h),1) ,...
             sind(h(:))        ,...
             cosd(h(:))        ,...
             sind(2*h(:))      ,...
             cosd(2*h(:))];
fitfmt = 'c + %.1f + %.1fsin(c) + %.1fcos(c) + %.1fsin(2c) + %.1fcos(2c)';
coeffs = [161.7383; -31.7958; -16.7760; 1.3896; 2.9322];
fitstr = sprintf(fitfmt,coeffs);

adcp.heading = mod(adcp.heading_internal + [comps(adcp.heading_internal)*coeffs]', 360);
% adcp.gps.h = adcp.heading;

info = {'Heading obtained by calibrating internal ADCP compass to GPS track heading';
        'Heading calibration speed threshold: > 2.5 m/s';
        ['Compass -> heading equation: h = ' fitstr]};
adcp.info = cat(1,adcp.info,info);


%% Remove data with poor correlation
adcp.vel(adcp.corr<40) = NaN;
adcp.info = cat(1,adcp.info,{'Beam data removed where correlation magnitude < 40'});
