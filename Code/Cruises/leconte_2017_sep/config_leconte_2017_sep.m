function Vessels = config_leconte_2017_sep()

%========================================================
% Define some filters
%========================================================
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);

%========================================================
% Initialize Vessels struct
%========================================================
Vessels(1) = leconte_2017_sep_casey();
Vessels(2) = leconte_2017_sep_rosie();
Vessels(3) = leconte_2017_sep_swankie();
Vessels(4) = leconte_2017_sep_steller();

for i = 1:4
    Vessels(i).dirs.maps = fullfile(getenv('HOME'),'OSU/ROSS/Maps/');
    Vessels(i).dirs.logs = fullfile(getenv('HOME'),'OSU/ROSS/org/');
end

%========================================================
% Default options
%========================================================
% Global
all_defaults.files.map         = 'leconte_terminus';
all_defaults.files.coastline   = 'leconte2_grid_coastline.mat';
all_defaults.proc.skip         = false; % only skip if explicitly directed
all_defaults.plot.ylim         = [0 200];
all_defaults.proc.adcp_raw2mat = false;
all_defaults.proc.gps_raw2mat  = false;
all_defaults.proc.use_3beam    = false;
% ROSS
ross_defaults.plot.lonlim         = [-132.3768 -132.3470];
ross_defaults.plot.latlim         = [56.8228 56.8434];
ross_defaults.proc.adcp_load_func = 'adcp_parse';
ross_defaults.proc.adcp_load_args = {'ross','pre'};
ross_defaults.proc.nmea           = {'GPRMC','HEHDT','PASHR','GPGGA'};
ross_defaults.files.gps           = 'GPS/*.log';
ross_defaults.files.adcp          = 'ADCP/*timestamped*.bin';
% Figures
fig_defaults.plot.make_figure.summary       = true;
% fig_defaults.plot.make_figure.echo_intens   = true;
% fig_defaults.plot.make_figure.corr          = true;
% fig_defaults.plot.make_figure.coastline_map = true;

% Fill ROSS defaults
for i = 1:4
    if ~isempty(Vessels(i).deployment)
        switch i
          case {1,2,3}
            Vessels(i).deployment = fill_defaults(Vessels(i).deployment,ross_defaults);
        end
        Vessels(i).deployment = fill_defaults(Vessels(i).deployment,fig_defaults);
        Vessels(i).deployment = fill_defaults(Vessels(i).deployment,all_defaults);
    end
end

