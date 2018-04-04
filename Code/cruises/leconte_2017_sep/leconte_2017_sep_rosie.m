function vessel = leconte_2017_sep_rosie()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
vessel.name = 'Rosie';
% Vessel directories
scishare = '/Volumes/data/20170912_Alaska/';
vessel.dirs.raw = fullfile(scishare,'data/raw/ROSS/ROSS6_Rosie/');
vessel.dirs.proc = fullfile(scishare,'data/processed/ADCP_ROSS/Rosie/');
vessel.dirs.figs = fullfile(scishare,'figures/ROSS/Rosie/');

% Initialize deployment structure
deployment = [];
dep = 0;

%--------------------------------------------------------%
% Default deployment options                             %
%--------------------------------------------------------%
defaults.proc.heading_offset = 135;

%--------------------------------------------------------%
dep = dep+1;
deployment(dep).name      = 'rosie_deployment_20170918_225214';
deployment(dep).dirs.raw  = 'deployment_20170918_225214';


% Fill defaults
if ~isempty(deployment)
    deployment = fill_defaults(deployment,defaults);
end
vessel.deployment = deployment;

