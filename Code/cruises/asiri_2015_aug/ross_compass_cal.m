clear all, close all;

force_reload = false;
cdir = pwd;
cd ../../
config = config_setup('asiri_2015_aug');
cd(cdir);

if force_reload | ~exist('compass_cal_info.mat','file')
    lat = [];
    lon = [];
    h = [];
    dn = [];
    dep = [];

    for i = 1:length(config.deployment)
        load(config.deployment(i).files.processed);
        disp(['Loaded ' config.deployment(i).files.processed])
        dn = cat(2,dn,adcp.mtime);
        lat = cat(2,lat,adcp.gps.lat);
        lon = cat(2,lon,adcp.gps.lon);
        h = cat(2,h,adcp.heading_internal);
        dep = cat(2,dep,zeros(size(adcp.mtime))+i);
    end
    save compass_cal_info.mat dn lat lon h dep
else
    load compass_cal_info.mat dn lat lon h dep
end

[ve vn] = nav_ltln2vel(lat,lon,dn);
[ht,spd] = cart2pol(ve,vn);
ht = rad2degt(ht);

hd = mod(h-ht,360);

figure('position',[376 419 590 504],'paperpositionmode','auto')

% s = scatter(h,hd,5,spd); hold on
s = polarscatter(deg2rad(h),hd,5,spd); hold on
set(s,'marker','.')
colorbar
caxis([0 2.5])
cmap = parula(50);
cmap(end,:) = [1 0 0];
fast = spd>=2.5;
% plot(h(fast),hd(fast),'r.')
polarplot(deg2rad(h(fast)),hd(fast),'r.');
colormap(cmap)

hd(spd<2.5) = nan;

% bin-average in 5 deg increments
hb = 0:5:360;
[~,bn] = histc(h,hb);
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
rlim([0 360]);
thetalim([0 360]);
title({'Track Heading vs. ADCP Compass Heading (deg T)';
       'points colored by ROSS speed (m/s)'})
fitstr = '%.1f + %.1fsin(c) + %.1fcos(c) + %.1fsin(2c) + %.1fcos(2c)';
fitstr = sprintf(fitstr,coeffs);
hl = legend(hfit,fitstr);
set(hl,'position',[0.25 0.01 0.5 0.03],'box','off',...
       'fontsize',14)

print('-djpeg90','-r300','ross_compass_cal.jpg')
