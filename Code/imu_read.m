%% imu_read.m
% Usage: imu_read({'file1.bin','file2.bin',...,'fileN.bin'})
% Description: Convert binary output from the 3DM-GX5-25 motion package to
%              a MATLAB data structure. 
%
% Inputs: files - a cell array of filepaths, e.g. {'file1.bin','file2.bin',...,'fileN.bin'}
% Outputs: imu - a MATLAB struct containing instrument output in decimal form.
%                All field names and units match those described in the
%                3DM-GX5-25 manual located at:
%                http://www.microstrain.com/sites/default/files/3dm-gx5-25_dcp_manual_8500-0065.pdf
% 
% Author: Dylan Winters
% Created: 2018-06-20


function imu = imu_read(files,varargin)

%%% Setup
% Ensure files are given as a cell array of filenames
if isstr(files)
    files = {files};
end

%%% Main parsing routine
% 1) Load binary datafiles
dat = load_data(files); 
% 2) Locate & verify data packets
header = find_headers(dat);
% 3) Convert binary data to struct
imu = parse_data(dat, header.index, header.descriptor, header.length);
% 4) Add ROSE timestamps to output
if ismember('ROSE',varargin)
    imu.attitude.rose_timestamp = header.ts;
end

%%% Sub-functions

%----------------------------------------------------------
% Locate headers in the 3DM-GX5-25 binary output
%----------------------------------------------------------
function header = find_headers(dat)
    % Find sequences of SYNC1 and SYNC2 bytes (0x75,0x65). 
    % These are the first two bytes of all headers.
    h = find(dat(1:end-1) == hex2dec('75') & ...
             dat(2:end)   == hex2dec('65'));

    % Look for timestamps inserted by ROSE computer
    if ismember('ROSE',varargin)
        ts = double(dat(h - [7:-1:1]));
        ts(:,1) = ts(:,1) + 2000; % add century
        ts(:,6) = ts(:,6) + ts(:,7)/100; % add ms to s
        ts = datenum(ts(:,1:6));
    end

    % The third byte is the 'descriptor set', which signifies the payload type.
    d = double(dat(h + 2));

    % The fourth byte is the payload length.
    l = double(dat(h + 3));

    % Verify checksums of each packet payload
    kp = true(size(h));
    for n = 1:length(h);
        if mod(n,1000)==0
            fprintf('\rVerifying checksums [%07d of %07d]',n,length(h))
        end

        % Stop if we reach EoF before packet end
        if h(n) + l(n)-1 + 6 <= length(dat)
            % Extract packet payload
            pp = dat(h(n) + [0:l(n)+3]);
            % Extract packet checksum
            chk1 = double(dat((h(n) + l(n)+3) + [1:2]));
            chk1 = bitshift(chk1(1),8) + chk1(2);

            % Compute packet checksum (16-bit Fletcher checksum)
            sum1 = 0;
            sum2 = 0;
            for i = 1:length(pp)
                sum1 = mod(sum1 + double(pp(i)),2^8);
                sum2 = mod(sum2 + sum1,2^8);
            end
            chk2 = bitshift(sum1,8) + sum2;
            
            % Discard packet if checksums don't match
            if chk2 ~= chk1
                kp(n) = false;
            end

        else % EoF reached before packet end; discard
            kp(n) = false;
        end
    end
    fprintf('\rVerifying checksums [%07d of %07d]\n',n,length(h))

    % Eliminate headers with invalid checksums
    header.index = h(kp);
    header.descriptor = d(kp);
    header.length = l(kp);
    if ismember('ROSE',varargin)
        header.ts = ts(kp);
    end
end

%----------------------------------------------------------
% Read and concatenate data in the given list of files
%----------------------------------------------------------
function dat = load_data(files)
    dat = [];
    for i = 1:length(files)
        if ~exist(files{i},'file')
            error('File not found: %s',files{i})
        end
        [~,fname,fext] = fileparts(files{i});
        disp(['Opening ' fname fext]);
        fd = fopen(files{i},'r','ieee-le');
        dat = cat(1,dat,uint8(fread(fd,inf,'uint8')));
        fclose(fd);
    end
end

%----------------------------------------------------------
% Transform a sequence of n-bit integers into the single
% decimal number represented by their concatenated binary 
% sequence.
%----------------------------------------------------------
function n = intcat(intseq,nbits,direction)
    switch direction
      case 'lr'
        shifts = 8*[length(intseq)-1:-1:0];
      case 'rl'
        shifts = 8*[0:length(intseq)-1];
    end
    n = sum(bitshift(reshape(intseq,1,[]), shifts));
end

