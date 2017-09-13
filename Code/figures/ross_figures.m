function ross = ross_figures(ross,ndep)

dep = ross.deployments(ndep);
if checkfield(dep.proc,'skip')
    return
end

%% Set up figure directory
dirout = [ross.dirs.figs dep.name '/'];
if ~exist(dirout); mkdir(dirout); end
ross.deployments(ndep).fig_dir = dirout;

figtypes = fields(dep.plot.make_figure);
for i = 1:length(figtypes)
    if dep.plot.make_figure.(figtypes{i})
        % Draw figure
        [ross, hfig] = feval(['ross_figure_' figtypes{i}],ross,ndep);
        % Save figure
        fout = [dep.dirs.figs figtypes{i} '.jpg'];
        print(hfig,'-djpeg90','-r300',fout);
        fparts = strsplit(fout,'/');
        flink = fullfile('..',fparts{6:end});
        disp(['[[' flink ']]'])
    end
end
