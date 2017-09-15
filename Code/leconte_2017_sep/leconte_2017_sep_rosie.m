function rosie = leconte_2017_sep_rosie()
%--------------------------------------------------------%
% ADCP orientation                                       %
%--------------------------------------------------------%
%        FORWARD
%  4   1    ^
%    x      |--> STARBOARD
%  2   3  
rosie = [];
dep = 0;

%--------------------------------------------------------%
% Default kayak options                                  %
%--------------------------------------------------------%
defaults.proc.heading_offset = 135;
defaults.proc.adcp_load_function = 'adcp_parse';
defaults.proc.adcp_load_args = {'ross','pre'};
defaults.files.map = 'leconte_terminus';
defaults.tlim = [-inf inf];
defaults.plot.ylim = [0 200];
defaults.proc.skip = false;
defaults.proc.use_3beam = false;
defaults.proc.nmea = {'GPRMC','HEHDT','PASHR','GPGGA'};

% Deployments here

% Fill defaults
if ~isempty(rosie)
    rosie = ross_fill_defaults(rosie,defaults);
end
