function vessel = leconte_2017_sep_casey()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  1   3    ^
%    x      |--> STARBOARD
%  4   2   
vessel.name = 'Casey';
% Vessel directories
scishare = '/Volumes/data/20170912_Alaska/';
vessel.dirs.raw = fullfile(scishare,'data/raw/ROSS/ROSS3_Casey/');
vessel.dirs.proc = fullfile(scishare,'data/processed/ADCP_ROSS/Casey/');
vessel.dirs.figs = fullfile(scishare,'figures/ROSS/Casey/');

% Initialize deployment structure
deployment = [];
dep = 0;

%--------------------------------------------------------%
% Default kayak options                                  %
%--------------------------------------------------------%
defaults.proc.heading_offset = 45;


% Deployments here


% Fill defaults
if ~isempty(deployment)
    deployment = fill_defaults(deployment,defaults);
end
vessel.deployment = deployment;
