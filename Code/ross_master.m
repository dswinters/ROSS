function ross_master(cruise_name)

addpath(cruise_name); % add cruise-specific functions to path
addpath('figures/');  % add figure functions to path

%% Trip-specific initial setup
cruise_config_func = ['config_' cruise_name];
[cruise, deployments] = feval(cruise_config_func);

%% Processing setup
Config = ross_setup(cruise,deployments);    % filepaths and directories
Config = ross_proc_all_deployments(Config); % Process deployments!

