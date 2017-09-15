function ross_master(cruise_name,varargin)
%ROSS_MASTER Process ADCP and GPS data from ROSS deployments.
%
%   ROSS_MASTER(CRUISE_NAME) parses all deployments defined in CRUISE_NAME's
%   config file.
%
%   ROSS_MASTER(CRUISE_NAME,VESSEL) parses all VESSEL deployments defined in
%   CRUISE_NAME's config file. VESSEL is a string matching a vessel name.
%
%   ROSS_MASTER(CRUISE_NAME,VESSELS) parses all deployments by VESSELS defined
%   in CRUISE_NAME's config file. VESSELS is a cell array of vessel names.

addpath(cruise_name); % add cruise-specific functions to path
addpath('figures/');  % add figure functions to path

Config = cruise_config(cruise_name);        % Cruise configuration

% Limit to specified vessels if requested
if nargin > 1
    if ~iscell(varargin{1})
        varargin{1} = {varargin{1}};
    end
    Config = Config(ismember({Config.name},varargin{1}));
end

Config = ross_setup(Config);                % filepaths and directories
Config = ross_proc_all_deployments(Config); % Process deployments!

