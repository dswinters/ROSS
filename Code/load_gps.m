function [gps] = load_gps(DEP)

%% Load logged gps data
matfile = DEP.files.gps_mat;
prefix = DEP.proc.nmea;

f_in = DEP.files.gps;

% Check for a full-deployment .mat file
fexist_all = exist(DEP.files.gps_all,'file');
% Check for a sub-deployment .mat file
fexist = exist(matfile,'file');

if fexist_all && ~DEP.proc.gps_raw2mat
    gps = load(DEP.files.gps_all);
    disp(['  - Loaded ' DEP.files.gps_all]);
elseif fexist && ~DEP.proc.gps_raw2mat
    gps = load(matfile);
    disp(['  - Loaded ' matfile]);
else
    gps = nav_read(f_in,prefix);
    save(matfile,'-struct','gps');
    disp(['  - Saved ' matfile]);
end

has_pashr = ismember('PASHR',DEP.proc.nmea);
has_hehdt = ismember('HEHDT',DEP.proc.nmea);
has_gprmc = ismember('GPRMC',DEP.proc.nmea);
has_gpzda = ismember('GPZDA',DEP.proc.nmea);
has_gpgga = ismember('GPGGA',DEP.proc.nmea);


dn_source = '';
ll_source = '';
if has_gprmc % GPRMC gives dn, lat, lon
    dn_source = 'GPRMC';
    ll_source = 'GPRMC';
else
    % Determine dn source
    if has_gpzda
        dn_source = 'GPZDA';
    end
    if has_gpgga
        ll_source = 'GPGGA';
    end
end

if isempty(dn_source)
    error('GPS data contains no supported source for datenum!')
end
if isempty(ll_source)
    error('GPS data contains no supported source for lat/lon!')
end

%% Make sure timestamps are unique
[~,uidx] = unique(gps.(dn_source).dn);
flds = fields(gps.(dn_source));
for i = 1:length(flds)
    gps.(dn_source).(flds{i}) = gps.(dn_source).(flds{i})(uidx);
end

%% Ensure files are in the right order
dn0 = nan(size(gps.files));
for i = 1:length(dn0)
    dn0(i) = nanmean(gps.(dn_source).dn(gps.(dn_source).fnum==i));
end
[~,idx_new] = sort(dn0);
gps.files = gps.files(idx_new);
[~,fnum_new] = sort(idx_new);
for ip = 1:length(prefix)
    gps.(prefix{ip}).fnum = fnum_new([gps.(prefix{ip}).fnum]);
end
for i = 1:length(f_in)
    for ip = 1:length(prefix)
        idx_pre = gps.(prefix{ip}).fnum < i;
        idx = gps.(prefix{ip}).fnum == i;
        idx_post = gps.(prefix{ip}).fnum > i;
        flds = fields(gps.(prefix{ip}));
        for ifld = 1:length(flds)
            gps.(prefix{ip}).(flds{ifld}) = ...
                [gps.(prefix{ip}).(flds{ifld})(idx_pre);
                 gps.(prefix{ip}).(flds{ifld})(idx);
                 gps.(prefix{ip}).(flds{ifld})(idx_post)];
        end
    end
end

%% Transform intra-file line numbers into cumulative inter-file line numbers
lnum_max = 0;
for i = 1:length(f_in)
    lnum_max = 0;
    for ip = 1:length(prefix)
        idx = gps.(prefix{ip}).fnum == i-1;
        lnum_max = nanmax([lnum_max; max(gps.(prefix{ip}).lnum(idx))]);
    end
    for ip = 1:length(prefix)
        idx = gps.(prefix{ip}).fnum == i;
        gps.(prefix{ip}).lnum(idx) = gps.(prefix{ip}).lnum(idx) + lnum_max;
    end
end

%% make sure timestamps are year 20xx instead of 00xx
idx = year(gps.(dn_source).dn) < 2000;
gps.(dn_source).dn(idx) = gps.(dn_source).dn(idx) + datenum([2000 0 0 0 0 0]);

%% Get datenum, lat, lon onto same time vector
if has_gprmc
    dn = gps.GPRMC.dn;
    lat = gps.GPRMC.lat;
    lon = gps.GPRMC.lon;
elseif has_gpzda & has_gpgga
    dn = gps.GPZDA.dn;
    lat = gps_line_interp(gps,'GPZDA','GPGGA','lat');
    lon = gps_line_interp(gps,'GPZDA','GPGGA','lon');
end
[vx vy] = nav_ltln2vel(lat,lon,dn);


%% Interpolate pitch and roll from PASHR lines
if has_pashr
    p_pashr = gps_line_interp(gps,dn_source,'PASHR','pitch');
    r_pashr = gps_line_interp(gps,dn_source,'PASHR','roll');
end

%% Interpolate heading from HEHDT lines
if has_hehdt
    heading = gps_line_interp(gps,dn_source,'HEHDT','head');
else
    th = cart2pol(ve,vn);
    heading = rad2degt(th);
end

%% Create returned GPS structure
gps_out = struct();
% datenum, lat, lon from GPRMC lines
gps_out.dn = dn;
gps_out.lat = lat;
gps_out.lon = lon;
gps_out.h = heading;
if has_pashr
    gps_out.p = p_pashr;
    gps_out.r = r_pashr;
end
gps_out.vx = vx;
gps_out.vy = vy;

gps = gps_out;
