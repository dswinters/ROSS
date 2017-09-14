function swankie = leconte_2017_sep_swankie()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  1   3    ^
%    5      |--> STARBOARD
%  4   2   
swankie = [];
dep = 0;

%--------------------------------------------------------%
% Default kayak options                                  %
%--------------------------------------------------------%
defaults.proc.heading_offset = 45;
defaults.proc.adcp_load_function = 'adcp_parse';
defaults.proc.ross_timestamps = 'pre';
defaults.files.map = 'leconte_terminus';
defaults.plot.ylim = [0 200];
defaults.plot.make_figure.coastline_map = true;
defaults.proc.skip = false;
defaults.proc.use_3beam = false;
defaults.proc.adcp_raw2mat = true;
trim_corr_edge = struct('name','corr_edge','params','beam');
defaults.proc.trim_methods(1) = trim_corr_edge;

%--------------------------------------------------------%
% Testing on the deck - no useable data!
% dep = dep+1;
% swankie(dep).proc.skip = true;
% swankie(dep).name          = 'swankie_decktest_20170912';
% swankie(dep).dirs.raw_gps  = 'decktest_20170912/GPS/';
% swankie(dep).dirs.raw_adcp = 'decktest_20170912/ADCP/';
% swankie(dep).files.adcp    = '*timestamped*.bin';
% swankie(dep).files.gps     = '*.log';
% swankie(dep).plot.ylim     = [0 200];

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name          = 'swankie_deployment_20170913132345';
swankie(dep).dirs.raw_gps  = 'deployment_20170913132345/GPS/';
swankie(dep).dirs.raw_adcp = 'deployment_20170913132345/ADCP/';
swankie(dep).files.adcp    = '*timestamped*.bin';
swankie(dep).files.gps     = '*.log';
swankie(dep).plot.ylim     = [0 200];
swankie(dep).tlim = datenum([...
    '13-Sep-2017 14:03:47';
    '13-Sep-2017 17:01:19']);


% Fill defaults
if ~isempty(swankie)
    swankie = ross_fill_defaults(swankie,defaults);
end

