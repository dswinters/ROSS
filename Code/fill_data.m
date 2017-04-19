%% fill_data.m
% Usage: x = fill_data(T,X,t0,x0,t,gap_max,interp_func)
% Description: Create a composite data vector by filling gaps in
%              a data vector x using multiple sources
% Inputs: T - cell array of time sources
%         X - cell array of data sources
%         t0 - original time vector
%         x0 - original data vector
%         t - target time vector
%         gap_max - maximum allowed time gap (gaps larger than this are filled)
%         interp_func - function to be used for interpolating onto t
%         
% Outputs: 
% 
% Author: Dylan Winters
% Created: 2017-02-10

function x = fill_data(T,X,t0,x0,t,gap_max,interp_func);

x = nan(size(t)); % Initialize composite data vector

%% Figure out where we can or can't use the primary data source
if ~isempty(t0)

    % Identify gaps in original data that need to be filled
    dt = diff(t0)*86400;
    gaps0 = [find([dt(:)>gap_max; false]');  % gap start indices
             find([false; dt(:)>gap_max]')]; % gap end indices

    % Identify stretches of good data that don't need to be filled
    if ~isempty(gaps0)
        good0 = [[1, gaps0(2,:)];            % good data start indices
                 [gaps0(1,:), length(t0)]];  % good data end indices
    else
        good0 = [1;length(t0)];
    end


    %% Define these segments on our desired time vector
    gaps = false(size(t));
    good = false(size(t));

    % Make a logical array identifying gaps
    for i = 1:size(gaps0,2)
        idx = t>t0(gaps0(1,i)) & t<t0(gaps0(2,i));
        gaps(idx) = true;
    end
    % Convert this to a vector, giving all entries in each gap a 
    % sequential number. e.g. entries in 1st gap are all 1's,
    % entries in 2nd gap are all 2's, etc.
    gaps = cumsum([false, diff(gaps(:)')>0]) .* +gaps(:)';

    % Do the same for good segments (but we don't need to number these)
    for i = 1:size(good0,2)
        idx = t>=t0(good0(1,i)) & t<=t0(good0(2,i));
        good(idx) = true;
    end

    % Interpolate good data from primary source
    x(good) = interp_func(t0,x0,t(good));

else

    gaps = ones(size(t));
    good = false(size(t));

end

% Process secondary sources
for i = 1:length(T)
    % Remove non-unique timestamps
    [T{i}, idx] = unique(T{i});
    X{i} = X{i}(idx);
end

% Next, loop through secondary sources
% There is a bit of redundancy here... Use low-priority secondary
% sources first so that they'll be overwritten by higher priority
% secondary sources.
%
% Assume that secondary sources were given in order of descending
% priority.
X = flipud(X(:));
T = flipud(T(:));
ferr = false;
for g = 1:max(gaps)
    for s = 1:length(T)
        idx = T{s} >= min(t(gaps==g)) & T{s} <= max(t(gaps==g));
        try 
            x(gaps==g) = interp_func(T{s}(idx),X{s}(idx),t(gaps==g));
        catch err
            if ~ferr
                (disp('Interpolation errors:'))
                ferr = true;
            end
            warning(err.message)
        end
    end
end


return



plot(t0,x0,'.'), hold on
plot(T{1},X{1},'.')
xlim(t0([1 end]));
ylim([min(x0) max(x0)])