%----------------------------------------------------------
% Convert raw binary data to a MATLAB struct based on known
% header locations, packet lengths, and descriptor bytes.
%----------------------------------------------------------
function output = parse_data(dat,h,d,l)
    output = struct(); % initialize output structure
    output.units = struct(); % initialize units structure
    counter = struct();
    for i = 1:length(h)
        if mod(i,1000)==0
            fprintf('\rParsing data packets [%06d of %06d]',i,length(h))
        end
        packet = dat(h(i) + 4 + [0:l(i)-1]); % Extract packet payload
        while length(packet) > 0
            % Ensure that the packet contains the entire field
            flen = packet(1);      % field length
            fdesc = packet(2);     % field descriptor
            if length(packet) >= flen
                fdat = packet(3:flen); % extract field data
                packet = packet(flen+1:end); % trim field from payload
            else % no more full fields in packet
                packet = [];
                flen = [];
                fdesc = '';
            end

            % process field - give subfield names, byte offsets, subfield lengths, and
            % datatypes based on the packet and field descriptor bytes.
            fentries = [];
            switch dec2hex(d(i),2) % Descriptor set byte
              case '80' % IMU Data
                dname = 'IMU';
                switch dec2hex(fdesc,2)
                  case '04'
                    fname = 'scaled_accelerometer_vector';
                  case '05'
                    fname = 'scaled_gyro_vector';
                  case '06'
                    fname = 'scaled_magnetometer_vector';
                  case '17'
                    fname = 'scaled_ambient_pressure';
                  case '07'
                    fname = 'delta_theta_vector';
                  case '08'
                    fname = 'delta_velocity_vector';
                  case '09'
                    fname = 'cf_orientation_matrix';
                  case '0a'
                    fname = 'cf_quaternion';
                  case '0c'
                    fname = 'cf_euler_angles';
                  case '10'
                    fname = 'cf_stabilized_north_vector';
                  case '11'
                    fname = 'cf_stabilized_up_vector';
                  case '12'
                    fname = 'gps_correlation_timestamp';
                end
              case '82' % Estimation Filter (Attitude) Data
                dname = 'attitude';
                switch dec2hex(fdesc,2)
                  case '10'
                    fname = 'filter_status';
                  case '11'
                    fname = 'gps_timestamp';
                    fentries = struct(...
                        'name',  {'time_of_week'  ,...
                                  'week_number'   ,...
                                  'valid'}        ,...
                        'offset',{0,8,10}         ,...
                        'type',  {'double'        ,...
                                  'uint16'        ,...
                                  'uint16'}       ,...
                        'units', {'seconds'       ,...
                                  'n/a'           ,...
                                  '1=valid, 0=invalid'});
                  case '03'
                    fname = 'orientation_quaternion';
                  case '12'
                    fname = 'attitude_uncertainty_quaternion_elements';
                  case '05'
                    fname = 'orientation_euler_angles';
                    fentries = struct(...
                        'name',  {'roll'    ,...
                                  'pitch'   ,...
                                  'yaw'     ,...
                                  'valid'}  ,...
                        'offset',{0,4,8,12} ,...
                        'type',  {'single'  ,...
                                  'single'  ,...
                                  'single'  ,...
                                  'uint16'} ,...
                        'units', {'radians' ,...
                                  'radians' ,...
                                  'radians' ,...
                                  '1=valid, 0=invalid'});
                  case '0a'
                    fname = 'attitude_uncertainty_euler_angles';
                  case '04'
                    fname = 'orientation_matrix';
                  case '0e'
                    fname = 'compensated_angular_rate';
                  case '06'
                    fname = 'gyro_bias';
                  case '0b'
                    fname = 'gyro_bias_uncertainty';
                  case '1c'
                    fname = 'compensated_acceleration';
                  case '0d'
                    fname = 'linear_acceleration';
                  case '21'
                    fname = 'pressure_altitude';
                  case '13'
                    fname = 'gravity_vector';
                  case '0f'
                    fname = 'wgs84_local_gravity_magnitude';
                  case '14'
                    fname = 'heading_update_source_state';
                    fentries = struct(...
                        'name',  {'heading'                                ,...
                                 'heading_1_sigma_uncertainty'             ,...
                                 'source'                                  ,...
                                 'valid'}                                  ,...
                        'offset',{0,4,8,10}                                ,...
                        'type',  {'single'                                 ,...
                                  'single'                                 ,...
                                  'uint16'                                 ,...
                                  'uint16'}                                ,...
                        'units', {'radians'                                ,...
                                  'radians'                                ,...
                                  '0=no source, 1=Magnetometer, 4=External',...
                                  '1=valid, 0=invalid'});
                  case '15'
                    fname = 'magnetic_model_solution';
                  case '25'
                    fname = 'mag_auto_hard_iron_offset';
                  case '28'
                    fname = 'mag_auto_hard_iron_offset_uncertainty';
                  case '26'
                    fname = 'mag_auto_soft_iron_matrix';
                  case '29'
                    fname = 'mag_auto_soft_iron_matrix_uncertainty';
                end
            end

            % Make sure the fields exist before we try to append data to them
            if ~isfield(output,dname); output.(dname)=struct(); end
            if ~isfield(output.(dname),fname)
                output.(dname).(fname) = struct();
            end
            if ~isfield(output.units,dname); output.units.(dname)=struct(); end
            if ~isfield(output.units.(dname),fname)
                output.units.(dname).(fname) = struct();
            end

            % Track entries per descriptor
            if ~isfield(counter,dname)
                counter.(dname) = 1;
            else
                counter.(dname) = counter.(dname)+1;
            end

            for e = 1:length(fentries)
                % Compute byte indices of field
                if e == length(fentries)
                    % Entry length = remainder of packet payload
                    % (subtract 2 since payload contains length and desc bytes)
                    elen = flen-2 - fentries(e).offset;
                else
                    % Entry length = difference between field offset and next field's offset
                    elen = fentries(e+1).offset - fentries(e).offset;
                end
                fidx = fentries(e).offset + [1:elen];

                % Compute numeric field value based on data type
                output.(dname).(fname).(fentries(e).name)(counter.(dname)) = ...
                    double(typecast(flipud(fdat(fidx)),fentries(e).type));
                % Add entry to units field if it doesn't exist
                if ~isfield(output.units.(dname).(fname), fentries(e).name)
                    output.units.(dname).(fname).(fentries(e).name) = fentries(e).units;
                end

            end
        end
    end
    fprintf('\rParsing data packets [%06d of %06d]\n',i,length(h))
end % of parse_data()

end % of imu_read()
