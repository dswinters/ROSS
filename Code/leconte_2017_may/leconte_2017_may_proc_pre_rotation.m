%% Deployment-specific pre-rotation processing code

function [ross adcp] = leconte_2017_may_proc_pre_rotation(ross,ndep,adcp)

% Match a deployment timestamp
id = regexp(ross.deployments(ndep).name,'(\d{12})','tokens');
id = str2num(id{1}{1});

switch id
  case 201705121830


    % a = adcp(2); %

    % bt = struct();
    % bt.dn = a.mtime;
    % bt.depth = nan(5,length(a.mtime));

    % close all
    % for i = 1:5
    %     ei = squeeze(a.intens(:,i,:));
    %     e = edge(ei,'Sobel','horizontal');
    %     mask = flipud(cumsum(flipud(e)) > 0);


    %     [t2 d2] = meshgrid(a.mtime,a.config.ranges);
    %     dmax = max(d2.*mask);
    %     dmax = nanmean([dmax;dmax([1 1:end-1]);dmax([2:end end])]);
    %     % out = isoutlier(dmax,'gesd');
    %     % dmax(out) = nan;

    %     xx = datenum(['12-May-2017 18:31:28';
    %                   '12-May-2017 18:34:55']);
    %     dmax(a.mtime>=xx(1) & a.mtime<=xx(2) & dmax < 130) = nan;
    %     dmax = smooth(a.mtime,dmax,0.03,'rlowess');

    %     bt.depth(i,:) = dmax;

    %     subplot(5,1,i)
    %     pcolor(a.mtime,a.config.ranges,ei), shading flat, axis ij
    %     colormap(hot)
    %     hold on
    %     plot(a.mtime,dmax,'m-','linewidth',2)
    %     plot(a.mtime,0.85*dmax,'g-','linewidth',1)
    % end

    % dn = [adcp(:).mtime];
    % [~,dns] = sort(dn);

    % bt2 = struct();
    % bt2.dn = [adcp(:).mtime];
    % bt2.depth = nan(5,length(bt2.dn));
    % for i = 1:5
    %     bt2.depth(i,:) = [nan*adcp(1).mtime bt.depth(i,:)];
    % end

    % bt2.dn = bt2.dn(dns);
    % bt2.depth = bt2.depth(:,dns);
    % for i = 1:5
    %     bt2.depth(i,:) = smooth(bt2.dn,bt2.depth(i,:),0.02,'loess');
    % end    
    % bt = bt2;

    % save('swankie_201705121830_bt.mat','-struct','bt')

    bt = load('swankie_201705121830_bt.mat');


    for ia = 1:length(adcp);
        for ib = 1:5
            dmax = interp1(bt.dn,bt.depth(ib,:),adcp(ia).mtime);
            vb = squeeze(adcp(ia).vel(:,ib,:));            
            [t2 d2] = meshgrid(adcp(ia).mtime,adcp(ia).config.ranges);
            dmax = repmat(dmax,adcp(ia).config.n_cells,1);
            vb(d2>0.8*dmax) = NaN;
            adcp(ia).vel(:,ib,:) = vb;            
        end
    end
end

    