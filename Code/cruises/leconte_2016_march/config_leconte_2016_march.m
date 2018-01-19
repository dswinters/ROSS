function Vessels = config_leconte_2016_march()

dbox = fullfile([getenv('DROPBOX'), '/']);


%% 150 kHz config
ves = 1;
Vessels(ves).name = 'Pelican';
Vessels(ves).dirs.raw = [dbox 'LeConte/Data/ocean/march2016/ADCP/'];
Vessels(ves).dirs.proc = [dbox 'LeConte/Data/ocean/march2016/processed/'];
Vessels(ves).dirs.figs = [dbox 'LeConte/Data/ocean/march2016/ADCP/figures/'];

dep = 1;
Vessels(ves).deployment(dep).name = 'Pelican_150kHz_all';
Vessels(ves).deployment(dep).dirs.raw = '150 khz/';
Vessels(ves).deployment(dep).files.gps = '*.N1R';
Vessels(ves).deployment(dep).files.adcp = '*.ENR';
Vessels(ves).deployment(dep).plot.make_figure.summary = true;
Vessels(ves).deployment(dep).proc.heading_offset = 45;
Vessels(ves).deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
Vessels(ves).deployment(dep).proc.nmea = {'GPZDA','GPGGA','HEHDT','PADCP'};

%% 600 kHz config
dep = 2;
Vessels(ves).deployment(dep).name = 'Pelican_600kHz_all';
Vessels(ves).deployment(dep).dirs.raw = '600 khz/';
Vessels(ves).deployment(dep).files.gps = '*.N1R';
Vessels(ves).deployment(dep).files.adcp = '*.ENR';
Vessels(ves).deployment(dep).plot.make_figure.summary = true;
Vessels(ves).deployment(dep).proc.heading_offset = 45;
Vessels(ves).deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
Vessels(ves).deployment(dep).proc.nmea = {'GPZDA','GPGGA','HEHDT','PADCP'};

