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

do_sections = true;

%--------------------------------------------------------%
% Default kayak options                                  %
%--------------------------------------------------------%
defaults.proc.heading_offset = 45;
defaults.proc.adcp_load_function = 'adcp_parse';
defaults.proc.ross_timestamps = 'pre';
defaults.files.map = 'leconte_terminus';
defaults.plot.ylim = [0 200];
defaults.proc.skip = false;
defaults.proc.use_3beam = false;
defaults.proc.adcp_raw2mat = false;
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
swankie(dep).plot.ylim     = [0 200];
swankie(dep).tlim = datenum([...
    '13-Sep-2017 14:03:47';
    '13-Sep-2017 17:01:19']);
% Sections
namefmt = [swankie(dep).name '_s%02d'];
tlims = datenum(['13-Sep-2017 15:49:54';
                 '13-Sep-2017 15:51:15';
                 '13-Sep-2017 15:51:18';
                 '13-Sep-2017 15:52:02';
                 '13-Sep-2017 15:52:13';
                 '13-Sep-2017 15:52:57';
                 '13-Sep-2017 15:53:13';
                 '13-Sep-2017 15:54:48';
                 '13-Sep-2017 15:55:06';
                 '13-Sep-2017 15:56:28';
                 '13-Sep-2017 15:57:56';
                 '13-Sep-2017 16:00:31';
                 '13-Sep-2017 16:00:51';
                 '13-Sep-2017 16:02:15';
                 '13-Sep-2017 16:03:35';
                 '13-Sep-2017 16:04:34';
                 '13-Sep-2017 16:04:50';
                 '13-Sep-2017 16:05:25';
                 '13-Sep-2017 16:06:21';
                 '13-Sep-2017 16:08:11';
                 '13-Sep-2017 16:08:27';
                 '13-Sep-2017 16:08:58';
                 '13-Sep-2017 16:09:13';
                 '13-Sep-2017 16:10:00';
                 '13-Sep-2017 16:10:11';
                 '13-Sep-2017 16:11:39';
                 '13-Sep-2017 16:12:21';
                 '13-Sep-2017 16:13:54';
                 '13-Sep-2017 16:14:47';
                 '13-Sep-2017 16:15:58';
                 '13-Sep-2017 16:16:20';
                 '13-Sep-2017 16:18:04']);
if do_sections
    [swankie,dep] = ross_deployment_sections(swankie,dep,tlims,namefmt);
end

% Fill defaults
if ~isempty(swankie)
    swankie = ross_fill_defaults(swankie,defaults);
end

