function rosie = leconte_2017_may_rosie()
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
rosie0.proc.heading_offset = 135;
rosie0.tlim = [-inf inf];
rosie0.files.map = 'leconte_terminus';
rosie0.plot.ylim = [0 200];
rosie0.proc.adcp_load_function = 'adcp_parse';
rosie0.proc.ross_timestamps = 'post';
%--------------------------------------------------------%
dep = 1;
rosie(dep).name       = 'rosie_deployment_201705100100';
rosie(dep).files.adcp = {...
    'deployment_201705100100'
    'timestamped'};
rosie(dep).files.gps  = {'deployment_201705100100'};
%--------------------------------------------------------%
dep = 2;
rosie(dep).name       = 'rosie_deployment_201705102330';
rosie(dep).files.adcp = {...
    'deployment_201705102330'
    'timestamped'};
rosie(dep).files.gps  = {'deployment_201705102330'};
%--------------------------------------------------------%
rosie = ross_fill_defaults(rosie,rosie0);
