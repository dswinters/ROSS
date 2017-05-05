%% parse_kayak_status.m
% Usage: parse_kayak_status(f_in)
% Description: Parse ROSS kayak status log files
% Inputs: f_in - cell array of file names, or path to single file
% Outputs: STATUS - Matlab struct containing parsed data
% 
% Author: Dylan Winters
% Created: 2017-05-05

function STATUS = parse_kayak_status(f_in)
msgtypes = {'stats','winchstatus','waypt','wpcount','curwp'};
if ~iscell(f_in); f_in = {f_in}; end;

% The bulk of the text parsing is done using MATLAB's regexp function.
% First, create some regexps for types of data we might see in the text.
% The portions enclosed in parentheses will be extracted, while the rest
% is just used for matching. The regexp ',?' means that there might be a comma.
dec  = ',?(-?\d+\.\d+),?'; % positive or negative float w/ decimal places, maybe comma-enclosed
int  =@(n) sprintf(',?(-?\\d{%d}),?',n); % n-digit positive or negative integer, maybe comma-enclosed
intu = ',?(\d+),?'; % integer of unknown length, maybe comma-enclosed
ltr  = ',?[a-zA-Z],?'; % any letter, maybe comma-enclosed
EW   = ',?([ewEW]),?'; % 'E' or 'W', maybe comma-enclosed
dirstr = '(stationary|up|down)';
yesno = '(yes|no)';

% Combine the above regexps for single chunks of data into regexps
% for different status lines
fmt = struct();
fmt.stats = [...
    '-- stats -- '                      ,...
    int(4) '/' int(2) '/' int(2) ' '    ,...
    int(2) ':' int(2) ':' int(2) ' UTC' ,... 
    ' --'                               ,...
    ' TIME ' intu                       ,...
    ' LAT ' dec                         ,...
    ' LON ' dec                         ,...
    ' ALT ' dec                         ,...
    ' SATVIS ' intu                     ,...
    ' ROLL ' dec                        ,...
    ' PITCH ' dec                       ,...
    ' YAW ' dec                         ,...
    ' SP ' dec                          ,...
    ' HD ' intu                         ,...
    ' TH ' intu                         ,...
    ' CURWP ' intu                      ,...
            ];
fmt.winchstatus = [...
    '-- winchstatus -- '                ,...
    int(4) '/' int(2) '/' int(2) ' '    ,...
    int(2) ':' int(2) ':' int(2) ' UTC' ,... 
    ' --'                               ,...
    ' STATUS ' intu                     ,...
    ' +Dir ' dirstr                     ,...
    ' +Rev ' intu                       ,...
    ' Res ' intu                        ,...
    ' Spd ' dec                         ,...
    ' Ver ' intu '_' intu '_' intu      ,...
    ' DOWNLOADING ' yesno               ,...
                   ];
fmt.waypt = [...
    '-- waypt -- '                      ,...
    int(4) '/' int(2) '/' int(2) ' '    ,...
    int(2) ':' int(2) ':' int(2) ' UTC' ,... 
    ' --'                               ,...
    ' WP ' intu                         ,...
    ' LAT ' dec                         ,...
    ' LON ' dec                         ,...
    ' CUR ' intu                        ,...
            ];
fmt.wpcount = [...
    '-- wpcount -- '                    ,...
    int(4) '/' int(2) '/' int(2) ' '    ,...
    int(2) ':' int(2) ':' int(2) ' UTC' ,... 
    ' --'                               ,...
    ' WPCOUNT ' intu];
fmt.curwp = [...
    '-- curwp -- '                      ,...
    int(4) '/' int(2) '/' int(2) ' '    ,...
    int(2) ':' int(2) ':' int(2) ' UTC' ,... 
    ' --'                               ,...
    ' CURWP ' intu];

%% prefix-specific substitution filters
filts = struct(...
    'winchstatus',struct('str',{'stationary','up','down','yes','no'},...
                         'sub',{'0','1','-1','1','-1'}));

%% Function handles for extracting fields
%
% Each file is consecutively parsed for data from each message type. All
% lines of a single message type are extracted at once, into a matrix D
% with a row for each line and a column for each raw field. The
% function handles below provide instructions for converting this
% matrix into meaningful data.
%
% Defining this structure in this way allows for easy looping through 
% message types and fields within each message.
%
flds = struct(...
    'stats'      , struct(...
        'dn'     , @(D) datenum(D(:,1:6)) ,...
        'time'   , @(D) D(:,7)            ,...
        'lat'    , @(D) D(:,8)            ,...
        'lon'    , @(D) D(:,9)            ,...
        'alt'    , @(D) D(:,10)           ,...
        'satvis' , @(D) D(:,11)           ,...
        'roll'   , @(D) D(:,12)           ,...
        'pitch'  , @(D) D(:,13)           ,...
        'yaw'    , @(D) D(:,14)           ,...
        'sp'     , @(D) D(:,15)           ,...
        'th'     , @(D) D(:,16)           ,...
        'curwp', @(D) D(:,17)) ,...
    'winchstatus', struct(...
        'dn'          , @(D) datenum(D(:,1:6)) ,...
        'dir'         , @(D) D(:,7)            ,...
        'rev'         , @(D) D(:,8)            ,...
        'res'         , @(D) D(:,9)            ,...
        'spd'         , @(D) D(:,10)           ,...
        'ver'         , @(D) D(:,11:13)        ,...
        'downloading' , @(D) D(:,14)) ,...
    'waypt', struct(...
        'dn' , @(D) datenum(D(:,1:6)) ,...
        'wp' , @(D) D(:,7) ,...
        'lat', @(D) D(:,8) ,...
        'lon', @(D) D(:,9) ,...
        'cur', @(D) D(:,10)) ,...
    'wpcount',struct(...
        'dn'     , @(D) datenum(D(:,1:6)) ,...
        'wpcount', @(D) D(:,7)) ,...
    'curwp', struct(...
        'dn' ,   @(D) datenum(D(:,1:6)) ,...
        'curwp', @(D) D(:,7)));

%% Initialize output structure
STATUS = struct();
for i = 1:length(msgtypes)
    prefix = msgtypes{i};
    STATUS.(prefix) = struct();
    STATUS.(prefix).lnum = [];
    STATUS.(prefix).fnum = [];
    vars = fields(flds.(prefix));
    for v = 1:length(vars)
        STATUS.(prefix).(vars{v}) = [];
    end
end

%% Parse!
for fi = 1:length(f_in)
    disp(sprintf('Processing %s...',f_in{fi}));
    ftxt = fileread(f_in{fi}); % read entire file text
    for i = 1:length(msgtypes)
        prefix = msgtypes{i};
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
            STATUS.(prefix).lnum = cat(1,STATUS.(prefix).lnum,lnum);
            STATUS.(prefix).fnum = cat(1,STATUS.(prefix).fnum,fi*ones(size(D,1),1));
            % Populate struct with variables
            for v = 1:length(vars)
                STATUS.(prefix).(vars{v}) = cat(1,STATUS.(prefix).(vars{v}),...
                                             flds.(prefix).(vars{v})(D));
            end
        end
    end
end

STATUS.files = cell(length(f_in),1);
for i = 1:length(f_in)
    [~,fname,fext] = fileparts(f_in{i});
    STATUS.files{i} = [fname fext];
end