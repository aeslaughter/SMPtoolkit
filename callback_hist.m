function callback_hist(hObject,eventdata)
% CALLBACK_HIST shows distribution of air signal
%__________________________________________________________________________
% SYNTAX: callback_hist(hObject,eventdata)
%
% DESCRIPTION:
%   hObject - is calling objects handle, must be associated with SMPtoolkit
%   eventdata = MATLAB required, not used
%
% PROGRAM OUTLINE:
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

% 2 - DISPLAY DISTRIBUTION OF "AIR" DATA
    for i = 1:length(D)
    
    % 2.1 - Seperate "air" signal
        d = D(i).force;                     % All force data
        idx = d > GUI.settings.removevalue; % Items outside of range
        ind = find(idx,1);                  % First item
        x = d(1:ind);                       % Cropped data

    % 2.2 - Build histogram
       [phat,pci] = getdist(x,'cdf','off');
       set(gcf,'Name',L{i});
	end



 