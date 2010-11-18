function GUI = pref(varargin)
% PREF applies, opens, and saves SMPtoolkit settings
%__________________________________________________________________________
% SYNTAX:
%   GUI = pref(filename,GUI)
%   GUI = pref(h,GUI)
%   GUI = pref(GUI,h)
%   GUI = pref(GUI,h,filename)
%
% DESCRIPTION:
%   GUI = pref(filename,GUI) opens 'filename' and applies the settings to
%           the GUI.settings structure.
%   GUI = pref(h,GUI) applies items in object with handle "h" (i.e. in the 
%           preferences window) to GUI.settings structure.
%   GUI = pref(GUI,h) applies the GUI.settings structure to the object with
%           handle "h"
%   GUI = pref(GUI,h,filename) applies the GUI.settings structure to the 
%           object with handle "h" and saves these settings to filename
%__________________________________________________________________________

% 1 - ESTABLISH HANDLES/STRUCTURE NAMES OF PERFERENCES
    item = {'type','clearfig','removeair','removevalue',...
            'movingaverage','meandistance'};
    type   = [0,1,1,1,1,1]; % 1 = numeric, 0 = character

% 2 - GATHER INPUT
    % 2.1 - Case when file is being open
    if ischar(varargin{1}) && exist(varargin{1},'file');
        fid = fopen(varargin{1});
        a   = textscan(fid,'%s','delimiter','\n'); a = a{1};
        fclose(fid);
        GUI = varargin{2};
        h = [];

    % 2.2 - Apply preferences to GUI settings
    elseif ishandle(varargin{1}) && length(varargin) == 2;
        GUI = varargin{2};
        h = guihandles(varargin{1});
        a = getitems(h,item);

    % 2.3 - Case when saving settings/opening preferences window
    elseif isstruct(varargin{1})
        GUI = varargin{1};
        h = guihandles(varargin{2});

        % 2.3.1 - Items to set the current preferences window
        nm  = fieldnames(GUI.settings); 
        for i = 1:length(nm); a{i} = GUI.settings.(nm{i}); end
          
        % 2.3.2 - Open the file for saving
        if length(varargin) == 3
            fid = fopen(varargin{3},'w');
            for i = 1:length(a);
                if ~ischar(a{i}); a{i} = num2str(a{i}); end
                fprintf(fid,'%s\n',a{i});
            end
            fclose(fid);
        end
    end

% 3 - APPLY SETTINGS
for i = 1:length(item);
    % 3.1 - Apply setting to the preferences window
    if ~isempty(h); setitem(h,item{i},a{i}); end
   
    % 3.2 - Apply setting to GUI structure
    if type(i) == 1 && ~isnumeric(a{i});  a{i} = str2double(a{i}); end
    GUI.settings.(item{i}) = a{i};
end

%--------------------------------------------------------------------------
% SUBFUNCTION: setitem
function setitem(h,item,value)
% SETITEM inserts GUI.settings value into preferences window

switch get(h.(item),'Style');
    case 'checkbox'
        if ~isnumeric(value); value = str2double(value); end
        set(h.(item),'Value',value);
    case 'edit'
        set(h.(item),'String',value);
    case 'popupmenu'
        str = get(h.(item),'String');
        idx = strmatch(value,str);
        set(h.(item),'Value',idx);
end
        
%--------------------------------------------------------------------------
% SUBFUNCTION: getitems
function a = getitems(h,items)
% GETITEMS gathers items from preferences window

for i = 1:length(items);
    item = items{i} ;
    switch get(h.(item),'Style');
        case 'checkbox'
            a{i} = get(h.(item),'Value');
        case 'edit'
            a{i} = get(h.(item),'String');
        case 'popupmenu'
            str = get(h.(item),'String');
            idx = get(h.(item),'Value');
            a{i}= str{idx};
end,end
        

    



