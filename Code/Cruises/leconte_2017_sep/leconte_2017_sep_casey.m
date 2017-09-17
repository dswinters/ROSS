function config = leconte_2017_sep_casey()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  1   3    ^
%    x      |--> STARBOARD
%  4   2   
config.name = 'Casey';
casey = [];
dep = 0;

%--------------------------------------------------------%
% Default kayak options                                  %
%--------------------------------------------------------%
defaults.proc.heading_offset = 45;


% Deployments here


% Fill defaults
if ~isempty(casey)
    casey = fill_defaults(casey,defaults);
end
config.deployment = casey;
