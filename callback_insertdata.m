function callback_insertdata(hObject,eventdata)
% CALLBACK_INSERTDATA displays selected file information in GUI
%__________________________________________________________________________
%
%
%
%__________________________________________________________________________

% 1 - GATHER *.PNT DATA FROM GUI   
    h   = guihandles(hObject);      % Handles of SMPtoolkit
    GUI = guidata(hObject);         % Data stored in SMPtoolkit
    idx = get(hObject,'Value');     % Selected files
    if isempty(idx); return; end    % Do nothing if list is empty
    d   = GUI.HPM(idx(1));          % Data of first file selected

% 2 - SET THE DATE, COORDINATES, AND FILENAME
    dt = datestr([d.year,d.month,d.day,d.hr,d.min,d.sec]);
    set(h.date,'String',dt);

% 3 - COORDINATES
    c = ['(',num2str(d.xcoor),',',num2str(d.ycoor),...
            ',',num2str(d.zcoor),')'];
    set(h.coord,'String',c);

% 3 - SET THE REMAINING INFORMATION
    tag = {'dzF','dzT','vers','cF','cP','zero_off','batt_V','vel',...
        'fsamp','tsamp'};
    for i = 1:length(tag);
        set(h.(tag{i}),'String',num2str(d.(tag{i})));
    end
