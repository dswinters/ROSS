function imu = load_imu(DEP)

if ~isfield(DEP.files.imu) || isempty(DEP.files.imu)
    imu = [];
    return
end

matfile = DEP.files.imu_mat;
f_in = DEP.files.imu;

% Check for a full-deployment .mat file
fexist_all = exist(DEP.files.imu_all,'file');
% Check for a sub-deployment .mat file
fexist = exist(matfile,'file');

if fexist_all && ~DEP.proc.imu_raw2mat
    imu = load(DEP.files.imu_all);
    disp(['  - Loaded ' DEP.files.imu_all]);
elseif fexist && ~DEP.proc.imu_raw2mat
    gps = load(matfile);
    disp(['  - Loaded ' matfile]);
else
    gps = imu_read(f_in,DEP.proc.imu_load_args{:});
    save(matfile,'-struct','imu');
    disp(['  - Saved ' matfile]);
end

