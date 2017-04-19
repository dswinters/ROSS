function ross = ross_figures(ross,ndep)

dep = ross.deployments(ndep);
if checkfield(dep.proc,'skip')
    return
end

%% Load deployment data
dep_file = ross.deployments(ndep).files.final;
if ~exist(dep_file,'file')
    error('No data file for %s',dep.name)
end

%% Set up figure directory
dirout = [ross.dirs.figs dep.name '/'];
if ~exist(dirout); mkdir(dirout); end

%% Default plot options
if ~isfield(dep,'plot')
    warning('No plot options specified for deployment: %s',dep.name)
end
ross.deployments(ndep).fig_dir = dirout;

if ross.master.make_figures.summary
    ross = ross_figure_summary(ross,ndep);
end
if ross.master.make_figures.surface_vel
    ross = ross_figure_surface_vel(ross,ndep);
end