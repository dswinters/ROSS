function ross = ross_figure_surface_vel(ross,ndep)

dep = ross.deployments(ndep);
dat = load(dep.files.final);
adcp = dat.adcp; clear dat;

dmax = 20;
nx = 75; ny = 75;

map = load(dep.files.map);

%% Create the background image
if isfield(dep,'plot') && isfield(dep.plot,'map')
    pos = dep.plot.map.pos;
else
    pos = [963 708 723 630];
end
figure('position',pos,'paperpositionmode','auto')
ha_map = axes();
m = mapshow(map.x,map.y,map.I); hold on

xlim(map.x([1 end]))
ylim(map.y([1 end]))
daspect([size(map,2)/size(map,1),1, 1]);
xlabel(sprintf('Longitude (%cE)',char(176)))
ylabel(sprintf('Latitude (%cN)',char(176)))

% Define spatial bin edges
xl = xlim;
yl = ylim;
xbe = linspace(xl(1),xl(2),nx+1);
ybe = linspace(yl(1),yl(2),ny+1); 

% Initialize sparse matrices
vx = sparse(zeros(ny,nx));
vy = sparse(zeros(ny,nx));
counts = sparse(zeros(ny,nx));

for ia = 1:length(adcp)
    x = adcp(ia).gps.lon;
    y = adcp(ia).gps.lat;

    % keep bins shallower than dmax
    adcp_bins = adcp(ia).config.ranges<dmax;
    % convert (x,y) coords to bin coords
    [~,xb] = histc(x,xbe);
    [~,yb] = histc(y,ybe);
    % only keep data within our bin limits
    kp = xb>0 & yb>0;

    % increment data count and velocity sparse matrices
    counts = counts + sparse(yb(kp),xb(kp),1,ny,nx);
    vx = vx + sparse(yb(kp),xb(kp),...
                     nanmean(squeeze(adcp(ia).vel(adcp_bins,1,kp))),ny,nx);
    vy = vy + sparse(yb(kp),xb(kp),...
                     nanmean(squeeze(adcp(ia).vel(adcp_bins,2,kp))),ny,nx);

end

% convert sparse matrices to matrices
counts = full(counts);
vx = full(vx)./counts;
vy = full(vy)./counts;
vx(counts==0) = NaN;
vy(counts==0) = NaN;
% pad matrices to match desired grid size
npad = [ny nx] - size(vx);
vx = padarray(vx,npad,nan,'post');
vy = padarray(vy,npad,nan,'post');
% compute cell centers for quiver plot
[xc yc] = meshgrid(xbe(1:end-1) + diff(xbe)/2,...
                   ybe(1:end-1) + diff(ybe)/2);
[xbe ybe] = meshgrid(xbe,ybe);
% compute velocity magnitude
mag = sqrt(vx.^2 + vy.^2);




%% Show current speeds as a sparse pcolor
pcolor(xbe,ybe,padarray(mag,[1 1],nan,'post'))
caxis([0 2.5])
shading flat
cb = colorbar;

%% Show current directions as a quiver plot
q = quiver(xc(:),yc(:),vx(:)./mag(:),vy(:)./mag(:),2);
set(q,'color','w')


%% Annotations
ha = axes('position',[0 0 1 1],...
          'visible','off');
xlim([-1 1]); ylim([-1 1])
text(0,1,...
     {dep.name;
      sprintf('Surface Velocity (depth < %.1fm)',dmax)},...
     'fontsize',18,'fontweight','bold',...
     'verticalalignment','top',...
     'horizontalalignment','center',...
     'interpreter','none');

text(0,-1,sprintf('%s to %s',...
                  datestr(min(cat(2,adcp.mtime))),...
                  datestr(max(cat(2,adcp.mtime)))),...
     'fontsize',14,'fontweight','bold',...
     'verticalalignment','bottom',...
     'horizontalalignment','center');

axes('position',get(cb,'position').*[1 1 2.5 1],...
     'visible','off');
xlim([-1 1]); ylim([-1 1]);
text(2,0,'Current Speed (ms^{-1})',...
     'fontsize',get(0,'defaultaxesfontsize'),...
     'rotation',-90,...
     'horizontalalignment','center',...
     'verticalalignment','top')

% rescale
yx = cosd(nanmean(map.y));
set(ha_map,'DataAspectRatio',[1 yx 1])

fout = [dep.fig_dir, 'surface_vel.jpg'];
print('-djpeg90','-r300',fout)
fparts = strsplit(fout,'/');
flink = fullfile('..',fparts{6:end});
disp(['[[' flink ']]'])
