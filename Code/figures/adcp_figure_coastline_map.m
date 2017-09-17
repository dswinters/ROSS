function hfig = adcp_figure_coastline_map(DEP)

%% Load data and coastline map
if strcmp(DEP.files.coastline(end-3:end),'none')
    return
end
adcp = load(DEP.files.processed);
adcp = adcp.adcp;
cl = load(DEP.files.coastline);


%% Create figure, axes, plots
hfig = figure('position',[39 357 738 460],'paperpositionmode','auto');
ax = axes('color',0.3*[1 1 1]);
p = patch(cl.lon,cl.lat,[0.7 0.9 1]); hold on

%% Draw scatter plot of velocities
s = scatter(adcp.gps.lon,adcp.gps.lat,15,adcp.gps.dn);
set(s,'marker','.')

%% Colorbar
cb = colorbar;
ticks = linspace(min(adcp.gps.dn),max(adcp.gps.dn),10);
set(cb,'Ticks',ticks,'TickLabels',datestr(ticks,'mmdd hhMM'))

%% Compute some reasonable x and y limits
if isfield(DEP.plot,'latlim')
    xl = DEP.plot.lonlim;
    yl = DEP.plot.latlim;
else
    % get mean position
    [lt0 ln0] = deal(nanmean(adcp.gps.lat),nanmean(adcp.gps.lon));
    % compute distances
    d = sqrt((adcp.gps.lon - ln0).^2 + (adcp.gps.lat - lt0).^2);
    xl = ln0 + 3*[-1 1]*nanstd(d);
    yl = lt0 + 3*[-1 1]*nanstd(d);
end
xlim(xl);
ylim(yl);

yx = cosd(nanmean(ylim));
grid on
set(ax,'DataAspectRatio',[1 yx 1],...
        'layer','top')
xlabel('Longitude (deg E)')
ylabel('Latitude (deg N)')
