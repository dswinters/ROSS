function ross = ross_figure_summary(ross,ndep)

load redblue
dep = ross.deployments(ndep);
dat = load(dep.files.final);
adcp = dat.adcp; clear dat

%% Plot settings
psty = '.'; % plot style
msiz = 1; % plot marker size
axesfontsize = 10;

defaultaxesfontsize = get(0,'defaultaxesfontsize');
set(0,'defaultaxesfontsize',axesfontsize);

%% Initialize figure & axes
figure('position',[758 5 591 823],...
       'paperpositionmode','auto',...
       'inverthardcopy','off');
bgcol = 0.7*[1 1 1];
size_small = 0.33; % height of small panels (relative to full plots)
np_small = 4; % number of small panels (location, ROSS velocity, heading)
np_full = 5; % number of full panels (east/north/vert vel, echo intensity, correlation)
np = np_small + np_full; % total number of panels
vspace = 0.02; % vertical spacing between panels
vpad = [0.03 0.06]; % vertical padding (bottom,top)
hpad = [0.15 0.1]; % horizontal padding (left,right)
cbpad = 0.02; % padding between panels and colorbars
cbw = 0.03; % width of colorbar

% Calculate the height of full panels:
% Height of figure (1) minus combined height of all figure elements,
% divided by number of full panels
ph_full = (1 - (vspace*(np-1) + sum(vpad))) / ...
          (np_full + size_small*np_small);

% Calculate width of panels:
% Width of figure (1) minus combined width of all figure elements
pw = 1 - (sum(hpad) + cbw + cbpad);

