clear all, close all
load redblue
load('../Data/puget_2017_jan/Spanky/raw/ADCP/SPANKY_2017_01_18_2040.mat')

A.config.xducer_misalign = 0;


nmax = 10;

tic
for i = 1:nmax
A1 = adcp_beam2earth(A);
i
end
toc

tic
for i = 1:nmax
A2 = adcp_beam2earth_new(A);
i
end
toc

vscale = 1;

vels = {'east','north','vert','error'};

for i = 1:length(vels)
    disp(sprintf('%s: mean=%.2e, SD=%.2e',vels{i},...
                 nanmean(abs(A1.([vels{i} '_vel'])(:) - A2.([vels{i} '_vel'])(:))),...
                 nanstd(abs(A1.([vels{i} '_vel'])(:) - A2.([vels{i} '_vel'])(:)))));
end

pcolor(A1.vert_vel-A2.vert), shading flat
caxis(0.000000000000000000000001*[-1 1]); colorbar



