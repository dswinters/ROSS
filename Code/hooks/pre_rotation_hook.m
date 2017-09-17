function [deployment adcp] = pre_rotation_hook(deployment, adcp)

func = [deployment.cruise '_pre_rotation_hook'];
if exist(func) == 2
    [deployment, adcp] = feval(func,deployment,adcp);
end
