function rosie = leconte_2017_may_rosie()
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
rosie0.proc.heading_offset = 135;
rosie0.tlim = [-inf inf];
rosie0.plot.ylim = [0 200];
rosie0.proc.adcp_load_function = 'adcp_parse';
rosie0.proc.ross_timestamps = 'post';
rosie0.proc.skip = true;
dep=0;
%--------------------------------------------------------%
% Define some filters                                    %
%--------------------------------------------------------%
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
trim_corr_edge_b = newfilt('corr_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);
rosie0.proc.trim_methods(1) = trim_ei_edge_b;

%--------------------------------------------------------%
dep = dep+1;
rosie(dep).name       = 'rosie_deployment_201705100100';
swankie(dep).dir_raw = 'deployment_201705100100'
swankie(dep).files.adcp = '*timestamped*.bin';
rosie(dep).files.gps  = '*.log';
%--------------------------------------------------------%
dep = dep+1;
rosie(dep).name       = 'rosie_deployment_201705102330';
swankie(dep).dir_raw = 'deployment_201705102330'
swankie(dep).files.adcp = '*timestamped*.bin';
rosie(dep).files.gps  = '*.log';
%--------------------------------------------------------%
dep = dep+1;
rosie(dep).name       = 'rosie_deployment_201705130300';
swankie(dep).dir_raw = 'deployment_201705130300'
swankie(dep).files.adcp = '*timestamped*.bin';
rosie(dep).files.gps  = '*.log';
rosie(dep).proc.trim_methods = newfilt('none',[]);
%--------------------------------------------------------%

rosie = ross_fill_defaults(rosie,rosie0);
