function casey = petersburg_2017_apr_casey()
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3   
casey0.heading_offset = 135;
%--------------------------------------------------------%
dep = 1;
casey(dep).name       = 'CASEY_test1';
casey(dep).tlim       = datenum([;]);
casey(dep).files.adcp = {};
casey(dep).files.gps  = {};
%--------------------------------------------------------%
casey = ross_fill_defaults(casey,casey0);