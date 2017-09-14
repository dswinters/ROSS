function ross_master(cruise_name)

addpath(cruise_name); % add cruise-specific functions to path
addpath('figures/');  % add figure functions to path

[cruise,deployments] = cruise_config(cruise_name); % Cruise configuration
Config = ross_setup(cruise,deployments);           % filepaths and directories
Config = ross_proc_all_deployments(Config);        % Process deployments!

