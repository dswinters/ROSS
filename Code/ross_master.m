function ross_master(tripname)

addpath(tripname);   % add trip-specific functions to path
addpath('figures/'); % add figure functions to path

%% Trip-specific initial setup
fn = [tripname '_deployments'];
[trip, deployments] = feval(fn);

%% Processing setup
Ross = ross_setup(trip,deployments);    % filepaths and directories
Ross = ross_post_setup(Ross,trip);      % trip-specific additional setup
Ross = ross_proc_all_deployments(Ross); % Process deployments!

