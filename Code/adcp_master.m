function adcp_master(cruise_name,varargin)
%ADCP_MASTER Process ADCP and GPS data from ROSS deployments.
%
%   ADCP_MASTER(CRUISE_NAME) parses all deployments defined in CRUISE_NAME's
%   config file.
%
%   ADCP_MASTER(CRUISE_NAME,VESSELS) parses all deployments by VESSELS defined
%   in CRUISE_NAME's config file. VESSELS is a string or cell array of vessel
%   names.
%
%   ADCP_MASTER(CRUISE_NAME,VESSEL,DEPLOYMENT) parses a single DEPLOYMENT of
%   VESSEL. These are strings specifying a vessel and deployment name.

Vessels = config_setup(cruise_name,varargin{:}); % filepaths and directories
Vessels = proc_all_deployments(Vessels);  % Process deployments!

