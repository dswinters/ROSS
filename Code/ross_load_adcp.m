function A = ross_load_adcp(config,ndep)

D = config.deployments(ndep);
matfile = D.files.adcp_mat;

% Check for a full-deployment .mat file
fexist_all = exist(D.files.adcp_all,'file');

% Check for a sub-deployment .mat file
fexist = exist(matfile,'file');
fparts = strsplit(matfile,'/');
flink = fullfile('..',fparts{6:end});

% load the full-deployment .mat file if it exists
if fexist_all && ~D.proc.adcp_raw2mat
    load(D.files.adcp_all,'A');
    disp(['% Loaded ' D.files.adcp_all])
    fparts = strsplit(D.files.adcp_all,'/');
    flink = fullfile('..',fparts{6:end});
% load the sub-deployment .mat file if it exists
elseif fexist && ~D.proc.adcp_raw2mat
    load(matfile,'A');
    disp(['% Loaded ' matfile])
else
    %% Load raw data
    A = feval(D.proc.adcp_load_func,...
              D.files.adcp,...
              D.proc.adcp_load_args{:});

    % sort by adcp configuration max range
    maxrange = nan(1,length(A));
    for i = 1:length(A)
        maxrange(i) = max(A(i).config.ranges);
    end
    [~,idx] = sort(maxrange);
    A = A(idx);

    %% save matfile
    save(matfile,'A');
    disp(['% Saved ' flink])
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

%% Print some information to the log file
diary on
fprintf('\n- [[%s][Raw ADCP .mat file]]. ',flink)
fprintf('This file contains data from the following binary file(s):\n')
for i = 1:length(A(1).files)
    disp(sprintf('  - %s',A(1).files{i}));
end

flds = {'beam_freq'  , 'Freq'          , '%d';
        'n_beams'    , 'Beams'         , '%d';
        'beam_angle' , 'Beam Angle'    , '%d';
        'n_cells'    , 'Depth Cells'   , '%d';
        'cell_size'  , 'Cell Size'     , '%.2f';
        'blank'      , 'Blank Distance', '%.2f'};
fprintf('\n- ADCP configuration(s):\n')
fprintf('  |')
for i = 1:length(flds)
    fprintf([flds{i,2} '|']);
end
fprintf('\n')
fprintf('  |')
for i = 1:length(flds)-1
    fprintf('-+-')
end
fprintf('|\n')

for ia = 1:length(A)
    fprintf('  |')
    for i = 1:length(flds)
        str = sprintf(flds{i,3},...
                      A(ia).config.(flds{i,1}));
        fprintf('%s|',str);
    end
    fprintf('\n')
end
diary off

end

