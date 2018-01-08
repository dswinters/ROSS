clear all, close all;

force_reload = true;
cdir = pwd;
cd ../../
config = config_setup('asiri_2015_aug');
cd(cdir);

spd_thresh = 2.2;

if force_reload | ~exist('compass_cal_info.mat','file')
    LAT = [];
    LON = [];
    h = [];
    HT = [];
    dn = [];
    dep = [];
    for i = 3:6
        cd ../../
        adcp = load_adcp(config.deployment(i));
        cd(cdir)
        dn = cat(2,dn,adcp.mtime);
        h = cat(2,h,adcp.heading_internal);
        dep = cat(2,dep,zeros(size(adcp.mtime))+i);

        gps = load(config.deployment(i).files.gps_mat);
        [ve vn] = nav_ltln2vel(gps.GPRMC.lat,gps.GPRMC.lon,gps.GPRMC.dn);

        th = cart2pol(ve,vn);
        ht = rad2degt(th);
        ht = cosd(ht) + 1i*sind(ht);
        [~,iu] = unique(gps.GPRMC.dn);
        ht = interp1(gps.GPRMC.dn(iu),ht(iu),adcp.mtime);
        ht = mod(180/pi*angle(ht),360);
        HT = cat(2,HT,ht);

        lat = interp1(gps.GPRMC.dn(iu),gps.GPRMC.lat(iu),adcp.mtime);
        lon = interp1(gps.GPRMC.dn(iu),gps.GPRMC.lon(iu),adcp.mtime);
        LAT = cat(2,LAT,lat);
        LON = cat(2,LON,lon);

    end
    ht = HT;
    lat = LAT;
    lon = LON;
    save compass_cal_info.mat dn lat lon h ht dep
else
    load compass_cal_info.mat dn lat lon h ht dep
end

[ve vn] = nav_ltln2vel(lat,lon,dn);
[~,spd] = cart2pol(ve,vn);

hd = ht-h;
hd(hd>180) = hd(hd>180)-360;
hd(hd<-180) = hd(hd<-180)+360;


figure('position',[376 419 590 504],'paperpositionmode','auto')

% s = scatter(h,hd,5,spd); hold on
s = polarscatter(deg2rad(ht),hd,5,spd); hold on
set(s,'marker','.')
colorbar
caxis([0 spd_thresh])
cmap = parula(50);
cmap(end,:) = [1 0 0];
fast = spd>=spd_thresh;
% plot(h(fast),hd(fast),'r.')
polarplot(deg2rad(ht(fast)),hd(fast),'r.');
colormap(cmap)

hd(spd<spd_thresh) = nan;

% bin-average in 5 deg increments
hb = 0:5:360;
[~,bn] = histc(ht,hb);
counts = full(sparse(1,bn(bn>0&~isnan(hd)),1));
counts(counts<30) = nan;
hdb = full(sparse(1,bn(bn>0&~isnan(hd)),hd(bn>0&~isnan(hd)))) ./ counts;
hb = nanmean([hb(1:end-1);hb(2:end)]);

%% make a fit using bin-averaged data
% define dependent variables
X=@(h) [ones(length(h),1) ,...
        sind(h(:))        ,...
        cosd(h(:))        ,...
        sind(2*h(:))      ,...
        cosd(2*h(:))];
% compute coefficients
coeffs = X(hb(~isnan(hdb))) \ hdb(~isnan(hdb))';
% create fit as a function of compass heading and coeffs
func = @(C,h) X(h(:))*C;
% plot fit
hfit = polarplot(deg2rad(0:360),func(coeffs,0:360),'k-','linewidth',2);

%% annotate figure
pax = gca;
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top';
rlim([-180 180]);
thetalim([0 360]);
title({'Track Heading - ADCP Compass Heading vs. Track Heading (deg T)';
       'points colored by ROSS speed (m/s)'})
fitstr = '%.1f + %.1fsin(c) + %.1fcos(c) + %.1fsin(2c) + %.1fcos(2c)';
fitstr = sprintf(fitstr,coeffs);
hl = legend(hfit,fitstr);
set(hl,'position',[0.25 0.01 0.5 0.03],'box','off',...
       'fontsize',14)

print('-djpeg90','-r300','ross_compass_cal.jpg')

