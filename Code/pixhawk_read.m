%% pixhawk_read.m
% Usage: GPS = pixhawk_read(files)
% Description: Read Nick's PixHawk GPS logs and create a matlab structure
% Inputs: files - cell array of filepaths
% Outputs: GPS - struct w/ matlab datenum, lat, and lon
% 
% Author: Dylan Winters
% Created: 2016-10-11

function GPS = pixhawk_read(files)



fmt = ['(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2}\.\d{2})' ...
       '.*? Lat : (\d{2}\.\d+).*? Lng : (-?\d+\.\d+).*?'];

funcs = struct(...
    'dn',  @(D) datenum(D(:,1:6)) ,...
    'lat', @(D) D(:,7) ,...
    'lon', @(D) D(:,8));
flds = fields(funcs);

GPS = struct();
for i = 1:length(flds)
    GPS.(flds{i}) = [];
end

for fn = 1:length(files)
    [~,fname,~] = fileparts(files{fn});
    disp(['Reading ' fname])
    ftxt = fileread(files{fn});
    lines = regexp(ftxt,fmt,'tokens');
    lines = cat(1,lines{:});
    if ~isempty(lines)
        D = reshape(sscanf(sprintf('%s*',lines{:}),'%f*'),size(lines));
        for i = 1:length(flds)
            GPS.(flds{i}) = cat(1,GPS.(flds{i}),funcs.(flds{i})(D));
        end
    end
end
