function pelican = leconte_2017_sep_pelican()

dbox = fullfile([getenv('DROPBOX'), '/']);


%% 150 kHz config
pelican.name = 'Pelican';
pelican.dirs.raw = [dbox 'LeConte/Data/ocean/september2017/pelican/ADCP/raw/'];
pelican.dirs.proc = [dbox 'LeConte/Data/ocean/september2017/pelican/ADCP/processed/'];
pelican.dirs.figs = [dbox 'LeConte/Data/ocean/september2017/pelican/ADCP/figures/'];

dep = 1;
pelican.deployment(dep).name = 'Pelican_150kHz_all';
pelican.deployment(dep).dirs.raw = '150 khz/';
pelican.deployment(dep).files.gps = '*.N1R';
pelican.deployment(dep).files.adcp = '*.ENR';
pelican.deployment(dep).plot.make_figure.summary = true;
pelican.deployment(dep).proc.heading_offset = 45;
pelican.deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
pelican.deployment(dep).proc.nmea = {'GPZDA','GPGGA','HEHDT','PADCP'};

%% 600 kHz config
dep = 2;
pelican.deployment(dep).name = 'Pelican_600kHz_all';
pelican.deployment(dep).dirs.raw = '600 khz/';
pelican.deployment(dep).files.gps = '*.N1R';
pelican.deployment(dep).files.adcp = '*.ENR';
pelican.deployment(dep).plot.make_figure.summary = true;
pelican.deployment(dep).proc.heading_offset = 45;
pelican.deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
pelican.deployment(dep).proc.nmea = {'GPZDA','GPGGA','HEHDT','PADCP'};
