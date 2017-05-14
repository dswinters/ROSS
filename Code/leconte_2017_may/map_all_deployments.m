clear all, close all
load ../../Metadata/leconte_2017_may.mat;
coast = load('../../Maps/leconte2_grid_coastline.mat');


plot(coast.lon,coast.lat,'-','linewidth',2,'color',0.5*[1 1 1]);
set(gca,'DataAspectRatio',[1 cosd(nanmean(coast.lat)) 1])
xlim([-132.6080 -132.3278])
ylim([56.7137   56.8538])

hold on

for i = 1:length(swankie)
    if isfield(swankie(i).files,'final')
        load(swankie(i).files.final);
        lat = []; lon = [];
        for i = 1:length(adcp)
            lat = cat(2,lat,adcp(i).gps.lat);
            lon = cat(2,lon,adcp(i).gps.lon);
        end
        plot(lon,lat,'.')
    end
end

for i = 1:length(rosie)
    if isfield(rosie(i).files,'final')
        load(rosie(i).files.final);
        lat = []; lon = [];
        for i = 1:length(adcp)
            lat = cat(2,lat,adcp(i).gps.lat);
            lon = cat(2,lon,adcp(i).gps.lon);
        end
        plot(lon,lat,'.')
    end
end




