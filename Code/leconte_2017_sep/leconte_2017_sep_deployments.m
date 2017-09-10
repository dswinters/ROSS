function [trip deployments] = leconte_2017_sep_deployments()

%========================================================
% Trip info
%========================================================
trip = struct();
trip.name = 'leconte_2017_sep';
trip.kayaks = {'Rosie','Swankie'};

%========================================================
% Define some filters
%========================================================
newfilt =@(n,p) struct('name',n,'params',p);
trim_ei_edge_b = newfilt('ei_edge','beam');
filt_rotmax3   = newfilt('rotmax',3);
notrim = newfilt('none',[]);

%========================================================
% Processing options
%========================================================
opts.proc.skip             = false;
opts.proc.trim_methods(1)  = trim_ei_edge_b;
opts.proc.filters(1)       = filt_rotmax3;
opts.plot.ylim             = [0 200];
opts.proc.adcp_raw2mat     = false;
opts.proc.gps_raw2mat      = false;


