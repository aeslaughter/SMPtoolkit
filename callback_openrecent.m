function callback_openrecent(hObject,eventdata,action,varargin)
% CALLBACK_OPENRECENT updates the file recent.txt or the Open Recent option
% in the Program Control File Menu.
%__________________________________________________________________________
% USAGE: callback_openrecent(hObject,eventdata,action,varargin)
%
% INPUT: hObject = handle of calling function (not used with 'update')
%        eventdata = unused
%        action   = 'update' - updates recent.txt
%                 = 'build'  - called from File menu to build the sub menu
%        varargin{1}  = name of file that was opened ('update')
%                     = program control handle ('build')
%
% PROGRAM OUTLINE:
% 1 - UPDATE THE LIST OPTION (execute from readSLA)
% 2 - BUILD MENU OPTION (executes when file menu is pressed)
%__________________________________________________________________________

N = 10;                         % Number of file to include
fname  = [cd,'\recent.txt'];    % Storage location
recent = 'recent';              % Tag to add the list too

% 1 - UPDATE THE LIST OPTION (execute from readSLA)
if strcmpi(action,'update');
    SLAname = varargin{1};
    
    % 1.1 - Case when recent.txt file does not exist
        if ~exist(fname,'file'); type = 'w'; else type = 'r'; end

    % 1.2 - Collect filenames from recent.txt
        fid = fopen(fname,type);
        list = textscan(fid,'%s','delimiter','\n'); list = list{1}';
        fclose(fid);

    % 1.3 - Build the new list of filenames 
        newlist = unique([SLAname,list]);

    % 1.4 - Write the new file list to recent.txt
        nlist = length(newlist);
        if nlist > N; nlist = N; end
        fid = fopen('recent.txt','w+');
        for j = 1:nlist; fprintf(fid,'%s\n',newlist{j}); end
        fclose(fid); 
   
% 2 - BUILD MENU OPTION (executes when file menu is pressed)
elseif strcmpi(action,'build');
    h = guihandles(hObject);

    % 2.1 - Case when recent.txt file does not exist
    if ~exist(fname,'file'); set(h.(recent),'Visible','off'); return; end
    
    % 2.2 - Read the recent.txt file and get filenames
        set(h.(recent),'Visible','on');
        fid = fopen(fname);
        list = textscan(fid,'%s','delimiter','\n'); list = list{1};
        if isempty(list); set(h.(recent),'Visible','off'); return; end
        fclose(fid);

    % 2.3 - Build list of filenames
        for i = 1:length(list); 
            [p,n,e] = fileparts(list{i}); names{i} = [n,e];
        end

    % 2.4 - Remove objects from that may already be in the open
    % recent list (avoids duplicates)
        hh = get(h.(recent),'Children'); delete(hh);

    % 2.5 - Build buttons for each filename in the list
        for i = 1:length(list);
            uimenu(h.(recent),'Label',names{i},'Callback',...
                {'callback_read',list{i}});
        end
end
              