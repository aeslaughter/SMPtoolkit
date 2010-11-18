function callback_diff(hObject,eventdata)
% CALLBACK_DIFF takes the differences between two proviles
%__________________________________________________________________________
%
% SYNTAX: callback_diff(hObject,eventdata)
%
% DESCRIPTION:
%   hObject - is calling objects handle, must be associated with SMPtoolkit
%   eventdata = MATLAB required, not used
%   type = 'moving': performs simple moving average over distance specified
%
% PROGRAM OUTLINE:
%
%__________________________________________________________________________

% 1 - GATHER DATA FROM GUI
    % 1.1 - Figure handles and data structure
        h = guihandles(hObject);
        GUI = guidata(h.SMPtoolkit);

    % 1.2 - Return if no data exists, providing a warning
        if ~isfield(GUI,'HPM');     
            warndlg('No file open.','Warning'); return; 
        end

    % 1.3 - Exit if two profiles are not selected
        idx = get(h.currentfile,'Value');
        if length(idx) ~= 2
            errordlg('You must select only two curves!','ERRROR'); return;
        end

    % 1.4 - Seperate selected data
        leg = get(h.currentfile,'String');
        D = GUI.HPM(idx); 

% 2 - PERFORM SMOOTHING ON EACH OF THE SELECTED PROFILES
    % 2.1 - Check profile size
        if length(D(1).force) ~= length(D(2).force);
            errordlg('Profile sizes do not match.','ERROR'); return;
        end

    % 2.2 - Determine the difference
        Dnew = D(1);
        Dnew.force = abs(diff([D(1).force,D(2).force],1,2));

    % 2.3 - Add new profile to the current file list and data structure
        list = get(h.currentfile,'String');
        newprofile = ['Diff_',num2str(length(list)+1)];
        set(h.currentfile,'String',[list;newprofile]);
        GUI.HPM(length(list)+1) = Dnew;

% 3 - RETURN DATA STRUCTURE TO GUI
    guidata(hObject,GUI); 
   


            
            