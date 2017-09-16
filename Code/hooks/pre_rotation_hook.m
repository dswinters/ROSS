function [config, adcp, gps] = pre_rotation_hook(config,adcp,gps)

func = [config.cruise '_pre_rotation_hook'];
if exist(fn) == 2
    [config, adcp] = feval(func,config,adcp);
end
