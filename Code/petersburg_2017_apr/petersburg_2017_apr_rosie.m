function rosie = petersburg_2017_apr_rosie()
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
rosie0.heading_offset = 135;
%--------------------------------------------------------%
dep = 1;
rosie(dep).name       = 'ROSIE_test1';
rosie(dep).tlim       = datenum([;]);
rosie(dep).files.adcp = {};
rosie(dep).files.gps  = {};
%--------------------------------------------------------%
rosie = ross_fill_defaults(rosie,rosie0);
