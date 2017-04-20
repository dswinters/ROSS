function rosie = petersburg_2017_apr_rosie()
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
rosie0.heading_offset = 135;
%--------------------------------------------------------%
dep = 1;
rosie(dep).name       = 'ROSIE_test1';
rosie(dep).tlim       = datenum([-inf inf]);
rosie(dep).files.adcp = {'ADCP_raw_20170418230229.bin'};
rosie(dep).files.gps  = {'GPS_20170418230229.log'};
%--------------------------------------------------------%
rosie = ross_fill_defaults(rosie,rosie0);
