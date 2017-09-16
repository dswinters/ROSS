function [master, deployments] = ross_newport_2017_jan_deployments(ross);

%%% Trip info
master = struct();
master.name = 'newport_2017_jan';
master.process_data = true;
master.make_figures.summary = true;
master.make_figures.surface_vel = true;
master.make_figures.diagnostics = true;
master.kayaks = {'Spanky'};

ADCP_300 = struct('freq',300,...
                  'beam_angle',20,...
                  'h0',135,...
                  'unit_dir',1,... % 1:towards xducer; -1:away from xducer
                  'use_bt',false);

dep = 1;
spanky(dep).name = 'SPANKY_2017_01_12_2212';
spanky(dep).ADCP = ADCP_300;
spanky(dep).tlim = datenum(['12-Jan-2017 22:12:06';
                             '13-Jan-2017 00:18:30']);
spanky(dep).files.adcp = {'CASEY004.000'};
spanky(dep).files.gps = {'GPS_20170112214940.log';
                          'GPS_20170112225959.log'};
spanky(dep).files.map = 'yaquina.mat';
spanky(dep).proc.vel = 'GPS';
spanky(dep).proc.trim = {'EI',10};
spanky(dep).plot.ylim = [0 12];

deployments = {spanky};