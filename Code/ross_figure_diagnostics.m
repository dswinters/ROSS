function ross_figure_diagnostics(D,config,name,dirout)

adcp = D.adcp;
gps = D.gps;
clear D;

%% Figure layout
plots = [];
nplots = [4, 1];
nplot = 1;

%% Plot titles
titles = {'Location';
          'ROSS Velocity'
          'Currents (ROSS velocity unremoved)';
          'Currents (ROSS velocity removed)'};


%% Plot lat/lon
plots(nplot) = subplot(nplots(1),nplots(2),nplot); nplot=nplot+1;
yyaxis left
plot(gps.dn,gps.lon)
ylabel('Lon (deg E)')

yyaxis right
plot(gps.dn,gps.lat)
ylabel('Lat (deg N)')
grid on


%% Plot ROSS velocity
plots(nplot) = subplot(nplots(1),nplots(2),nplot); nplot=nplot+1;
yyaxis left
plot(gps.dn,gps.vx)
ylabel('East (m/s)')
ylim([-1 1]*4)

yyaxis right
plot(gps.dn,gps.vy)
ylim([-1 1]*4)
ylabel('North (m/s)')
grid on

%% Plot currents before ship speed removal
plots(nplot) = subplot(nplots(1),nplots(2),nplot); nplot=nplot+1;
bins = adcp.config.ranges > 0;
u = nanmean(adcp.earth.east(bins,:));
v = nanmean(adcp.earth.north(bins,:));

nn = isnan(adcp.east_vel.*adcp.north_vel);
adcp.earth.east(nn) = NaN;
adcp.earth.north(nn) = NaN;

yyaxis left
plot(adcp.mtime,u);
ylim([-1 1]*4)
ylabel('East (m/s)')

yyaxis right
plot(adcp.mtime,v);
ylim([-1 1]*4)
ylabel('North (m/s)')
grid on

%% Plot currents after ship speed removal
plots(nplot) = subplot(nplots(1),nplots(2),nplot); nplot=nplot+1;
u = nanmean(adcp.east_vel(bins,:));
v = nanmean(adcp.north_vel(bins,:));

yyaxis left
plot(adcp.mtime,u);
ylim([-1 1]*4)
ylabel('East (m/s)')

yyaxis right
plot(adcp.mtime,v);
ylim([-1 1]*4)
ylabel('North (m/s)')
grid on

%% Set axes limits
linkprop(plots,{'xlim','xtick','xticklabel'});
xlim(adcp.mtime([1 end]))


%% Annotations
for i = 1:length(plots)
    pp = get(plots(i),'position');
    ha = axes('position',pp,'visible','off');
    xlim([-1 1]); ylim([-1 1]);
    text(-1,1,titles{i},...
         'verticalalignment','bottom',...
         'horizontalalignment','left',...
         'fontsize',14,'fontweight','bold')

end

fout = [dirout 'diagnostic.jpg'];
print('-djpeg90','-r300',fout)
disp(['Saved ' fout])
