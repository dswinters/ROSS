function [ross adcp] = leconte_2017_may_proc_post_rotation(ross,ndep,adcp)

id = regexp(ross.deployment(ndep).name,'(\d{12})','tokens');
id = str2num(id{1}{1});



switch id
  case 201705121830

    % Remove data contaminated by CTD by looking for strong local vertical velocity
    % signals
    for ia = 1:length(adcp)
        [N B M] = size(adcp(ia).vel);
        u = abs(squeeze(adcp(ia).vel(:,1,:)));
        v = abs(squeeze(adcp(ia).vel(:,2,:)));
        w = abs(squeeze(adcp(ia).vel(:,3,:)));
        us = smooth2a(u,adcp(ia).config.n_cells,1);
        vs = smooth2a(v,adcp(ia).config.n_cells,1);
        ws = smooth2a(w,adcp(ia).config.n_cells,1);
        mask = ones(N,M);
        % mask((w./ws)>2.5) = NaN;
        mask((w./ws)>2.5 | (u./us)>2.5 | (v./vs)>2.5) = NaN;
        ms = smooth2a(mask,1,1);
        mask(ms<(3/9)) = 1;
        for ib = 1:size(adcp(1).vel,2)
            vb = squeeze(adcp(ia).vel(:,ib,:));
            vb = vb.*mask;
            adcp(ia).vel(:,ib,:) = vb;
        end
    end

end





end
