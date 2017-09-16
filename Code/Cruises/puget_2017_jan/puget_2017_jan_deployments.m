function [master, deployments] = puget_2017_jan_deployments();

%%% Trip info
master = struct();
master.name = 'puget_2017_jan';
master.process_data = 'true';
master.make_figures.summary = true;
master.make_figures.surface_vel = true;
master.make_figures.diagnostics = true;
master.kayaks = {'Spanky'};

%%% Default processing profile
defs.proc.skip = false;
% defs.proc.trim_methods(1).name = 'ei_edge';
% defs.proc.trim_methods(1).params = 'beam';
% defs.proc.trim_methods(2).name = 'cutoff';
% defs.proc.trim_methods(2).params = 130;
defs.proc.trim_methods(1).name = 'ei_edge';
defs.proc.trim_methods(1).params = 'beam';
defs.proc.ship_vel_removal = 'GPS';
% defs.proc.save_ship = true;
% defs.proc.save_beam = true;
% Beams top-down (4&1 forward):
% 4 1
% 2 3
defs.proc.heading_offset = 135;
defs.files.map = 'puget_sound';
defs.plot.ylim = [0 160];

%%% Deployment info

%% Spanky
dep = 1;
spanky(dep).name = 'SPANKY_2017_01_18_2040';
spanky(dep).tlim = datenum(['18-Jan-2017 20:40:19';
                            '18-Jan-2017 22:08:34']);
spanky(dep).files.adcp = {'ROSS4043.000'};
spanky(dep).files.gps = {'GPS_20170118203238.log';
                         'GPS_20170118214227.log'};

dep = 2;
spanky(dep).name = 'SPANKY_2017_01_19_1228';
spanky(dep).tlim = datenum(['19-Jan-2017 12:28:25';
                            '19-Jan-2017 17:55:10']);
spanky(dep).files.adcp = {'ROSS4045.000'};
spanky(dep).files.gps = {'GPS_20170119120950.log';
                         'GPS_20170119153951.log';
                         'GPS_20170119142934.log';
                         'GPS_20170119164949.log';
                         'GPS_20170119175954.log';
                         'GPS_20170119131948.log'};

%%% Final deployment structure
spanky = fill_defaults(spanky,defs);
deployments = {spanky};

