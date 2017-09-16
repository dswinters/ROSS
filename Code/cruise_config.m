function Config = cruise_config(cruise_name,varargin)

cruise_config_func = ['config_' cruise_name];
Config = feval(cruise_config_func);
[Config.cruise] = deal(cruise_name);

% Limit to specified vessel(s)
if nargin > 1
    if ~iscell(varargin{1})
        varargin{1} = {varargin{1}};
    end
    Config = Config(ismember({Config.name},varargin{1}));
end

% Limit to specified deployment(s)
if nargin > 2
    if ~iscell(varargin{2})
        varargin{2} = {varargin{2}};
    end
    ind = ismember({Config.deployments.name},varargin{2});
    Config.deployments = Config.deployments(ind);
end

