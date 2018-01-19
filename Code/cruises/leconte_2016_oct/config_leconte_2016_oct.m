function Vessels = config_leconte_2016_oct()

dbox = fullfile([getenv('DROPBOX'), '/']);


%% 150 kHz config
ves = 1;
Vessels(ves).name = 'Pelican';
Vessels(ves).dirs.raw = [dbox 'LeConte/Data/ocean/october2016/raw/SADCP/'];
Vessels(ves).dirs.proc = [dbox 'LeConte/Data/ocean/october2016/processed/'];
Vessels(ves).dirs.figs = [dbox 'LeConte/Data/ocean/october2016/figures/'];

dep = 1;
Vessels(ves).deployment(dep).name = 'Pelican_300kHz_all';
Vessels(ves).deployment(dep).dirs.raw = '300khz/';
Vessels(ves).deployment(dep).files.gps = '*.N1R';
Vessels(ves).deployment(dep).files.adcp = '*.ENR';
Vessels(ves).deployment(dep).plot.make_figure.summary = true;
Vessels(ves).deployment(dep).proc.heading_offset = 45;
Vessels(ves).deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
Vessels(ves).deployment(dep).proc.nmea = {'GPZDA','GPGGA','HEHDT','PADCP'};

%% 600 kHz config
dep = 2;
Vessels(ves).deployment(dep).name = 'Pelican_600kHz_all';
Vessels(ves).deployment(dep).dirs.raw = '600khz/';
Vessels(ves).deployment(dep).files.gps = '*.N1R';
Vessels(ves).deployment(dep).files.adcp = '*.ENR';
Vessels(ves).deployment(dep).plot.make_figure.summary = true;
Vessels(ves).deployment(dep).proc.heading_offset = 45;
Vessels(ves).deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
Vessels(ves).deployment(dep).proc.nmea = {'GPZDA','GPGGA','HEHDT','PADCP'};
