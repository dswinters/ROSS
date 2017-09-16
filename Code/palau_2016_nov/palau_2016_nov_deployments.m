function [master,deployments] = palau_2016_nov_deployments(ross);


%%% Trip info
master = struct();
master.name = 'palau_2016_nov';
master.process_data = true;
master.make_figures.summary = true;
master.make_figures.surface_vel = true;
master.kayaks = {'Ata'};


%%% Kayak deployment info

%% Kayak 1: Ata
% Deployment defaults
bt90 = struct('name','BT','params',90);
co90 = struct('name','cutoff','params',90);
corrflt = struct('name','corrmin','params',50);
rotmax = struct('name','rotmax','params',3);
ata0.plot.map.pos = [1000 847 548 491];
ata0.proc.heading_offset = 135;
ata0.proc.adcp_load_func = 'adcp_parse';
ata0.proc.filters(1) = corrflt;
% ata0.proc.filters(2) = rotmax;

%-------------------------------------------------------%
dep                            = 1;
ata(dep).name                  = 'ATA_2016_11_03_0051';
ata(dep).files.map             = 'palau.mat';
ata(dep).tlim                  = datenum(...
    ['03-Nov-2016 00:51:03';
     '03-Nov-2016 06:12:18']);
ata(dep).files.adcp            = {'ROSS4011.000'};
ata(dep).files.gps             = {...
    'GPS_20161103004229.log';
    'GPS_20161103015217.log';
    'GPS_20161103030237.log';
    'GPS_20161103041141.log';
    'GPS_20161103052115.log'};
ata(dep).proc.ship_vel_removal = 'BT';
ata(dep).plot.ylim             = [0 50];
ata(dep).plot.map.pos          = [1000 787 658 551];
ata(dep).proc.trim_methods(1)  = bt90;
%-------------------------------------------------------%
dep                            = 2;
ata(dep).name                  = 'ATA_2016_11_06_0017';
ata(dep).files.map             = 'peleliu.mat';
ata(dep).tlim                  = datenum(...
    ['06-Nov-2016 00:17:22';
     '06-Nov-2016 03:18:53']);
ata(dep).files.adcp            = {'ROSS4013.000'};
ata(dep).files.gps             = {...
    'GPS_20161105234903.log';
    'GPS_20161106005834.log';
    'GPS_20161106020801.log';
    'GPS_20161106031808.log'};
ata(dep).proc.ship_vel_removal = 'GPS'; % Use GPS to remove ship velocity
ata(dep).plot.ylim             = [0 100];
ata(dep).proc.trim_methods(1)  = co90;
%-------------------------------------------------------%
dep                            = 3;
ata(dep).name                  = 'ATA_2016_11_06_0352';
ata(dep).files.map             = 'peleliu.mat';
ata(dep).tlim                  = datenum(...
    ['06-Nov-2016 03:52:56';
     '06-Nov-2016 06:53:25']);
ata(dep).files.adcp            = {'ROSS4013.000'};
ata(dep).files.gps             = {...
    'GPS_20161106033141.log';
    'GPS_20161106044153.log';
    'GPS_20161106055122.log'};
ata(dep).proc.ship_vel_removal = 'GPS'; % Use GPS to remove ship velocity
ata(dep).proc.bad              = {datenum(['06-Nov-2016 05:31:46';
                    '06-Nov-2016 05:50:30'])};
ata(dep).plot.ylim             = [0 100];
ata(dep).proc.trim_methods(1)  = co90;
%-------------------------------------------------------%

ata                            = ross_fill_defaults(ata,ata0);
deployments                    = {ata};
