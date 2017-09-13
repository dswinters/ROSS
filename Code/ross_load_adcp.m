function A = ross_load_adcp(ross,ndep)

D = ross.deployments(ndep);
matfile = [D.dirs.raw_adcp D.name '_adcp.mat'];
fexist = exist(matfile,'file');
fparts = strsplit(matfile,'/');
flink = ['[[' fullfile('..',fparts{6:end}) ']]'];

diary off
if ~fexist || ross.deployments(ndep).proc.adcp_raw2mat
    %% Load raw data
    % Default binary ADCP data parsing function - slow, but safe
    adcp_load_func = 'adcp_rdradcp_multi';
    % Override binary ADCP data parsing function?
    if isfield(D.proc,'adcp_load_function')
        adcp_load_func = D.proc.adcp_load_function;
    end
    if strcmp('adcp_parse',adcp_load_func)     && ...
            isfield(D.proc,'ross_timestamps')  && ...
            ismember(D.proc.ross_timestamps,{'pre','post'})
        A = feval(adcp_load_func,D.files.adcp,'ross',...
                  D.proc.ross_timestamps);
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

        % % Fix timestamps
        % A(ia).mtime = A(ia).mtime(1) + A(ia).mtime_raw - A(ia).mtime_raw(1);

        % limit to deployment start/stop time
        idx = find(A(ia).mtime >= D.tlim(1) & ...
                   A(ia).mtime <= D.tlim(2));
        A(ia) = adcp_index(A(ia),idx);
    end

    % sort by adcp configuration
    maxrange = nan(1,length(A));
    for i = 1:length(A)
        maxrange(i) = max(A(i).config.ranges);
    end
    [~,idx] = sort(maxrange);
    A = A(idx);

    
    %% save matfile
    save(matfile,'A');
    disp(['Saved ' flink])
else
    load(matfile,'A');
    disp(['- Loaded ' flink])
end

diary on
disp(['Raw ADCP .mat file: ' flink]);
disp('- This file contains data from the following binary file(s):')
for i = 1:length(A(1).files)
    disp(sprintf('  - %s',A(1).files{i}));
end

%% Print some information to the log file
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
