function Config = ross_post_setup(Config)

setup_post_fun = [Config.cruise '_post_setup'];
if exist(setup_post_fun)==2
    Ross = feval(setup_post_fun,Config);
end
