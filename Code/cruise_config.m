function [cruise, deployments] = cruise_config(cruise_name)

cruise_config_func = ['config_' cruise_name];
[cruise, deployments] = feval(cruise_config_func);


