function [deployment, adcp, gps] = post_rotation_hook(deployment, adcp, gps)

func = [deployment.cruise '_post_rotation_hook'];
if exist(func) == 2
    [config, adcp] = feval(func,config,adcp);
end
