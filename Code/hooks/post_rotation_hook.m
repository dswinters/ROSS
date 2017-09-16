function [config, adcp, gps] = post_rotation_hook(config,adcp,gps)

func = [config.cruse '_post_rotation_hook'];
if exist(fn) == 2
    [config, adcp] = feval(func,config,adcp);
end
