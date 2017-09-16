%% ross_load_pixhawk.m
% Usage: pixhawk = ross_load_pixhawk(ross,flags)
% Description: Create and/or load pixhawk data into a Matlab structure
% Inputs: ross - control structure from adcp_master.m
% Outputs: pixhawk - A structure with fields: dn, lat, lon; one entry
%                    per kayak
% 
% Author: Dylan Winters
% Created: 2016-10-14

function pixhawk = ross_load_pixhawk(ross)

matfile = [ross.dirs.proc.pixhawk ...
           ross.name '_pixhawk.mat'];
if ~exist(matfile,'file')
    [fdir,~,~] = fileparts(matfile);
    if ~exist(fdir,'dir'); mkdir(fdir); end
    %
    dir_in = ross.dirs.raw.pixhawk;
    files = dir([dir_in,'tenth*GPSLog.txt']);
    fn = strcat(dir_in,{files.name});
    %
    pixhawk = pixhawk_read(fn);
    %
    [~,idx] = sort(pixhawk.dn);
    pixhawk.dn = pixhawk.dn(idx);
    pixhawk.lat = pixhawk.lat(idx);
    pixhawk.lon = pixhawk.lon(idx);
    %
    tmp = pixhawk;
    save(matfile,'-struct','tmp');
    disp(['Saved ' matfile])
else
    pixhawk = load(matfile);
    disp(['Loaded ' matfile])
end

end
