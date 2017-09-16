function [master, deployments] = leconte_2016_aug_deployments(ross);

%%% Trip info
master = struct();
master.name = 'leconte_2016_aug';
master.process_data = true;
master.make_figures.summary = true;
master.make_figures.surface_vel = true;
master.make_figures.diagnostics = true;
master.kayaks = {'Rosie','Casey'};

%%% ADCP info
ADCP_PAVS = struct('freq',150,...
                   'h0',135);
ADCP_600 = struct('freq',600,...
                  'h0',-45);
ADCP_300 = struct('freq',300,...
                  'h0',135);

%%% Kayak deployment info

%% Kayak 1: Rosie
rosie0.proc.skip = false;
rosie0.proc.adcp_load_func = 'adcp_rdradcp_multi';
rosie0.proc.trim_methods(1).name = 'ei_edge';
rosie0.proc.trim_methods(1).params = 'beam';
rosie0.proc.ship_vel_removal = 'GPS';
rosie0.proc.save_ship = false;
rosie0.proc.save_beam = false;
rosie0.proc.heading_offset = ADCP_PAVS.h0;
rosie0.proc.pixhawk.enable = false;
rosie0.proc.pixhawk.offset = datenum([0 0 0 7 0 0]);
rosie0.files.map = 'leconte_terminus';
rosie0.plot.ylim = [0 200];

%-------------------------------------------------------%
dep = 1;
rosie(dep).proc.skip = true;
rosie(dep).name = 'ROSIE_2016_08_09_1445';
rosie(dep).tlim = datenum({'09-Aug-2016 14:45:00';
                           '09-Aug-2016 15:59:00'});
rosie(dep).files.adcp = {'CACATEST3679748620.000'};
rosie(dep).files.gps = {'GPS_20160809142853.log';
                        'GPS_20160809153229.log'};
%-------------------------------------------------------%
dep = 2;
rosie(dep).name = 'ROSIE_2016_08_10_0443';
rosie(dep).tlim = datenum({'10-Aug-2016 04:43:00';
                           '10-Aug-2016 06:35:00'});
rosie(dep).files.adcp = {'TESTTWO3679819381.000';
                         'TESTTWO3679820743.000'};
rosie(dep).files.gps = {'GPS_20160810051207.log';
                        'GPS_20160810052108.log';
                        'GPS_20160810053633.log';
                        'GPS_20160810060407.log';
                        'GPS_20160810060707.log';
                        'GPS_20160810060906.log';
                        'GPS_20160810061525.log';
                        'GPS_20160810061628.log';
                        'GPS_20160810061807.log';
                        'GPS_20160810061833.log';
                        'GPS_20160810061907.log';
                        'GPS_20160810061945.log';
                        'GPS_20160810062107.log';
                        'GPS_20160810062350.log';
                        'GPS_20160810063107.log'};
%-------------------------------------------------------%
dep = 3;
rosie(dep).name = 'ROSIE_2016_08_12_0403';
rosie(dep).tlim = datenum({'12-Aug-2016 04:03:00';
                          '12-Aug-2016 05:20:00'});
rosie(dep).files.adcp = {'BEAVER3680002563.000'};
rosie(dep).files.gps = {'GPS_20160812034315.log';
                        'GPS_20160812042217.log';
                        'GPS_20160812043453.log';
                        'GPS_20160812044151.log';
                        'GPS_20160812044727.log';
                        'GPS_20160812051037.log'};
%-------------------------------------------------------%
dep = 4;
rosie(dep).name = 'ROSIE_2016_08_13_0104';
rosie(dep).tlim = datenum({'13-Aug-2016 01:04:00';
                           '13-Aug-2016 02:22:00'});
rosie(dep).files.adcp = {'COUGAR3680045343.000'};
rosie(dep).files.gps = {'GPS_20160813005424.log';
                        'GPS_20160813015836.log'};
%-------------------------------------------------------%
dep = 5;
rosie(dep).name = 'ROSIE_2016_08_14_2330';
rosie(dep).tlim = datenum({'13-Aug-2016 23:30:00';
                          '14-Aug-2016 00:10:00'});
rosie(dep).files.adcp = {'DINGO3680174793.000'};
rosie(dep).files.gps = {'GPS_20160813232804.log'};
%-------------------------------------------------------%
dep = 6;
rosie(dep).name = 'ROSIE_2016_08_14_2239';
rosie(dep).tlim = datenum({'14-Aug-2016 22:39:00';
                           '14-Aug-2016 23:47:00'});
rosie(dep).files.adcp = {'ELK3680220174.000'};
rosie(dep).files.gps = {'GPS_20160814220615.log';
                        'GPS_20160814231022.log'};
%-------------------------------------------------------%
dep = 7;
rosie(dep).name = 'ROSIE_2016_08_15_0027';
rosie(dep).tlim = datenum({'15-Aug-2016 00:27:00';
                          '15-Aug-2016 01:31:00'});
rosie(dep).files.adcp = {'ELK3680220174.000'};
rosie(dep).files.gps = {'GPS_20160815001414.log';
                        'GPS_20160815011800.log';
                        'GPS_20160815013051.log'};
