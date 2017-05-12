function casey = leconte_2017_may_casey()
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3   
casey0.heading_offset = 135;
casey0.tlim = [-inf inf];
dep = 0;
casey = struct;
%--------------------------------------------------------%
casey = ross_fill_defaults(casey,casey0);