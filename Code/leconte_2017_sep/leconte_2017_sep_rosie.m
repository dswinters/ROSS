function rosie = leconte_2017_sep_rosie()
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
rosie0.proc.heading_offset = 135;
rosie0.tlim = [-inf inf];
rosie0.plot.ylim = [0 200];
rosie0.proc.adcp_load_function = 'adcp_parse';
rosie0.proc.ross_timestamps = 'pre';
rosie0.proc.skip = true;
dep=0;


rosie = ross_fill_defaults(rosie,rosie0);


dep = dep+1;
kayak(dep).proc.skip = false;
kayak(dep).name = 'deployment_201709time';
kayak(dep).files.adcp = {'*_timestamped.bin'};
kayak(dep).files.gps = {'*.log'};
kayak(dep).plot.ylim = [0 200];
