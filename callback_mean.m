function callback_mean(hObject,eventdata)
% CALLBACK_MEAN calculates mean of selected curves
%__________________________________________________________________________
% SYNTAX: callback_mean(hObject,eventdata)
%
% DESCRIPTION:
%   hObject - is calling objects handle, must be associated with SMPtoolkit
%   eventdata = MATLAB required, not used
%
% PROGRAM OUTLINE:
% 1 - GATHER DATA FROM GUI
% 2 - DIFFERENCES IN SIZE BETWEEN DATA SETS
% 3 - COMPUTE MEAN WHEN PROFILES SHARE STEPSIZE
% 4 - COMPUTE MEAN WHEN PROFILES DO NOT SHARE STEPSIZE
% 5 - ADD THE NEW MEAN PROFILE TO LIST
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

    % 1.4 - Produce warning if only a single file is selected
        if length(D) < 2; 
            warndlg('Must select more than one file!','WARNINIG');
            return;
        end

% 2 - DIFFERENCES IN SIZE BETWEEN DATA SETS
    for i = 1:length(D); dzF(i) = D(i).dzF; end
    dtest = sum(diff(dzF));

% 3 - COMPUTE MEAN WHEN PROFILES SHARE STEPSIZE
    if dtest == 0;
        % 3.1 - Seperate data to approiate depth
            dpth = GUI.settings.meandistance;
            cnt  = dpth/dzF(1);
            for i = 1:length(D); d(:,i) = D(i).force(1:cnt); end

        % 3.2 - Build new data structure
            Dnew = D(1);
            Dnew.force = mean(d,2);
    end

% 4 - COMPUTE MEAN WHEN PROFILES DO NOT SHARE STEPSIZE
    if dtest ~= 0
        disp('Function not yet available for this case...');
        return;
    end

% 5 - ADD THE NEW MEAN PROFILE TO LIST
    list = get(h.currentfile,'String');
    newprofile = ['MEAN_',num2str(length(list)+1)];
    set(h.currentfile,'String',[list;newprofile]);
    GUI.HPM(length(list)+1) = Dnew;
    guidata(hObject,GUI);
