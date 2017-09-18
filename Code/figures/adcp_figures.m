function DEP = adcp_figures(DEP)

if checkfield(DEP.proc,'skip')
    return
end

disp('  - Figures')

%% Set up figure directory
dirout = fullfile(DEP.dirs.figs,'/');
if ~exist(dirout); mkdir(dirout); end

figtypes = fields(DEP.plot.make_figure);
for i = 1:length(figtypes)
    if DEP.plot.make_figure.(figtypes{i})
        % Draw figure
        hfig = feval(['adcp_figure_' figtypes{i}],DEP);
        % Save figure
        fout = fullfile(DEP.dirs.figs, [figtypes{i} '.jpg']);
        print(hfig,'-djpeg90','-r300',fout);
        disp(['    - ' fout])
    end
end

