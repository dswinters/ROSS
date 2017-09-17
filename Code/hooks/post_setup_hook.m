function config = post_setup_hook(config)

func = [config.cruise '_post_setup_hook'];
if exist(func)==2
    config = feval(func,config);
end
