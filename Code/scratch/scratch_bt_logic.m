function scratch_bt_logic()

clear all, close all

D = load('tmp.mat','ei','d');
D.ei = squeeze(D.ei(:,1,:));
D.t = 1:size(D.ei,2);

hf = figure('position',[286 684 1716 291],'keypressfcn',@key_pressed);

G.idx = 650;
G.ei = D.ei(:,G.idx);
G.eid = diff(D.ei(:,G.idx))./diff(D.d);
G.mu = conv(G.ei,[1;1;1]/3,'same');
G.sig = conv(G.ei.^2,[1;1;1]/3,'same') - G.mu;
G.sig = G.sig/nanmax(G.sig);
G.score = G.sig.*[0;G.eid].*G.ei.*D.d;
G.score = G.score/nanmax(G.score);

D.dmax = nan*D.t;

ax1 = subplot(1,5,1:2);
p1 = pcolor(D.t,D.d,D.ei); shading flat, hold on
l1 = plot([G.idx G.idx],ylim,'m--');
l2 = plot(D.t,D.dmax,'b-','linewidth',2)
colormap(hot)
axis ij

ax2 = subplot(1,5,3);
p2 = plot(G.ei,D.d,'k-','linewidth',2);
axis ij
grid on
xlim([0 200])
ylim([0 160])

ax3 = subplot(1,5,4);
p3 = plot(G.eid,D.d(1:end-1),'k-','linewidth',2);
axis ij
grid on
xlim([-40 40])
ylim([0 160])

ax4 = subplot(1,5,5);
p4 = plot(G.sig,D.d,'k-','linewidth',2);
axis ij
grid on
xlim([0 1]);
ylim([0 160])
hold on
p5 = plot(nan,nan,'ro');

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
  case 28 % left
    G.idx = max(1,G.idx-1);
  case 29 % right
    G.idx = min(length(D.t),G.idx+1);
  case 30 % up
  case 31 % down
  case 32 % space
end

G.ei = D.ei(:,G.idx);
G.eid = diff(D.ei(:,G.idx))./diff(D.d);
G.mu = conv(G.ei,[1;1;1]/3,'same');
G.sig = conv(G.ei.^2,[1;1;1]/3,'same') - G.mu;
G.sig = G.sig/nanmax(G.sig);
G.score = G.sig.*[0;G.eid].*G.ei.*D.d;
G.score = G.score/nanmax(G.score);
[pks,idx] = findpeaks(G.score,...
                      'minpeakprominence',0.7,...
                      'minpeakdistance',length(D.d)/5,...
                      'SortStr','descend');

p5.XData = pks;
p5.YData = D.d(idx);

if length(idx)>0
    D.dmax(G.idx) = D.d(idx(1));
else
    D.dmax(G.idx) = D.d(end);
end

p2.XData = G.ei;
p3.XData = G.eid;
p4.XData = G.score;
l1.XData = [G.idx G.idx];
l2.YData = D.dmax;

  
end







end
