function Config = cruise_config(cruise_name)

cruise_config_func = ['config_' cruise_name];
Config = feval(cruise_config_func);
[Config.cruise] = deal(cruise_name);

