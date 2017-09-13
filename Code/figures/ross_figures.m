function ross = ross_figures(ross,ndep)

dep = ross.deployments(ndep);
if checkfield(dep.proc,'skip')
    return
end

%% Set up figure directory
dirout = [ross.dirs.figs dep.name '/'];
if ~exist(dirout); mkdir(dirout); end
ross.deployments(ndep).fig_dir = dirout;

figtypes = {'summary';
            'surface_vel';
            'echo_intens';
            'corr'
            'coastline_map'};
for i = 1:length(figtypes)
    if dep.plot.make_figure.(figtypes{i}) | dep.plot.make_figure.all
        ross = feval(['ross_figure_' figtypes{i}],ross,ndep);
    end
end
