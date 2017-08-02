function ross_make_bottom_profile(ross,ndep,adcp)
close all

id = regexp(ross.deployments(ndep).name,'(\d{12})','tokens');
id = str2num(id{1}{1});

maxrange = [max(adcp(1).config.ranges) max(adcp(2).config.ranges)];
[~,idx] = sort(maxrange);
adcp = adcp(idx);
a = adcp(2);

hfig = figure('position',[63 739 2277 324],'keypressfcn',@key_pressed);

% Initialize plot variables
S.beam = 1;
S.axes = axes();
S.pdat = struct('x',cell(5,1),'y',cell(5,1),'z',cell(5,1),'c',cell(5,1));
for i = 1:5
    S.pcol = adcpcolor(adcp,'intens',i);
    S.pdat(i).x{1} = S.pcol(1).XData;
    S.pdat(i).x{2} = S.pcol(2).XData;
    S.pdat(i).y{1} = S.pcol(1).YData;
    S.pdat(i).y{2} = S.pcol(2).YData;
    S.pdat(i).z{1} = S.pcol(1).ZData;
    S.pdat(i).z{2} = S.pcol(2).ZData;
    S.pdat(i).c{1} = S.pcol(1).CData;
    S.pdat(i).c{2} = S.pcol(2).CData;

end
hold on
S.lines.bt = plot(nan,nan,'g-','linewidth',2);
axis ij, shading flat, colormap(parula), hold on
set(gca,'color',0.5*[1 1 1])

S.suptitle = suptitle(ross.deployments(ndep).name);
S.title = title('');
set(S.suptitle,'interpreter','none');


% Initialize data
dirin = [ross.dirs.proc.deployments 'bt_profiles/'];
f_out = sprintf('%s%s_%d_bt.mat',dirin,lower(ross.name),id);
if exist(f_out,'file');
    S.bt = load(f_out);
else
    S.bt = struct('dn',[],'depth',[]);
    S.bt.dn = sort([adcp.mtime]);
    S.bt.depth = nan(5,length(S.bt.dn));
end
S.xlim = [min(cat(2,adcp.mtime)), max(cat(2,adcp.mtime))];
S.ylim = [0 max(maxrange)];

draw();

function key_pressed(fig_obj,eventDat)
    c = eventDat.Character;
    if ismember('shift',eventDat.Modifier)
        modifier = 'shift';
        %
    elseif ismember('control',eventDat.Modifier)
        modifier = 'control';
        %
    else
        modifier = '';
        %
    end
    %
    % Do things depending on which key was pressed
    switch c

      case {'1','2','3','4','5'}
        S.beam = str2num(c);
        disp(sprintf('Beam %s',c))
        draw()

      case 'z'
        disp('Select region to zero')
        [xx,~] = ginput(2);
        xx = sort(xx);
        idx = S.bt.dn >= xx(1) & S.bt.dn <= xx(2);
        S.bt.depth(S.beam,idx) = 1.3*max([max(adcp(1).config.ranges),...
                            max(adcp(2).config.ranges)]);
        draw();
      case 28 % left
      case 29 % right
      case 30 % up
      case 31 % down

      case 32 % space
        disp('Adding points')
        % Select points
        [t d] = ginput();
        % Sort points, ensure uniqueness
        [~,idx] = sort(t);
        t = t(idx)';
        d = d(idx)';
        [~,idx] = unique(t);
        t = t(idx);
        d = d(idx);
        % Replace points
        idx = S.bt.dn >= t(1) & S.bt.dn <= t(end);
        S.bt.depth(S.beam,idx) = interp1(t,d,S.bt.dn(idx));
        draw();

      case 's' % save data
        bt = S.bt;
        save(f_out,'-struct','bt');
        disp(['Saved ' f_out])
        draw();

      case 'x' % set xlim
        [xx,~] = ginput(2);
        if length(unique(xx)) == 2
            S.xlim = [min(xx),max(xx)];
        end
        disp(datestr(S.xlim(1)))
        disp(datestr(S.xlim(2)))
        draw();

      case 'y' % set ylim
        [~,yy] = ginput(2);
        if length(unique(yy)) == 2
            S.ylim = [min(yy),max(yy)];
        end
        draw();
        
      case 'r' % reset xlim
        S.xlim = [min(cat(2,adcp.mtime)), max(cat(2,adcp.mtime))];
        S.ylim = [0 max(maxrange)];
        draw();

    end
    % update function here
end

function draw()
    for p = 1:2
        idx = find(isnan(S.pdat(i).x{p})     | ...
                   (S.pdat(i).x{p}>=S.xlim(1) & ...
                    S.pdat(i).x{p}<=S.xlim(2)));
        set(S.pcol(p),'XData',S.pdat(S.beam).x{p}(:,idx),...
                      'YData',S.pdat(S.beam).y{p},...
                      'ZData',S.pdat(S.beam).z{p}(:,idx),...
                      'CData',S.pdat(S.beam).c{p}(:,idx));
        S.lines.bt.XData = S.bt.dn;
        S.lines.bt.YData = S.bt.depth(S.beam,:);
    end
    set(S.title,'string',sprintf('Beam %d',S.beam));
    set(S.axes,'xlim',S.xlim);
    set(S.axes,'ylim',S.ylim);
end


waitfor(hfig);

end


