function callback_mmcread(hObject,eventdata,action)
% CALLBACK_MMCREAD reads data from from the SMP flash card using the
% program mmcread.exe.
%__________________________________________________________________________
% USAGE: 
% INPUT: 
%   hObject     - not used, MATLAB required
%   eventdata   - not used, MATLAB required
%       
% OUTPUT: none
%
% PROGRAM OUTLINE:
% 1 - DETERMINE THE TYPE OF ACTION: -a or -r
% 2 - DETERMINE THE SAVING LOCATION AND FILENAME
% 3 - DOWNLOAD THE FILES
% 4 - MOVE AND RENAME THE FILES

% NOTES: This functin requires that the the mmcread.exe and CsmDll.dll be
% present in the same directory.  The *.pnt file will be download into this
% directory, renamed (if desired), and then copied to the desired location.
% Then the original files will be removed.
%__________________________________________________________________________

% 1 - DETERMINE THE TYPE OF ACTION: a or r
if strcmpi(action,'A'); !mmcread.exe a     

% 2 - DETERMINE THE SAVING LOCATION AND FILENAME
else
    [loc] = uigetdir(cd,'Choose save location...');
    if loc == 0; return; end
    mes = 'What would you like to name the incoming *.pnt files?';
    name = inputdlg(mes,'File name(s)...',1,{'FILE'});
 
% 3 - DOWNLOAD THE FILES
    !mmcread.exe r
   
% 4 - COPY AND RENAME THE FILES
    files = dir([cd,'\*.pnt']); % Downloaded *.pnt Files
    
    % 4.1 - Build source/destination arrays
    N = length(num2str(length(files))); % Number digits for numbering
    
    for i = 1:length(files);
        source = files(i).name;      % Source file
        
        % Build leading zeros and format string for new files
        n = N - length(num2str(i));
        if n == 0; lead = ''; 
        else lead(1:n) = '0';
        end
        form = [lead,'%i'];

        dest   = [loc,'\',name{1},num2str(i,form),'.pnt']; % New file
        
        % Move and rename the current file
        movefile(source,dest,'f');
    end
 end  
   
    
    










