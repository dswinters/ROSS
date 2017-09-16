%% checkfield.m
% Usage: checkfield(s,fieldname)
% Description: Returns true if a field named n both 
%              exists in the structure s and is true.
% Inputs: s - struct
%         n - string
% Outputs: b - boolean
% 
% Author: Dylan Winters
% Created: 2017-03-13

function b = checkfield(s,n)
    b = isfield(s,n) && s.(n);
end
