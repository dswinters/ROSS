function A = load_adcp(DEP)

matfile = DEP.files.adcp_mat;

% Check for a full-deployment .mat file
fexist_all = exist(DEP.files.adcp_all,'file');

% Check for a sub-deployment .mat file
fexist = exist(matfile,'file');

% load the full-deployment .mat file if it exists
if fexist_all && ~DEP.proc.adcp_raw2mat
    load(DEP.files.adcp_all,'A');
    disp(['  - Loaded ' DEP.files.adcp_all])
% load the sub-deployment .mat file if it exists
elseif fexist && ~DEP.proc.adcp_raw2mat
    load(matfile,'A');
    disp(['  - Loaded ' matfile])
else
    %% Load raw data
    A = feval(DEP.proc.adcp_load_func,...
              DEP.files.adcp,...
              DEP.proc.adcp_load_args{:});

    % sort by adcp configuration max range
    maxrange = nan(1,length(A));
    for i = 1:length(A)
        maxrange(i) = max(A(i).config.ranges);
    end
    [~,idx] = sort(maxrange);
    A = A(idx);

    %% save matfile
    save(matfile,'-v7.3','A');
    disp(['  - Saved ' matfile])
end

%% Minor processing
for ia = 1:length(A)
    % Make sure century is correct
    idx = year(A(ia).mtime) < 2000;
    A(ia).mtime(idx) = A(ia).mtime(idx) + datenum([2000 0 0 0 0 0]);

    % limit to deployment start/stop time
    idx = find(A(ia).mtime >= DEP.tlim(1) & ...
               A(ia).mtime <= DEP.tlim(2));
    % Save internal compass heading to new var
    A(ia).heading_internal = A(ia).heading;
    A(ia) = adcp_index(A(ia),idx);
end

