function vessel = leconte_2017_may_rosie()
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
vessel.name = 'Rosie';
vessel.dirs.raw = fullfile(getenv('HOME'),'OSU/ROSS/Data/leconte_2017_may/Rosie/raw/');
vessel.dirs.proc = fullfile(getenv('HOME'),'OSU/ROSS/Data/leconte_2017_may/Rosie/processed/');
vessel.dirs.figs = fullfile(getenv('HOME'),'OSU/ROSS/Figures/leconte_2017_may/Rosie/');
vessel.dirs.maps = fullfile(getenv('HOME'),'OSU/ROSS/Maps/');

rosie0.proc.heading_offset = 135;
rosie0.proc.adcp_load_func = 'adcp_parse';
rosie0.proc.adcp_load_args = {'ross','post'};
rosie0.files.adcp = 'ADCP/*timestamped*.bin';
rosie0.files.gps  = 'GPS/*.log';
rosie0.proc.nmea = {'GPRMC','HEHDT','PASHR','GPGGA'};

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
rosie(dep).name     = 'rosie_deployment_201705100100';
rosie(dep).dirs.raw = 'deployment_201705100100';
%--------------------------------------------------------%
dep = dep+1;
rosie(dep).name     = 'rosie_deployment_201705102330';
rosie(dep).dirs.raw = 'deployment_201705102330';
%--------------------------------------------------------%
dep = dep+1;
rosie(dep).name     = 'rosie_deployment_201705130300';
rosie(dep).dirs.raw = 'deployment_201705130300';
rosie(dep).proc.trim_methods = newfilt('none',[]);
%--------------------------------------------------------%

rosie = fill_defaults(rosie,rosie0);
vessel.deployment = rosie;
