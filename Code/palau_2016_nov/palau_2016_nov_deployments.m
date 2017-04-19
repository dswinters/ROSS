function [master,deployments] = ross_palau_2016_nov_deployments(ross);


%%% Trip info
master = struct();
master.name = 'palau_2016_nov';
master.process_data = true;
master.make_figures.summary = true;
master.make_figures.surface_vel = true;
master.make_figures.diagnostics = true;
master.kayaks = {'Ata'};


%% ADCP info
ADCP_300 = struct('freq',300,...
                  'beam_angle',20,...
                  'h0',135,...
                  'unit_dir',1); % 1:towards xducer; -1:away from xducer

%%% Kayak deployment info

%% Kayak 1: Ata
% Deployment defaults
ata0.ADCP = ADCP_300;
ata0.plot.map.pos = [1000 847 548 491];


dep = 1;
ata(dep).name = 'ATA_2016_11_03_0051';
ata(dep).files.map = 'palau.mat';
ata(dep).ADCP = ADCP_300;
ata(dep).tlim = datenum(['03-Nov-2016 00:51:03';
                         '03-Nov-2016 06:12:18']);
ata(dep).files.adcp = {'ROSS4011.000'};
ata(dep).files.gps = {'GPS_20161103004229.log';
                      'GPS_20161103015217.log';
                      'GPS_20161103030237.log';
                      'GPS_20161103041141.log';
                      'GPS_20161103052115.log'};
ata(dep).proc.vel = 'BT';
ata(dep).proc.trim = {'BT'};
ata(dep).plot.ylim = [0 50];
ata(dep).plot.map.pos = [1000 787 658 551];
%-------------------------------------------------------%


dep = 2;
ata(dep).name = 'ATA_2016_11_06_0017';
ata(dep).files.map = 'peleliu.mat';
ata(dep).ADCP = ADCP_300;
ata(dep).tlim = datenum(['06-Nov-2016 00:17:22';
                         '06-Nov-2016 03:18:53']);
ata(dep).files.adcp = {'ROSS4013.000'};
ata(dep).files.gps = {'GPS_20161105234903.log';
                      'GPS_20161106005834.log';
                      'GPS_20161106020801.log';
                      'GPS_20161106031808.log'};
ata(dep).proc.trim = {'BT', 90};
ata(dep).proc.vel = 'GPS'; % Use GPS to remove ship velocity
ata(dep).plot.ylim = [0 100];
%-------------------------------------------------------%


dep = 3;
ata(dep).name = 'ATA_2016_11_06_0352';
ata(dep).files.map = 'peleliu.mat';
ata(dep).ADCP = ADCP_300;
ata(dep).tlim = datenum(['06-Nov-2016 03:52:56';
                         '06-Nov-2016 06:53:25']);
ata(dep).files.adcp = {'ROSS4013.000'};
ata(dep).files.gps = {'GPS_20161106033141.log';
                      'GPS_20161106044153.log';
                      'GPS_20161106055122.log'};
ata(dep).proc.trim = {'BT', 90}; % Trim data below 90m
ata(dep).proc.vel = 'GPS'; % Use GPS to remove ship velocity
ata(dep).proc.bad = {datenum(['06-Nov-2016 05:31:46';
                              '06-Nov-2016 05:50:30'])};
ata(dep).plot.ylim = [0 100];

ata = ross_fill_defaults(ata,ata0);
deployments = {ata};
