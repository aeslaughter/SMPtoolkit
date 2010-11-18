function d = readSMP(filename,varargin)
% READSMP opens the binary file with extension *.pnt that is recorded
% directly form the SMP.  The following code was modified by Andrew 
% Slaughter from code provided by Hans-Peter Marshall:
%       HPM 03/24/04 email:marshalh@colorado.edu
%       this MATLAB function reads the binary SMP data
%       this was adapted from the IDL code "pntvar400.pro"
%       Works only for version 302 SMP data 
%__________________________________________________________________________
% USAGE: d = readSMP(filename)
%
% INPUT: 
%   filename    = complete name of file with *.pnt extension
%   varargin{1} = if present this contains an array of the temperature
%                   constants, otherwise the constants supplied with
%                   the original readSMP.m are utilized.
%
% OUTPUT: d - structure array containing all data + header info
%           d.force     = [N] vector of force measurements 
%           d.dzF       = [mm] distance between force samples
%           d.temp      = [deg C] vector of temperature measurements
%           d.dzT       = [mm] distance between temperature samples
%           d.vers      = SMP version number
%           d.cF        = [N/V] conversion factor to force
%           d.cP        = [MPa/V] conversion factor to pressure
%           d.zero_off  = [mm] zero-offset to start
%           d.year      = year of measurement
%           d.month     = month of measurement
%           d.day       = day of measurement
%           d.hr        = hour of measurement
%           d.min       = minute of measurement
%           d.sec       = second of measurement
%           d.xcoor     = x-coordinate (if GPS on)
%           d.ycoor     = y-coordinate
%           d.zcoor     = z-coordinate
%           d.batt_V    = battery voltage
%           d.vel       = [mm/s] = average speed
%           d.fsamp     = number of force samples
%           d.tsamp     = number of temperature samples
%           d.depth_F   = depth vector for force
%           d.depth_T   = depth vector for temperature
%
% PROGRAM OUTLINE:
% 1 - OPEN THE BINARY FILE
% 2 - READ THE SMP PROFILE SPECIFICS 
% 3 - DETERMINE THE NUMBER OF SAMPLES
% 4 - READ THE SMP DATA
% 5 - CONVERT TEMPERATURE
% 6 - CONVERT FORCE AND CALCULATE DEPTH
% 7 - REORDER FIELDS AND CLOSE THE FILE    
%__________________________________________________________________________

% 1 - OPEN THE BINARY FILE
    fid=fopen(filename,'r','b');
    if fid == -1; 
        mes = {'Error reading binary *.pnt file (readSMP.m)',...
            ['FILE: ',filename]};
        errordlg(mes,'ERROR'); return;
    end
    
% 2 - READ THE SMP PROFILE SPECIFICS  
    d.vers=fread(fid,1,'short');    % Version
    d.nsamp=fread(fid,1,'long');    % Number of samples
    d.dzF=fread(fid,1,'float');     % Distance between force samples [mm]
    d.dzT=d.dzF*128;                % Distance between temp. samples [mm]
    d.cF=fread(fid,1,'float');      % Conversion to force (integer to [N])
    d.cP=fread(fid,1,'float');      % Conv. to pressure (integer to [MPa])
    d.zero_off=fread(fid,1,'short');% Zero offset to start
    d.year=fread(fid,1,'short');    % Time of measurement
    d.month=fread(fid,1,'short');   %
    d.day=fread(fid,1,'short');     %
    d.hr=fread(fid,1,'short');      %
    d.min=fread(fid,1,'short');     %
    d.sec=fread(fid,1,'short');     %
    d.xcoor=fread(fid,1,'double');  % GPS coordinates
    d.ycoor=fread(fid,1,'double');  %
    d.zcoor=fread(fid,1,'double');  %
    d.batt_V=fread(fid,1,'double'); % Battery voltage
    d.vel=fread(fid,1,'float');     % Average speed [mm/s]

% 3 - DETERMINE THE NUMBER OF SAMPLES
    status=fseek(fid,358,'bof');    % Reposition pointer
    d.fsamp=fread(fid,1,'long');    % Number of force samples
    d.tsamp=fread(fid,1,'long');    % Number of temperature samples

    f_block=floor(d.fsamp/256)+1;   % Number of "256 byte blocks"
    t_block=floor(d.tsamp/256)+1;   % Number of "256 byte blocks"

% 4 - READ THE SMP DATA
    % Reposition pointer to start of data
    status=fseek(fid,512,'bof');   
        
    % Total number of data points to read (short integers)
    buf=fread(fid,f_block*256+t_block*256,'short');
    
    d.force=buf(1:d.fsamp);                    % Force data
    temp=buf(f_block*256:f_block*256+d.tsamp); % Raw temperature data
    temp=temp(1:length(temp)-1);

% 5 - CONVERT TEMPERATURE
    % 5.1 - Set the defaults calibration constants
        tc(1) = -0.018205007;   tc(3) = -0.00098275584;
        tc(2) = 0.0078710989;   tc(4) = 4.2608056e-5;
        
    % 5.2 - Read supplied calibration constants, if supplied
        if ~isempty(varargin); tc = varargin{1}; end
        
    % 5.3 - Adjust the temperature values using constants    
        i=find(temp == 0);
        temp(i)=NaN;

        logRt  = log(temp/0.1/8.0/5.7);
        d.temp = 1./(tc(1) + tc(2)*logRt + tc(3)*logRt.^2 + ...
            tc(4)*logRt.^3) - 273.15 - 1.9;     % Temp. in 1/100 deg C
        d.temp=d.temp/100;                      % Temp. in [deg C]

% 6 - CONVERT FORCE AND CALCULATE DEPTH
    d.force=d.force*d.cF;               % Force in [N]
    %d.zF=(0:d.dzF:(d.fsamp-1)*d.dzF)'; % Depth scale for force
    %d.zT=(0:d.dzT:(d.tsamp-1)*d.dzT)'; % Depth scale for force
    
    %d.depth_F=d.dzF:d.dzF:(d.dzF*length(d.force));% Depth values for force
    %d.depth_T=d.dzT:d.dzT:(d.dzT*length(d.temp)); % Depth values for temp.
  
% 7 - REORDER FIELDS AND CLOSE THE FILE    
    d=orderfields(d,[21 3 22 4 1 2 5:20]);
    d=rmfield(d,'nsamp');
    status=fclose(fid);


