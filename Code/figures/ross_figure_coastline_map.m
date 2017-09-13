function [ross hfig] = ross_figure_coastline_map(ross,ndep)

dep = ross.deployments(ndep);
if strcmp(dep.files.coastline(end-3:end),'none')
    return
end
dat = load(dep.files.final);
cl = load(dep.files.coastline);
adcp = dat.adcp; clear dat

hfig = figure('position',[39 357 738 460],'paperpositionmode','auto');

ax = axes('color',0.3*[1 1 1]);
p = patch(cl.lon,cl.lat,[0.7 0.9 1]); hold on
s = scatter(adcp.gps.lon,adcp.gps.lat,15,adcp.gps.dn)
set(s,'marker','.')
plot(adcp.gps.lon,adcp.gps.lat,'color',[0 0 0 0.5])

cb = colorbar;
ticks = linspace(adcp.gps.dn(1),adcp.gps.dn(end),10);
set(cb,'Ticks',ticks,'TickLabels',datestr(ticks,'mmdd hhMM'))

yx = cosd(nanmean(ylim));
grid on
set(ax,'DataAspectRatio',[1 yx 1],...
        'layer','top')
xlabel('Longitude (deg E)')
ylabel('Latitude (deg N)')

