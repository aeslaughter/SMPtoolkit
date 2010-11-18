function callback_smooth(hObject,eventdata,type)
% CALLBACK_SMOOTH smooths data according to specified type
%__________________________________________________________________________
%
% SYNTAX: callback_smooth(hObject,eventdata,type)
%
% DESCRIPTION:
%   hObject - is calling objects handle, must be associated with SMPtoolkit
%   eventdata = MATLAB required, not used
%   type = 'moving': performs simple moving average over distance specified
%                    in preferences.
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

    % 1.3 - Seperate selected data
        idx = get(h.currentfile,'Value'); 
        leg = get(h.currentfile,'String');
        D = GUI.HPM(idx); L = leg(idx);
    
% 2 - PERFORM SMOOTHING ON EACH OF THE SELECTED PROFILES
for i = 1:length(D); 
    switch lower(type)

    % 2.1 - Perform simple, unweight moving average
    case 'moving'
        cnt = GUI.settings.movingaverage;
        windowSize = cnt/D(i).dzF;
        Dnew = D(i);
        Dnew.force = filter(ones(1,windowSize)/windowSize,1,D(i).force);
    end


    % 2.x - Add new profile to the current file list and data structure
        list = get(h.currentfile,'String');
        newprofile = ['Avg_',L{i}];
        set(h.currentfile,'String',[list;newprofile]);
        GUI.HPM(length(list)+1) = Dnew;
    
end

% 3 - RETURN DATA STRUCTURE TO GUI
    guidata(hObject,GUI);



    