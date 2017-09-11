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
opts.proc.trim_methods(1)  = notrim;
opts.proc.filters(1)       = notrim;
opts.plot.ylim             = [0 200];
opts.proc.adcp_raw2mat     = true;
opts.proc.gps_raw2mat      = true;

% rosie = leconte_2017_sep_rosie();
% rosie = ross_fill_defaults(rosie,opts);

swankie = leconte_2017_sep_swankie();
swankie = ross_fill_defaults(swankie,opts);
trip.kayaks = {'Swankie'};
deployments = {swankie};


% deployments = {rosie, swankie};
