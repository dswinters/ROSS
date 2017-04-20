function rosie = petersburg_2017_apr_rosie()
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
rosie0.proc.heading_offset = 135;
rosie0.proc.adcp_load_function = 'adcp_rdradcp_multi';
%--------------------------------------------------------%
dep = 1;
rosie(dep).name       = 'ROSIE_test1';
rosie(dep).tlim       = datenum([-inf inf]);
rosie(dep).files.adcp = {'ADCP_raw_20170418230229.bin'};
rosie(dep).files.gps  = {'GPS_20170418230229.log'};
rosie(dep).plot.ylim  = [0 100];
%--------------------------------------------------------%
% -- Pelican trip 04/19/17
% %    - the logged PAVS files seem to be corrupted.
% dep = 2;
% rosie(dep).name       = 'ROSIE_Pelican_0419';
% rosie(dep).tlim       = datenum([-inf inf]);
% rosie(dep).files.adcp = {...
%     'ADCP_raw_20170419012224.bin';
%     'ADCP_raw_20170419020002.bin';
%     'ADCP_raw_20170419190056.bin';
%     'ADCP_raw_20170419193703.bin';
%     'ADCP_raw_20170419200001.bin';
%     'ADCP_raw_20170419210001.bin';
%     'ADCP_raw_20170419220329.bin';
%     'ADCP_raw_20170419230125.bin';
%     'ADCP_raw_20170420000053.bin';
%     'ADCP_raw_20170420010321.bin';
%     'ADCP_raw_20170420020613.bin';
%     'ADCP_raw_20170420023303.bin';
%     'ADCP_raw_20170420033646.bin'};
% rosie(dep).files.gps  = {...
%     'GPS_20170419011808.log';
%     'GPS_20170419012224.log';
%     'GPS_20170419190056.log';
%     'GPS_20170419193703.log';
%     'GPS_20170419204636.log';
%     'GPS_20170419215604.log';
%     'GPS_20170419230525.log';
%     'GPS_20170420001443.log';
%     'GPS_20170420012417.log';
%     'GPS_20170420023303.log';
%     'GPS_20170420033646.log'};
% rosie(dep).plot.ylim  = [0 200];
%--------------------------------------------------------%
rosie = ross_fill_defaults(rosie,rosie0);



