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

%% Make sure GPRMC timestamps are unique
[~,uidx] = unique(gps.GPRMC.dn);
flds = fields(gps.GPRMC);
for i = 1:length(flds)
    gps.GPRMC.(flds{i}) = gps.GPRMC.(flds{i})(uidx);
end

%% Ensure files are in the right order
dn0 = nan(size(gps.files));
for i = 1:length(dn0)
    dn0(i) = nanmean(gps.GPRMC.dn(gps.GPRMC.fnum==i));
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
idx = year(gps.GPRMC.dn) < 2000;
gps.GPRMC.dn(idx) = gps.GPRMC.dn(idx) + datenum([2000 0 0 0 0 0]);


%% Interpolate pitch and roll from PASHR lines
if has_pashr
    n1 = length(gps.GPRMC.lnum);
    n2 = length(gps.PASHR.lnum);
    idx = [[  1+zeros(1,n1),    2+zeros(1,n2)];
           [gps.GPRMC.lnum',  gps.PASHR.lnum'];
           [           1:n1,             1:n2]];
    if ~isempty(idx)
        s = full(sparse(idx(1,:),idx(2,:),idx(3,:)));
        s = s(:,~all(s==0));
        gprmc0 = find(s(1,:)>0,1,'first');
        s = s(:,gprmc0:end);
        s = [s(1,:); s(2,2:end) 0];
        s = s(:,~any(s==0));
        %
        dn = gps.GPRMC.dn(s(1,:));
        p  = gps.PASHR.pitch(s(2,:));
        r  = gps.PASHR.roll(s(2,:));
        p_pashr = interp1(dn,p,gps.GPRMC.dn);
        r_pashr = interp1(dn,r,gps.GPRMC.dn);
    else
        warning('Unable to compute timestamps for $PASHR data')
    end
end

%% Interpolate heading from HEHDT lines
if has_hehdt
    n1 = length(gps.GPRMC.lnum);
    n2 = length(gps.HEHDT.lnum);
    idx = [[  1+zeros(1,n1),    2+zeros(1,n2)];
           [gps.GPRMC.lnum',  gps.HEHDT.lnum'];
           [           1:n1,             1:n2]];
    if ~isempty(idx)
        s = full(sparse(idx(1,:),idx(2,:),idx(3,:)));
        s = s(:,~all(s==0));
        gprmc0 = find(s(1,:)>0,1,'first');
        s = s(:,gprmc0:end);
        s = [s(1,:); s(2,2:end) 0];
        s = s(:,~any(s==0));
        %
        dn = gps.GPRMC.dn(s(1,:));
        h  = gps.HEHDT.head(s(2,:));
        h_hehdt = nav_interp_heading(dn,h,gps.GPRMC.dn);
    else
        warning('Unable to compute timestamps for $HEHDT data')
        h_hehdt = [];
    end
end

%% Estimate velocities using lat/lon data
[vx_gprmc vy_gprmc] = nav_ltln2vel(gps.GPRMC.lat,...
                                   gps.GPRMC.lon,...
                                   gps.GPRMC.dn);

%% Create returned GPS structure
gps_out = struct();
% datenum, lat, lon from GPRMC lines
gps_out.dn = gps.GPRMC.dn;
gps_out.lat = gps.GPRMC.lat;
gps_out.lon = gps.GPRMC.lon;
if has_hehdt
    gps_out.h   = h_hehdt;
end
if has_pashr
    gps_out.p = p_pashr;
    gps_out.r = r_pashr;
end
gps_out.vx = vx_gprmc;
gps_out.vy = vy_gprmc;

gps = gps_out;
