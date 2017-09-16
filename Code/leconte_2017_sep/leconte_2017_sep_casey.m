function casey = leconte_2017_sep_casey()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  1   3    ^
%    x      |--> STARBOARD
%  4   2   
casey = [];
dep = 0;

%--------------------------------------------------------%
% Default kayak options                                  %
%--------------------------------------------------------%
defaults.proc.heading_offset = 45;
defaults.proc.adcp_load_function = 'adcp_parse';
defaults.proc.adcp_load_args = {'ross','pre'};
defaults.files.map = 'leconte_terminus';
defaults.tlim = [-inf inf];
defaults.plot.ylim = [0 200];
defaults.proc.skip = false;
defaults.proc.use_3beam = false;

% Deployments here


% Fill defaults
if ~isempty(casey)
    casey = ross_fill_defaults(casey,defaults);
end