%-------------------------------------------------------%

rosie = ross_fill_defaults(rosie,rosie0);

%% Kayak 2: Casey
casey0.proc.skip = false;
casey0.proc.adcp_load_func = 'adcp_rdradcp_multi';
casey0.proc.trim_methods(1).name = 'corr_edge';
casey0.proc.trim_methods(1).params = 'beam';
casey0.proc.trim_methods(2).name = 'cutoff';
casey0.proc.trim_methods(2).params = 80;
casey0.proc.ship_vel_removal = 'GPS';
casey0.proc.save_ship = false;
casey0.proc.save_beam = false;
casey0.proc.heading_offset = ADCP_600.h0;
casey0.proc.pixhawk.enable = false;
casey0.proc.pixhawk.offset = datenum([0 0 0 7 0 0]); % GMT-7 -> GMT
casey0.files.map = 'leconte_terminus';
casey0.plot.ylim = [0 100];

%-------------------------------------------------------%
dep = 1;
casey(dep).name = 'CASEY_2016_08_10_1730';
casey(dep).tlim = datenum({'10-Aug-2016 17:30:00';
                           '10-Aug-2016 19:07:00'});
casey(dep).files.adcp = {'ROSS4000.000'};
casey(dep).files.gps = {'GPS_20160810170136.log';
                        'GPS_20160810180726.log'};
%-------------------------------------------------------%
dep = 2;
casey(dep).name = 'CASEY_2016_08_11_0413';
casey(dep).tlim = datenum({'11-Aug-2016 04:13:00';
                           '11-Aug-2016 06:34:00'});
casey(dep).files.adcp = {'ROSS5000.000'};
casey(dep).files.gps = {'GPS_20160811033925.log';
                        'GPS_20160811044341.log';
                        'GPS_20160811054836.log'};
%-------------------------------------------------------%
dep = 3;
casey(dep).name = 'CASEY_2016_08_11_2158';
casey(dep).tlim = datenum({'11-Aug-2016 21:58:00';
                           '11-Aug-2016 23:26:00'});
casey(dep).files.adcp = {'ROSS5002.000'};
casey(dep).files.gps = {'GPS_20160811214326.log';
                        'GPS_20160811223505.log'};
casey(dep).proc.trim_methods(2).params = 70;
%-------------------------------------------------------%
dep = 4;
casey(dep).name = 'CASEY_2016_08_12_0454';
casey(dep).tlim = datenum({'12-Aug-2016 04:54:00';
                         '12-Aug-2016 06:02:00'});
casey(dep).files.adcp = {'ROSS5003.000'};
casey(dep).files.gps = {'GPS_20160812052713.log'};
%-------------------------------------------------------%
dep = 5;
casey(dep).name = 'CASEY_2016_08_12_1419';
casey(dep).tlim = datenum({'12-Aug-2016 14:19:00';
                         '12-Aug-2016 18:19:00'});
casey(dep).files.adcp = {'ROSS5004.000';
                        'ROSS5005.000'};
casey(dep).files.gps = {'GPS_20160812134337.log';
                    'GPS_20160812144805.log';
                    'GPS_20160812155217.log';
                    'GPS_20160812165636.log';
                    'GPS_20160812180218.log'};
%-------------------------------------------------------%
dep = 6;
casey(dep).proc.skip = true;
casey(dep).name = 'CASEY_2016_08_13_2354';
casey(dep).tlim = datenum({'12-Aug-2016 23:54:00';
                         '13-Aug-2016 03:15:00'});
casey(dep).files.adcp = {'ROSS6001.000'};
casey(dep).files.gps = {};

%-------------------------------------------------------%
dep = 7;
casey(dep).proc.skip = true;
casey(dep).name = 'CASEY_2016_08_13_2150';
casey(dep).tlim = datenum({'13-Aug-2016 21:50:00';
                         '13-Aug-2016 23:14:00'});
casey(dep).files.adcp = {'ROSS6002.000'};
casey(dep).files.gps = {};
%-------------------------------------------------------%
dep = 8;
casey(dep).name = 'CASEY_2016_08_14_1717';
casey(dep).tlim = datenum({'14-Aug-2016 17:17:00';
                         '14-Aug-2016 18:41:00'});
casey(dep).files.adcp = {'ROSS6003.000'};
casey(dep).files.gps = {'GPS_20160814170006.log';
                        'GPS_20160814180551.log'};
%-------------------------------------------------------%
dep = 9; % Used 300 kHz ADCP
casey(dep).name = 'CASEY_2016_08_15_0001';
casey(dep).tlim = datenum({'15-Aug-2016 00:01:00';
                         '15-Aug-2016 01:45:00'});
casey(dep).files.adcp = {'CASEY000.000'};
casey(dep).files.gps = {'GPS_20160815004929.log'};
casey(dep).proc.heading_offset = ADCP_300.h0;
%-------------------------------------------------------%

casey = ross_fill_defaults(casey,casey0);

master.kayaks = {'Rosie','Casey'};
deployments = {rosie, casey};
