function A = ross_load_adcp(ross,ndep)
D = ross.deployments(ndep);

matfile = [ross.dirs.raw.adcp D.name '.mat'];
fexist = exist(matfile,'file');

if ~fexist || ross.deployments(ndep).proc.adcp_raw2mat
    %% Load raw data
    % Default binary ADCP data parsing function - slow, but safe
    adcp_load_func = 'adcp_rdradcp_multi';
    % Override binary ADCP data parsing function?
    if isfield(D.proc,'adcp_load_function')
        adcp_load_func = D.proc.adcp_load_function;
    end
    if strcmp('adcp_parse',adcp_load_func) && ...
        isfield(D.proc,'ross_timestamps')  && ...
        D.proc.ross_timestamps
        A = feval(adcp_load_func,D.files.adcp,'ross');
        for ia = 1:length(A)
            A(ia).mtime_raw = A(ia).mtime;
            A(ia).mtime = A(ia).ross_mtime;
        end
    else
        A = feval(adcp_load_func,D.files.adcp);
    end


    %% Minor processing
    for ia = 1:length(A)
        % Make sure century is correct
        idx = year(A(ia).mtime) < 2000;
        A(ia).mtime(idx) = A(ia).mtime(idx) + datenum([2000 0 0 0 0 0]);
        % limit to deployment start/stop time
        idx = find(A(ia).mtime >= D.tlim(1) & ...
                   A(ia).mtime <= D.tlim(2));
        A(ia) = adcp_index(A(ia),idx);
    end
    
    %% save matfile
    save(matfile,'A');
    disp(['Saved ' matfile])
else
    load(matfile,'A');
    disp(['- Loaded ' matfile])
    for i = 1:length(A(1).files)
        disp(sprintf('  - %s',A(1).files{i}));
    end
end

flds = {'beam_freq'  , 'Freq'          , '%d';
        'n_beams'    , 'Beams'         , '%d';
        'beam_angle' , 'Beam Angle'    , '%d';
        'n_cells'    , 'Depth Cells'   , '%d';
        'cell_size'  , 'Cell Size'     , '%.2f';
        'blank'      , 'Blank Distance', '%.2f'};
disp('- ADCP configuration(s):')
fprintf('|')
for i = 1:length(flds)
    fprintf([flds{i,2} '|']);
end
fprintf('\n')
fprintf('|')
for i = 1:length(flds)-1
    fprintf('-+-')
end
fprintf('|\n')


for ia = 1:length(A)
    fprintf('|')
    for i = 1:length(flds)
        str = sprintf(flds{i,3},...
                      A(ia).config.(flds{i,1}));
        fprintf('%s|',str);
    end
    fprintf('\n')
end
fprintf('\n');

end
