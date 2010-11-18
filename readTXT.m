function d = readTXT(filename)
% READTXT reads the text data recorded in the *.smp files
%__________________________________________________________________________
% USAGE: d = readTXT(filename)
% INPUT: 
%   filename - *.smp file to open
%
% OUTPUT: none
%   d = data structure for input into GUI.HPM
%
% PROGRAM OUTLINE:
% 1 - OPEN THE *.SMP FILE
% 2 - READ THE SMP PROFILE INFORMATION
% 3 - READ FORCE AND TEMPERTURE DATA
%__________________________________________________________________________

% 1 - OPEN THE *.SMP FILE
    fid=fopen(filename,'r');
    if fid == -1; 
        mes = {'Error reading text *.smp file (readTXT.m)',...
            ['FILE: ',filename]};
        errordlg(mes,'ERROR'); return;
    end
    
% 2 - READ THE SMP PROFILE INFORMATION
    % 2.1 - Define the data structure fields
        flds = {'dzF','dzT','vers','cF','cP','zero_off','year','month',...
        'day','hr','min','sec','xcoor','ycoor','zcoor','batt_V','vel',...
        'fsamp','tsamp'};
    
    % 2.2 - Read the data
    textscan(fid,'%s\n',2);
    A = textscan(fid,'%s %f\n',length(flds),'delimiter',':');

    % 2.3 - Insert data into structure
    for i = 1:length(flds); d.(flds{i}) = A{2}(i); end

% 3 - READ FORCE AND TEMPERTURE DATA
    textscan(fid,'%s\n',2)
    F = textscan(fid,'%s',d.fsamp); d.force = str2double(F{1});
    
    textscan(fid,'%s\n',1);
    F = textscan(fid,'%s',d.tsamp); d.temp = str2double(F{1});
    d=orderfields(d,[20 1 21 2:19]);