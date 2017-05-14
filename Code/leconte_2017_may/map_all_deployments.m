clear all, close all
load ../../Metadata/leconte_2017_may.mat;
coast = load('../../Maps/leconte2_grid_coastline.mat');

steller = load('/Volumes/data/20170507_Alaska/data/processed/Steller_GPS/steller_gps.mat');


plot(coast.lon,coast.lat,'-','linewidth',2,'color',0.5*[1 1 1]);
set(gca,'DataAspectRatio',[1 cosd(nanmean(coast.lat)) 1])
xlim([-132.6080 -132.3278])
ylim([56.7137   56.8538])
hold on

p_ste = plot(steller.GPRMC.lon,steller.GPRMC.lat,'.','color',0.7*[1 1 1 1])

lat = []; lon = [];
for i = 1:length(swankie)
    if isfield(swankie(i).files,'final')
        load(swankie(i).files.final);
        for i = 1:length(adcp)
            lat = cat(2,lat,adcp(i).gps.lat);
            lon = cat(2,lon,adcp(i).gps.lon);
        end
    end
end
p_swa = plot(lon,lat,'.');

lat = []; lon = [];
for i = 1:length(rosie)
    if isfield(rosie(i).files,'final')
        load(rosie(i).files.final);
        for i = 1:length(adcp)
            lat = cat(2,lat,adcp(i).gps.lat);
            lon = cat(2,lon,adcp(i).gps.lon);
        end
    end
end
p_ros = plot(lon,lat,'.');

c_ste = get(p_ste,'color');
ph_ste = plot(nan,nan,'linewidth',3,'color',c_ste);
c_swa = get(p_swa,'color');
ph_swa = plot(nan,nan,'linewidth',3,'color',c_swa);
c_ros = get(p_ros,'color');
ph_ros = plot(nan,nan,'linewidth',3,'color',c_ros);


hl = legend([ph_ste ph_swa ph_ros],{'Steller','Swankie','Rosie'});
set(hl,'location','northwest')

