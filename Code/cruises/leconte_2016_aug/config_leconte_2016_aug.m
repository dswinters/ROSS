function Vessels = config_leconte_2016_aug()

dbox = fullfile([getenv('DROPBOX'), '/']);


%% 150 kHz config
ves = 1;
Vessels(ves).name = 'Pelican';
Vessels(ves).dirs.raw = [dbox 'LeConte/Data/ocean/august2016/Pelican/ADCP/'];
Vessels(ves).dirs.proc = [dbox 'LeConte/Data/ocean/august2016/Pelican/processed/'];
Vessels(ves).dirs.figs = [dbox 'LeConte/Data/ocean/august2016/ADCP/figures/'];

dep = 1;
Vessels(ves).deployment(dep).name = 'Pelican_150kHz_all';
Vessels(ves).deployment(dep).dirs.raw = '150khz/';
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
Vessels(ves).deployment(dep).proc.heading_offset = -45;
Vessels(ves).deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
Vessels(ves).deployment(dep).proc.nmea = {'GPZDA','GPGGA','HEHDT','PADCP'};

ves = 2;
Vessels(ves).name = 'Steller';
Vessels(ves).dirs.raw = [dbox 'LeConte/Data/ocean/august2016/SADCP/raw/'];
Vessels(ves).dirs.proc = [dbox 'LeConte/Data/ocean/august2016/SADCP/processed/'];
Vessels(ves).dirs.figs = [dbox 'LeConte/Data/ocean/august2016/SADCP/figures/'];

files = dir(fullfile(Vessels(ves).dirs.raw,'*.ENR'));
files = files([files.bytes]>5000);
prefixes = cell(size(files));
for i = 1:length(files)
    parts = strsplit(files(i).name,'_');
    prefixes{i} = parts{1};
end
prefixes = unique(prefixes);

for dep = 1:length(prefixes)
    Vessels(ves).deployment(dep).name = sprintf('Steller_%02d',dep);
    Vessels(ves).deployment(dep).dirs.raw = '';
    Vessels(ves).deployment(dep).files.gps = [prefixes{dep} '*.N1R'];
    Vessels(ves).deployment(dep).files.adcp = [prefixes{dep} '*.ENR'];
    Vessels(ves).deployment(dep).plot.make_figure.summary = true;
    Vessels(ves).deployment(dep).proc.heading_offset = -52;
    Vessels(ves).deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
    Vessels(ves).deployment(dep).proc.nmea = {'GPRMC','HEHDT','PADCP'};
end

% dep = 1;
% Vessels(ves).deployment(dep).name = 'Steller_all';
% Vessels(ves).deployment(dep).dirs.raw = '';
% Vessels(ves).deployment(dep).files.gps = '*.N1R';
% Vessels(ves).deployment(dep).files.adcp = '*.ENR';
% Vessels(ves).deployment(dep).plot.make_figure.summary = true;
% Vessels(ves).deployment(dep).proc.heading_offset = -52;
% Vessels(ves).deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
% Vessels(ves).deployment(dep).proc.nmea = {'GPRMC','HEHDT','PADCP'};

