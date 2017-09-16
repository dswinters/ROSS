function ross = ross_leconte_2016_aug_calibrate_compass(ross)

icasey = find(strcmp({ross.name},'Casey'));

%%% Calibrate 600khz compass
calibration_file = '../Data/leconte_2016_aug/600khz_compass_calibration.mat';
if exist(calibration_file,'file');
    calibration = load(calibration_file,'coeffs','func');
    disp(['Loaded ' calibration_file])
else
    %%% 600 kHz on Casey
    c = struct();
    n = struct();
    c.dn = [];
    c.h = [];
    n.dn = [];
    n.h = [];

    %% Load data
    r = ross(icasey);
    for ndep = 1:length(r.deployments)
        if r.deployments(ndep).ADCP.freq == 600
            adcp = load_adcp(r,ndep);
            c.dn = cat(2,c.dn,adcp.mtime);
            c.h = cat(2,c.h,adcp.heading);
            %
            [gps adcp] = ross_load_gps(r,ndep);
            n.dn = cat(2,n.dn,gps.dn');
            n.h = cat(2,n.h,gps.h');
        end
    end
    c0 = c;
    n0 = n;
    c.hn = nav_interp_heading(n.dn,n.h,c.dn);

    %% Manually remove some crap data
    % We can approximate the boundaries of region that contains
    % good calibration data as two absolute value functions
    r1 =@(x) 100 - 30/160*abs(x-175);
    r2 =@(x) 70  - 35/175*abs(x-175);

    dh = c.hn - c.h;
    dh(dh<-180) = dh(dh<-180) + 360;
    dh(dh>180) = dh(dh>180) - 360;

    plot(c.h,dh,'.'), hold on

    % There's also a ton of crap data in a narrow band... kill it
    dh(c.hn>=221 & c.hn<=228) = NaN;

    dh(dh>r1(c.h)) = NaN;
    dh(dh<r2(c.h)) = NaN;

    %% Do the actual calibration
    % Use 5 degree bins
    hb = 0:5:360;
    [~,bn] = histc(c.h,hb);
    counts = full(sparse(1,bn(bn>0&~isnan(dh)),1));
    counts(counts==0) = nan;
    counts(counts<50) = nan;
    dhb = full(sparse(1,bn(bn>0&~isnan(dh)),dh(bn>0&~isnan(dh)))) ./ counts;
    hb = nanmean([hb(1:end-1);hb(2:end)]);

    X=@(h) [ones(length(h),1) ,...
            sind(h(:))        ,...
            cosd(h(:))        ,...
            sind(2*h(:))      ,...
            cosd(2*h(:))      ,...
            sind(4*h(:))      ,...
            cosd(4*h(:))];

    coeffs = X(hb(~isnan(dhb))) \ dhb(~isnan(dhb))';
    func = @(C,h) h(:) + X(h(:))*C;

    plot(c.h,dh,'.'), hold on
    plot(hb,dhb,'ko')
    plot(sort(c.h),-sort(c.h)' + func(coeffs,sort(c.h)),'linewidth',2);
    plot(hb,r1(hb),'k--')
    plot(hb,r2(hb),'k--')

    save(calibration_file,'coeffs','func');
    calibration = struct('coeffs',coeffs,'func',func)
    disp(['Saved ' calibration_file])
end

depnames = {'CASEY_2016_08_10_1730';
            'CASEY_2016_08_11_0413';
            'CASEY_2016_08_11_2158';
            'CASEY_2016_08_12_0454';
            'CASEY_2016_08_12_1419';
            'CASEY_2016_08_13_2354';
            'CASEY_2016_08_13_2150';
            'CASEY_2016_08_14_1717'};
for i = 1:length(ross(icasey).deployments)
    if ismember(ross(icasey).deployments(i).name,depnames)
        ross(icasey).deployments(i).ADCP.calibration = calibration(1);
    end
end


