%% ross_log_read.m
%
% USAGE: 
% LOG = ross_log_read(f_in,msg_types)
%
% DESCRIPTION:
% Convert textual ROSS logfile data from 1 or more files into a MATLAB data
% struct.
%
% INPUTS: f_in (cell array), msg_types (cell array). F_IN contains full paths to
% files containing navigational data. MSG_TYPES contains the line types to be
% read (e.g. 'stats')
%
% OUTPUTS: LOG (struct). LOG contains a field for each type of message parsed.
% These fields are themselves structs, with subfields for each element parsed
% from the log string. Line numbers and file numbers are also saved, with a
% corresponding list of file names.
% 
% AUTHOR: Dylan Winters [dylan.s.winters@gmail.com]
% CREATED: 04/01/2018

function LOG = ross_log_read(f_in,msg_types)

% Ensure inputs are cell arrays
if isstr(msg_types); msg_types = {msg_types}; end
if isstr(f_in); f_in = {f_in}; end

% The bulk of the text parsing is done using MATLAB's regexp function.
% First, create some regexps for types of data we might see in the text.
% The portions enclosed in parentheses will be extracted, while the rest
% is just used for matching. The regexp ',?' means that there might be a comma.
dec  = ',?(-?\d+\.\d+),?'; % positive or negative float w/ decimal places, maybe comma-enclosed
int  =@(n) sprintf(',?(-?\\d{%d}),?',n); % n-digit positive or negative integer, maybe comma-enclosed
intu = ',?(\d+),?'; % integer of unknown length, maybe comma-enclosed
ltr  = ',?[a-zA-Z],?'; % any letter, maybe comma-enclosed
EW   = ',?([ewEW]),?'; % 'E' or 'W', maybe comma-enclosed

% Combine the above regexps for single chunks of data into regexps
% for different types of complete NMEA strings:
fmt = struct();
fmt.stats = ['-- stats -- '                         ...
             int(4) '/' int(2) '/' int(2) ' '       ... % yyyy/mm/dd 
             int(2) ':' int(2) ':' int(2) ' UTC '   ... % hh:mm:ss UTC
             '-- TIME ' intu                        ... % not sure what this one is
             ' LAT ' dec ' LON ' dec ' ALT ' dec    ...
             ' SATVIS ' intu                        ...
             ' ROLL ' dec ' PITCH ' dec ' YAW ' dec ...
             ' SP ' dec ' HD ' intu ' TH ' intu     ...
             ' CURWP ' intu];

%% Message specific substitution filters
filts = struct(); % unused for now, see nav_read.m for examples

%% Function handles for extracting fields
% Each file is consecutively parsed for data from each message type. All lines
% of a single message type are extracted at once, into a matrix D with a row for
% each line and a column for each raw field. The function handles below provide
% instructions for converting this matrix into meaningful data.
%
% Defining this structure in this way allows for easy looping through message
% prefixes and fields within each prefix.
%
flds = struct(...
    'stats',struct(...
        'dn',     @(D) datenum(D(:,1:6)) ,...
        'time',   @(D) D(:,7)            ,...
        'lat',    @(D) D(:,8)            ,...
        'lon',    @(D) D(:,9)            ,...
        'alt',    @(D) D(:,10)           ,...
        'satvis', @(D) D(:,11)           ,...
        'roll',   @(D) D(:,12)           ,...
        'pitch',  @(D) D(:,13)           ,...
        'yaw',    @(D) D(:,14)           ,...
        'sp',     @(D) D(:,15)           ,...
        'hd',     @(D) D(:,16)           ,...
        'th',     @(D) D(:,17)           ,...
        'curwp',  @(D) D(:,18)));

%% Initialize output structure
LOG = struct();
for i = 1:length(msg_types)
    prefix = msg_types{i};
    LOG.(prefix) = struct();
    LOG.(prefix).lnum = [];
    LOG.(prefix).fnum = [];
    vars = fields(flds.(prefix));
    for v = 1:length(vars)
        LOG.(prefix).(vars{v}) = [];
    end
end

%% Parse!
for fi = 1:length(f_in)
    disp(sprintf('Processing %s...',f_in{fi}));
    ftxt = fileread(f_in{fi}); % read entire file text
    for i = 1:length(msg_types)
        prefix = msg_types{i};
        %
        [lines, start] = regexp(ftxt,fmt.(prefix),'tokens','start');
        lines = cat(1,lines{:});

        if ~isempty(lines)
            % Apply substitution filters
            if isfield(filts,prefix)
                for iflt = 1:length(filts.(prefix))
                    lines(strcmp(lines,filts.(prefix)(iflt).str)) = ...
                        {filts.(prefix)(iflt).sub};
                end
            end

            D = reshape(sscanf(sprintf('%s*',lines{:}),'%f*'),size(lines));
            %
            vars = fields(flds.(prefix));
            % Grab line numbers by counting occurences of newline characters before
            % the start of each line:
            lnum = nan(size(D,1),1);
            lnum(1) = 1 + length(regexp(ftxt(1:start(1)),'\n'));
            for l = 2:length(lnum)
                lnum(l) = lnum(l-1) + ...
                          length(regexp(ftxt(start(l-1):start(l)),'\n'));
            end
            LOG.(prefix).lnum = cat(1,LOG.(prefix).lnum,lnum);
            LOG.(prefix).fnum = cat(1,LOG.(prefix).fnum,fi*ones(size(D,1),1));
            % Populate struct with variables
            for v = 1:length(vars)
                LOG.(prefix).(vars{v}) = cat(1,LOG.(prefix).(vars{v}),...
                                             flds.(prefix).(vars{v})(D));
            end
        end
    end
end

LOG.files = cell(length(f_in),1);
for i = 1:length(f_in)
    [~,fname,fext] = fileparts(f_in{i});
    LOG.files{i} = [fname fext];
end
