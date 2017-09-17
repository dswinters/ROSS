function [deployment, adcp, gps] = post_load_hook(deployment, adcp, gps)

func = [deployment.cruise.name '_post_load_hook'];
if exist(func) == 2
    [config, adcp, gps] = feval(func,config,adcp,gps);
end
