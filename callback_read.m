function callback_read(hObject,eventdata,varargin)
% CALLBACK_READ reads data from *.pnt files or *.smp files
%__________________________________________________________________________
% SYNTAX: 
%   callback_read(hObject,eventdata,varargin)
%
% INPUT: 
%   hObject     - handle of calling object
%   eventdata   - not used, MATLAB required
%   varargin{1} - if included it should contain the filename to open
%
% PROGRAM OUTLINE:
% 1 - GATHER SMPTOOLKIT DATA
% 2 - DETEMINE THE FILE(S) TO OPEN
% 3 - READ *.pnt FILES (extract the data structure)
% 4 - READ *.smp WORKSPACE FILES
% 5 - UPDATE THE RECENTLY OPENED FILES LIST AND GUI
%__________________________________________________________________________

% 1 - GATHER SMPTOOLKIT DATA
    GUI = guidata(hObject);
    loc = GUI.location;
    h   = guihandles(hObject);

% 2 - DETEMINE THE FILE(S) TO OPEN
if isempty(varargin)
    % 2.1 - Case when no filename is provided
        fspec = {'*.pnt','Raw (*.pnt)';'*.smp','SMPtookit (*.smp)'};
        [file,loc,fidx] = uigetfile(fspec,'Select file...',loc,...
            'MultiSelect','on');
        if isnumeric(file); return;
    elseif ischar(file); file = {file}; end
        
    % 2.2 - Case when the filename was included    
    else
        % 2.2.1 - Test that file exists
            filename{1} = varargin{1};
            [loc,nm,extn] = fileparts(filename{1}); file{1} = [nm,extn];
            if ~exist(filename{1},'file');
                mes = 'File does not exist (see callback_read).';
                errordlg(mes,'ERROR');return;
            end
        
        % 2.2.2 - Set the "fidx" parameter based in extension
            if      strcmpi('.pnt',extn); fidx = 1;
            elseif  strcmpi('.smp',extn); fidx = 2;
            else                          return;
            end
end

    % 2.3 - Set the new folder location
        GUI.location = loc;
        guidata(hObject,GUI);

% 3 - READ *.pnt FILES (extract the data structure)
if fidx == 1;
K = 0; if isfield(GUI,'HPM'); K = length(GUI.HPM); end

for i = 1:length(file)
    % 3.1 - Seperate filename
        filename{i} = [loc,'\',file{i}];
        [p,n,ext] = fileparts(filename{i});

    % 3.2 - Open and store data file

        d = readSMP(filename{i},GUI.temp);  % Reads *.pnt file    
        GUI.HPM(K+i)  = d;                  % Store SMP profile data
        GUI.list{K+i} = [n,ext];            % Stores profile filename
end,end

% 4 - READ *.smp WORKSPACE FILES
if fidx == 2;
    % 4.1 - Produce warning for multiple files
    if length(file) > 1;
        mes = 'Only a single workspace may be opened at a time!';
        warndlg(mes,'Warning!');
    end

    % 4.2 - Create temporary *.mat file for opening
        filename = [loc,'\',file{1}];
        copyfile(filename,'temp.mat','f');

    % 4.3 - Extract the data structure
        G = load('temp.mat'); delete('temp.mat');
        GUI = G.GUI;
end

% 5 - UPDATE THE RECENTLY OPENED FILES LIST AND GUI
    set(h.currentfile,'String',GUI.list);           % Update list 
    callback_openrecent(1,1,'update',filename);     % Update recent.txt
    guidata(hObject,GUI);                           % Return data to GUI
    callback_insertdata(h.currentfile,[]);          % Insert the 1st item