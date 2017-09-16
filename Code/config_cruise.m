function Config = config_cruise(cruise_name,varargin)

addpath(['Cruises/' cruise_name]); % add cruise-specific functions to path
config_cruise_func = ['config_' cruise_name];
Config = feval(config_cruise_func);
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

