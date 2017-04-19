function [ross adcp] = ross_proc_gps(ross,ndep,adcp,gps)

D = ross.deployments(ndep);

dn  = adcp.mtime;
lat = interp1(gps.dn,gps.lat,dn);
lon = interp1(gps.dn,gps.lon,dn);
h   = nav_interp_heading(gps.dn,gps.h,dn);
vx  = interp1(gps.dn,gps.vx,dn);
vy  = interp1(gps.dn,gps.vy,dn);

%% Attempt to fill gaps in GPS data from pixhawk
if isfield(D.proc,'pixhawk')
    if checkfield(D.proc.pixhawk,'enable')
        pixhawk                 = ross_load_pixhawk(ross);
        pixhawk.dn              = pixhawk.dn + D.proc.pixhawk.offset;
        pixhawk.heading         = nav_ltln2head(pixhawk.lat,pixhawk.lon,pixhawk.dn);
        [pixhawk.vx pixhawk.vy] = nav_ltln2vel(pixhawk.lat,pixhawk.lon,pixhawk.dn);

        [~,idx] = unique(pixhawk.dn);
        lat2    = interp1(pixhawk.dn(idx),pixhawk.lat(idx),dn);
        lon2    = interp1(pixhawk.dn(idx),pixhawk.lon(idx),dn);
        h2      = interph(pixhawk.dn(idx),pixhawk.heading(idx),dn);
        vx2     = interp1(pixhawk.dn(idx),pixhawk.vx(idx),dn);
        vy2     = interp1(pixhawk.dn(idx),pixhawk.vy(idx),dn);

        % Fill in gaps with pixhawk data
        nn     = ~isnan(vx.*vy.*lat.*lon.*h);
        dngood = [dn(1) dn(nn)];
        maxgap = 5;
        idx    = find(diff(dngood)*86400 > maxgap);
        for i = 1:length(idx)
            gap      = dn >= dngood(idx(i)) & dn<= dngood(idx(i)+1);
            lat(gap) = lat2(gap);
            lon(gap) = lon2(gap);
            vx(gap)  = vx2(gap);
            vy(gap)  = vy2(gap);
            h(gap)   = h2(gap);
        end
    else
        % Otherwise remove data to avoid interpolating over gaps
        nn     = ~isnan(gps.vx.*gps.vy.*gps.lat.*gps.lon.*gps.h);
        dngood = [dn(1);gps.dn(nn)];
        maxgap = 5;
        idx    = find(diff(dngood)*86400 > maxgap);
        for i = 1:length(idx)
            gap      = dn >= dngood(idx(i)) & dn<= dngood(idx(i)+1);
            lat(gap) = nan;
            lon(gap) = nan;
            vx(gap)  = nan;
            vy(gap)  = nan;
            h(gap)   = nan;
        end
    end
end

adcp.gps = struct(...
                 'dn' , dn  ,...
                 'lat', lat ,...
                 'lon', lon ,...
                 'h'  , h   ,...
                 'vx' , vx  ,...
                 'vy' , vy) ;


