clear all, close all
adcp = load('../Data/puget_2017_jan/Spanky/processed/SPANKY_2017_01_19_1228.mat');

bnum = 4;

figure('position',[643 503 1027 671],'paperpositionmode','auto',...
       'inverthardcopy','off')

ei = squeeze(adcp.intens(:,bnum,:));
d = adcp.config.ranges;
t = adcp.mtime;

bt_mask = false(size(adcp.east_vel));
for i = 1:4
    edges = edge(squeeze(adcp.intens(:,i,:)),'Sobel','horizontal');
    bt_mask = bt_mask | (cumsum(edges) > 0);
end

bw = edge(ei,'Sobel','horizontal');
mask = (cumsum(bw)>0);

plots = [];
nplots = [4, 1];
nplot = 1;

plots(nplot) = subplot(nplots(1),nplots(2),nplot); nplot=nplot+1;
pcolor(t,d,ei), shading flat
cb = colorbar;
colormap(gca,hot)
ylabel('depth (m)')
axis ij

plots(nplot) = subplot(nplots(1),nplots(2),nplot); nplot=nplot+1;
pcolor(t,d,+bw),  shading flat
cb = colorbar;
cb.Ticks = [0 1];
colormap(gca,[0 0 0; 1 1 1])
ylabel('depth (m)')
axis ij


plots(nplot) = subplot(nplots(1),nplots(2),nplot); nplot=nplot+1;
pcolor(t,d,+mask), shading flat
cb = colorbar;
cb.Ticks = [0 1];
colormap(gca,[0 0 0; 1 1 1])
ylabel('depth (m)')
axis ij

% ei(bt_mask) = NaN;
ei(mask) = NaN;
plots(nplot) = subplot(nplots(1),nplots(2),nplot); nplot=nplot+1;
pcolor(t,d,ei), shading flat
cb = colorbar;
colormap(gca,hot)
ylabel('depth (m)')
axis ij
xlabel('Time (UTC)')

linkprop(plots,{'xlim','xtick','xgrid','ygrid'});
datetick('keeplimits')
set(plots(1:end-1),'xticklabel',[])
set(plots,'color',0.7*[1 1 1])

titles= {sprintf('Beam %d Echo Intensity (counts)',bnum);
         'Vertical Sobel Edge Detection';
         'Mask';
         'Masked Beam 1 Echo Intensity (counts)'};

texts = {'';
         'edges = edge(beam1_intens,''Sobel'',''vertical'')';
         'mask = cumsum(edges)>0';
         'beam1_intens(mask) = NaN'};


for i = 1:length(plots)
    pp = get(plots(i),'position');
    axes('position',pp,'visible','off');
    xlim([0 1])
    ylim([0 1])
    text(0,1,titles{i},'fontsize',14,...
         'fontweight','bold',...
         'verticalalignment','bottom',...
         'horizontalalignment','left');
    text(1,1,texts{i},'fontsize',14,...
         'fontname','Courier New',...
         'verticalalignment','bottom',...
         'horizontalalignment','right',...
         'interpreter','none');

    
end


print('-djpeg90','-r300','~/Desktop/edge_detection.jpg')