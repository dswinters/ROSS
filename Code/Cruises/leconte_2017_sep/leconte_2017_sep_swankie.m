function config = leconte_2017_sep_swankie()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  1   3    ^
%    5      |--> STARBOARD
%  4   2   
config.name = 'Swankie';
swankie = [];
dep = 0;
do_sections = true;

%--------------------------------------------------------%
% Default kayak options                                  %
%--------------------------------------------------------%
defaults.proc.heading_offset = 45;
trim_corr_edge = struct('name','corr_edge','params','beam');
defaults.proc.trim_methods(1) = trim_corr_edge;
defaults.proc.adcp_rotation_func = 'adcp_5beam2earth';

%--------------------------------------------------------%
% Testing on the deck - no useable data!
% dep = dep+1;
% swankie(dep).proc.skip = true;
% swankie(dep).name          = 'swankie_decktest_20170912';
% swankie(dep).dirs.raw_gps  = 'decktest_20170912/GPS/';
% swankie(dep).dirs.raw_adcp = 'decktest_20170912/ADCP/';

%--------------------------------------------------------%
dep = dep+1;
% swankie(dep).proc.skip = true;
swankie(dep).name      = 'swankie_deployment_20170913_132345';
swankie(dep).dirs.raw  = 'deployment_20170913_132345';
swankie(dep).tlim = datenum([...
    '13-Sep-2017 14:03:47';
    '13-Sep-2017 17:01:19']);
% Sections
namefmt = [swankie(dep).name '/sec_%02d'];
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
    [swankie,dep] = deployment_sections(swankie,dep,tlims,namefmt);
end

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name      = 'swankie_deployment_20170914_204159_shortwatertest';
swankie(dep).dirs.raw  = 'deployment_20170914_204159_shortwatertest';
swankie(dep).tlim = datenum([...
    '14-Sep-2017 21:45:00';
    '14-Sep-2017 22:02:00']);

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name      = 'swankie_deployment_20170916_002146';
swankie(dep).dirs.raw  = 'deployment_20170916_002146';

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name      = 'swankie_deployment_20170916_232943';
swankie(dep).dirs.raw  = 'deployment_20170916_232943';
swankie(dep).tlim = datenum([2017 09 16 23 45 00;
                             2017 09 17 02 00 00]);

%--------------------------------------------------------%
dep = dep+1;
swankie(dep).name      = 'swankie_deployment_20170917_202349';
swankie(dep).dirs.raw  = 'deployment_20170917_202349';
swankie(dep).tlim = datenum([2017 09 17 21 10 00;
                             2017 09 17 23 25 00]);
namefmt = [swankie(dep).name '/sec_%02d'];
tlims = datenum(['17-Sep-2017 20:27:56';
                 '17-Sep-2017 20:32:45';
                 '17-Sep-2017 20:34:13';
                 '17-Sep-2017 20:43:50';
                 '17-Sep-2017 20:55:07';
                 '17-Sep-2017 21:00:08';
                 '17-Sep-2017 21:19:22';
                 '17-Sep-2017 21:22:43';
                 '17-Sep-2017 21:23:46';
                 '17-Sep-2017 21:26:29';
                 '17-Sep-2017 21:31:42';
                 '17-Sep-2017 21:37:21';
                 '17-Sep-2017 21:38:24';
                 '17-Sep-2017 21:42:22';
                 '17-Sep-2017 21:45:30';
                 '17-Sep-2017 21:49:41';
                 '17-Sep-2017 21:50:56';
                 '17-Sep-2017 21:53:27';
                 '17-Sep-2017 21:54:05';
                 '17-Sep-2017 21:58:15';
                 '17-Sep-2017 21:58:41';
                 '17-Sep-2017 22:01:49';
                 '17-Sep-2017 22:02:26';
                 '17-Sep-2017 22:03:54';
                 '17-Sep-2017 22:18:45';
                 '17-Sep-2017 22:25:01';
                 '17-Sep-2017 22:29:12';
                 '17-Sep-2017 22:40:29';
                 '17-Sep-2017 22:41:07';
                 '17-Sep-2017 22:43:38';
                 '17-Sep-2017 22:44:28';
                 '17-Sep-2017 22:49:16';
                 '17-Sep-2017 22:51:22';
                 '17-Sep-2017 22:55:33';
                 '17-Sep-2017 23:08:30';
                 '17-Sep-2017 23:11:26';
                 '17-Sep-2017 23:12:04';
                 '17-Sep-2017 23:16:15']);
if do_sections
    [swankie,dep] = deployment_sections(swankie,dep,tlims,namefmt);
end




% Fill defaults
if ~isempty(swankie)
    swankie = fill_defaults(swankie,defaults);
end
config.deployment = swankie;


