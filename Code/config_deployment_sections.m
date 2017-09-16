%% config_deployment_sections.m
% Usage: ross = config_deployment_sections(ross,dep,tlims)
% Description: Create deployment structures specifying sections
%              by copying settings from ross(dep) and using the
%              time limits specified by tlims.
% Inputs: ross - ross deployment structure
%          dep - deployment number from which to copy settings
%        tlims - datenum vector of section time limits
%      namefmt - format string to name sections
% Outputs: ross - deployment structure with sections appended
% 
% Author: Dylan Winters
% Created: 2017-05-12
function [ross dep] = config_deployment_sections(ross,dep,tlims,namefmt)

tlims = reshape(tlims,2,[])';
d0 = ross(dep);
for i = 1:size(tlims,1)
    dep = dep+1;
    ross(dep) = d0;
    ross(dep).tlim = tlims(i,:);
    ross(dep).name = sprintf(namefmt,i);
end
