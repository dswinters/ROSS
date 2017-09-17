function config = leconte_2017_sep_rosie()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
config.name = 'Rosie';
rosie = [];
dep = 0;

%--------------------------------------------------------%
% Default kayak options                                  %
%--------------------------------------------------------%
defaults.proc.heading_offset = 135;

% Deployments here

% Fill defaults
if ~isempty(rosie)
    rosie = fill_defaults(rosie,defaults);
end
config.deployment = rosie;

