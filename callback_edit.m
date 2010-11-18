function callback_edit(hObject,eventdata,action)
% CALLBACK_EDIT allows user to change/remove files from the list
%__________________________________________________________________________
% SYNTAX:
%
% INPUT: 
%   hObject     - handle of calling object
%   eventdata   - not used, MATLAB required
%   action      - 'change' to change the names; 'remove' to remove items
%__________________________________________________________________________

% 1 - GATHER GUI INFORMATION
    h     = guihandles(hObject);
    GUI   = guidata(hObject);
    list  = get(h.currentfile,'String');
    idx   = get(h.currentfile,'Value');

% 2 - PERFORM DESIRED EDIT
switch lower(action);
    % 2.1 - Remove the selected items
    case 'remove'
        keep      = ones(1,length(list));
        keep(idx) = 0;
        keep      = logical(keep);
        GUI.list  = list(keep);
        GUI.HPM   = GUI.HPM(keep);

    % 2.2 - Renamne the selected items
    case 'change' 
        for i = 1:length(idx); prompt{i} = 'Enter new name:'; end
        newlist = inputdlg(prompt,'Edit names...',1,list(idx));
        if isempty(newlist); return; end
        for i = 1:length(idx); GUI.list{idx(i)} = newlist{i}; end
end

% 3 - UPDATE THE GUI
    set(h.currentfile,'String',GUI.list,'Value',1);
    guidata(hObject,GUI);
 