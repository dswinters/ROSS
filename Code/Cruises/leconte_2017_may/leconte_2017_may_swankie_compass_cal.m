clear all, close all
load ../../Metadata/leconte_2017_may.mat
figure('position',[440 279 648 519])

t = [];
ht = [];
hc = [];
vx = [];
vy = [];

for i = 1:length(swankie)
    if isfield(swankie(i).files,'final')
        load(swankie(i).files.final);
        for i = 1:length(adcp)
            t  = cat(2,t,adcp(i).mtime);
            vx = cat(2,vx,adcp(i).gps.vx);
            vy = cat(2,vy,adcp(i).gps.vy);
            ht = cat(2,ht,adcp(i).heading);
            hc = cat(2,hc,adcp(i).heading_compass);
        end
    end
end


[~,idx] = unique(ht);
t  = t(idx);
ht = ht(idx);
hc = hc(idx);
vx = vx(idx);
vy = vy(idx);
[~,idx] = sort(ht);
t  = t(idx);
ht = ht(idx);
hc = hc(idx);
vx = vx(idx);
vy = vy(idx);

% hc = ht + bias
% bias = hc - ht;
hb = hc - ht;
hb(hb>180)  = hb(hb>180) - 360;
hb(hb<-180) = hb(hb<-180) + 360;

pax = polaraxes();
polarplot(deg2rad(ht),hb,'.'), hold on
rlim([-50 100]);

X=@(h) [ones(length(h),1) ,...
        sind(h(:))        ,...
        cosd(h(:))        ,...
        ];
C = X(ht(~isnan(hb))) \ hb(~isnan(hb))';
F = @(C,h) [X(h(:))*C]';

% ign = hb>(F(C,ht)+25) | hb<(F(C,ht)-25);
ign = sqrt(sum([vx;vy].^2)) < 1;
polarplot(deg2rad(ht(ign)),hb(ign),'.','color',[1 1 1]*0.7)
hb(ign) = nan;
C = X(ht(~isnan(hb))) \ hb(~isnan(hb))';

plot_bf = polarplot(deg2rad(ht),F(C,ht),'r-','linewidth',2);
grid on
title('Swankie Sentinel V Heading Bias')

set(pax,'rtick',[-50:15:100],...
        'layer','top',...
        'gridcolor',[1 1 1]*0,...
        'gridalpha',0.7)

hax = axes('visible','off',...
           'position',[0 0 1 1]);
xlim([0 1]); ylim([0 1])
hplot_bf = plot(nan,nan,'r-','linewidth',2);
hl = legend(hplot_bf,'c_0 + c_1sin(h) + c_2cos(h)');
set(hl,'location','northeast')
txt = {};
for i = 1:length(C)
    txt{i} = sprintf('c_%d = %.5f',i-1,C(i));
end
text(0.97,0.88,txt,...
     'verticalalignment','middle',...
     'horizontalalignment','right');
set(hax,'visible','off')

dirs_out = {'/Users/dylan/OSU/ROSS/Figures/leconte_2017_may/Swankie/';
            '/Volumes/data/20170507_Alaska/figures/ROSS/Swankie/'};
fname = 'swankie_sentinelV_heading_bias.jpg';
for i = 1:length(dirs_out)
    if exist(dirs_out{i},'dir')
        f_out = fullfile(dirs_out{i},fname);
        print('-djpeg90','-r300',f_out)
        disp(['Saved ' f_out])
    end
end

% sort by time
[~,idx] = sort(t);
t  = t(idx);
ht = ht(idx);
hc = hc(idx);
vx = vx(idx);
vy = vy(idx);
dt = diff(t)*86400;


% Apply heading correction
hc = hc - F(C,ht);
dhc = diff(hc);
dhc(dhc>180) = dhc(dhc>180) - 360;
dhc(dhc<-180) = dhc(dhc<-180) + 360;
crot = dhc./dt;
crot(abs(crot)>20) = nan;

dht = diff(ht);
dht(dht>180) = dht(dht>180) - 360;
dht(dht<-180) = dht(dht<-180) + 360;
trot = dht./dt;
trot(abs(trot)>20) = nan;

t2 = t(1:end-1) + diff(t)/2;

cs = crot;
for i = 1:5
    cs = nanmean([cs([1,1:end-1]);cs;cs([2:end,end])]);
end


figure()
plot(t2,cs), hold on
plot(t2,trot)
% xx = datenum(['11-May-2017 18:01:39';
%               '11-May-2017 18:22:35';]);
xlim(xx)
title([datestr(nanmean(xlim),1) ' ' datestr(nanmean(xlim),15)]);
ylabel('RoT (deg/s)')
xlabel('Time UTC')
hl = legend('Internal Compass','Hemisphere');
set(hl,'location','northeastoutside')


print('-djpeg90','-r300','~/Desktop/swankie_heading.jpg')