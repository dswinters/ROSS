function [deployment, adcp] = post_rotation_hook(deployment, adcp)

func = [deployment.cruise.name '_post_rotation_hook'];
if exist(func) == 2
    [config, adcp] = feval(func,deployment,adcp);
end
