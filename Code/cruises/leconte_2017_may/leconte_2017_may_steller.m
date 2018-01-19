function steller = leconte_2017_may_steller()

dbox = fullfile([getenv('DROPBOX'), '/']);


%% 150 kHz config
ves = 1;
steller.name = 'Steller';
steller.dirs.raw = [dbox 'LeConte/Data/ocean/may2017/raw/steller_ADCP/'];
steller.dirs.proc = [dbox 'LeConte/Data/ocean/may2017/processed/'];
steller.dirs.figs = [dbox 'LeConte/Data/ocean/may2017/figures/'];

files = dir(fullfile(steller.dirs.raw,'*.ENR'));
files = files([files.bytes]>5000);
prefixes = cell(size(files));

for i = 1:length(files)
    parts = strsplit(files(i).name,'_');
    prefixes{i} = parts{1};
end
prefixes = unique(prefixes);
% Manual exclusions:
prefixes = setdiff(prefixes,{...
                   '300khz017'; % no heading
                   });

for dep = 1:length(prefixes)
    steller.deployment(dep).name = sprintf('Steller_%02d',dep);
    steller.deployment(dep).dirs.raw = '';
    steller.deployment(dep).files.gps = [prefixes{dep} '*.N1R'];
    steller.deployment(dep).files.adcp = [prefixes{dep} '*.ENR'];
    steller.deployment(dep).plot.make_figure.summary = true;
    steller.deployment(dep).proc.heading_offset = -52;
    steller.deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
    steller.deployment(dep).proc.nmea = {'GPRMC','HEHDT','PADCP'};
end


% dep = 1;
% steller.deployment(dep).name = 'Steller_all';
% steller.deployment(dep).dirs.raw = '';
% steller.deployment(dep).files.gps = '*.N1R';
% steller.deployment(dep).files.adcp = '*.ENR';
% steller.deployment(dep).plot.make_figure.summary = true;
% steller.deployment(dep).proc.heading_offset = 50;
% steller.deployment(dep).proc.adcp_load_func = 'adcp_rdradcp_multi';
% steller.deployment(dep).proc.nmea = {'GPRMC','HEHDT','PADCP'};

