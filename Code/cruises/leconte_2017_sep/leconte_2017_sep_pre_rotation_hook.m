function [DEP, adcp] = leconte_2017_sep_pre_rotation_hook(DEP,adcp)

switch DEP.vessel.name
  case 'Swankie'
    return % skip this for now...
    switch DEP.name(1:34)
        % These are the deployments with GPS smoothing enabled:
        case {'swankie_deployment_20170914_204159',...
              'swankie_deployment_20170916_002146'};
          %% apply compass calibration
          comps =@(h) [ones(length(h),1) ,...
                       sind(h(:))        ,...
                       cosd(h(:))        ,...
                       sind(2*h(:))      ,...
                       cosd(2*h(:))];
          fitfmt = 'c + %.1f + %.1fsin(c) + %.1fcos(c) + %.1fsin(2c) + %.1fcos(2c)';
          coeffs = [-24.2691; -12.9985; -7.1676; 1.5897; -1.3088];
          fitstr = sprintf(fitfmt,coeffs);

          h_int = adcp.heading_internal;

          adcp.heading = mod(h_int + [comps(h_int)*coeffs]', 360);
          % adcp.gps.h = adcp.heading;
          info = {'Heading obtained by calibrating internal ADCP compass to GPS track heading';
                  'Heading calibration speed threshold: > 1.5 m/s';
                  ['Compass -> heading equation: h = ' fitstr]};
          adcp.info = cat(1,adcp.info,info);
    end
end

