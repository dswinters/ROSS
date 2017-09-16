function [config, adcp, gps] = post_load_hook(config,adcp,gps)

func = [config.cruse '_post_load_hook'];
if exist(fn) == 2
    [config, adcp, gps] = feval(func,config,adcp,gps);
end