% Create a vector of panel heights
ph = ph_full*[size_small*ones(np_small,1); ones(np_full,1)];
% Create an array of panel positions:
% [left1 bottom1 width1 height1;
%  left2 bottom2 width2 height2;
%          ...
pp = nan(np,4);
ax = [];
ax2 = [];
for i = 1:np
    pp(i,1) = hpad(1); % position of left
    pp(i,2) = 1 - (vpad(2) + sum(ph(1:i)) + (i-1)*vspace); % position of bottom
    pp(i,3) = pw; % panel width
    pp(i,4) = ph(i); % panel height
    ax(i) = axes('position',pp(i,:));
end

%% Set plot info
titles = {'ROSS Location (deg E/N)';
          'ROSS Velocity (ms^{-1} E/N)';
          'ROSS Heading (degrees)'
          'ADCP Pitch & Roll (degrees)'
          'East-West Currents (ms^{-1} East)';
          'North-South Currents (ms^{-1} North)';
          'Vertical Currents (ms^{-1} up)';
          'Echo Intensity (counts)';
          'Correlation (counts)'};
ylabs = {{'lon','lat'};
         {'v_{EW}','v_{NS}'};
         'heading'
         {'pitch','roll'}
         'depth (m)';
         'depth (m)'
         'depth (m)'
         'depth (m)'
         'depth (m)'};
cmaps = {nan,nan,nan,nan,'sym','sym','sym','lin','lin'};
clims = {nan;
         nan;
         nan;
         nan;
         1*[-1 1]; % East-West velocity (m/s)
         1*[-1 1]; % North-South velocity (m/s)
         1*[-1 1]; % Vertical velocity (m/s)
         nan;      % Echo intensity (counts)
         nan};     % Correlation (counts)

for ia = 1:length(adcp)
    adcp(ia).gps_lon = adcp(ia).gps.lon;
    adcp(ia).gps_lat = adcp(ia).gps.lat;
    adcp(ia).gps_vx  = adcp(ia).gps.vx;
    adcp(ia).gps_vy  = adcp(ia).gps.vy;
end


plotfuns = {{@(adcp) adcplot(adcp,'gps_lon',psty,msiz);
             @(adcp) adcplot(adcp,'gps_lat',psty,msiz)};
            {@(adcp) adcplot(adcp,'gps_vx',psty,msiz);
             @(adcp) adcplot(adcp,'gps_vy',psty,msiz)};
            @(adcp) adcplot(adcp,'heading',psty,msiz);
            {@(adcp) adcplot(adcp,'pitch',psty,msiz);
             @(adcp) adcplot(adcp,'roll',psty,msiz)};
            @(adcp) adcpcolor(adcp,'vel',1);
            @(adcp) adcpcolor(adcp,'vel',2);
            @(adcp) adcpcolor(adcp,'vel',3);
            @(adcp) adcpcolor(adcp,'intens',[1:adcp(1).config.n_beams]);
            @(adcp) adcpcolor(adcp,'corr',[1:adcp(1).config.n_beams])};
plotdims = [1,1,1,1,2,2,2,2,2];
ross_vel_scale = 3.5;

%% Make plots
for i = 1:np
    %% Plot data
    axes(ax(i)) % Switch to correct axes
    if iscell(plotfuns{i}) % Plotting left & right axes
        % Left axis
        yyaxis left
        plotfuns{i}{1}(adcp);
        ylabel(ylabs{i}{1})
        % Right axis
        yyaxis right
        plotfuns{i}{2}(adcp);
        ylabel(ylabs{i}{2})
    else % Plotting single axes
        plotfuns{i}(adcp);
        if plotdims(i) == 2
            ylim(dep.plot.ylim)
            set(gca,'ydir','reverse')
        end
        ylabel(ylabs{i})
    end
    %% Apply colormaps and color axis limits
    if ~isnan(cmaps{i})
        if ~isnan(clims{i})
            clim = clims{i};
        else
            clim = caxis;
        end
        cbp = [sum(pp(i,[1 3])) + cbpad, pp(i,2), cbw, ph(i)];
        hcb = colorbar('position',cbp);
        caxis(clim);
        switch cmaps{i}
          case 'sym'
            colormap(ax(i),redblue)
            colormap(hcb,redblue)
          case 'lin'
            colormap(ax(i),hot)
            colormap(hcb,hot)
        end
        set(ax(i),'color',bgcol);
    end
end

%% Format plots
t = sort(cat(2,adcp(:).mtime));
% XTicks
axes(ax(end))
datetick('keeplimits')
set(ax(1:end-1),'xticklabel',[])
set(ax,'xlim',t([1 end]))
% ROSS velocity
axes(ax(2))
yyaxis left
ylim(ross_vel_scale*[-1 1]);
yyaxis right
ylim(ross_vel_scale*[-1 1]);
% ROSS heading
axes(ax(3))
ylim([0 360])
set(gca,'ytick',0:180:360)
% Grid markers for ROSS location, velocity, and heading
for i = 1:4
    axes(ax(i))
    grid on
end
% Panel titles
ha_full = axes('position',[0 0 1 1],'visible','off');
xlim([0 1]);
ylim([0 1]);
for i = 1:np
    tx = pp(i,1);
    ty = sum(pp(i,[2 4]));
    text(tx,ty,titles{i},...
         'horizontalalignment','left',...
         'verticalalignment','bottom',...
         'fontweight','bold');
end

% Figure title
axes(ha_full);
ttext = sprintf('%s to %s',datestr(min(t)),datestr(max(t)));
text(0.5,1,{dep.name;ttext},'fontsize',14,...
     'fontweight','bold',...
     'verticalalignment','top',...
     'horizontalalignment','center',...
     'interpreter','none');

%% Save figure
fout = [dep.fig_dir 'summary.jpg'];
print('-djpeg90','-r300',fout)
disp(['[[' fout ']]'])

%% Restore defaults
set(0,'defaultaxesfontsize',defaultaxesfontsize);

%% Functions

function pl = adcplot(adcp,varname,psty,msiz);
dn = cat(2,adcp.mtime);
v = cat(2,adcp.(varname));
[dn,idx] = sort(dn);
v = v(idx);
pl = plot(dn,v,psty,'markersize',msiz);

