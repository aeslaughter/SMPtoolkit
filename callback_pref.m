function varargout = callback_pref(varargin)
% CALLBACK_PREF M-file for callback_pref.fig, which was generated using
% MATLAB's GUIDE application
%__________________________________________________________________________
% USAGE: callback_pref(SMPgui)
%
% INPUT: SMPgui = handle for the main SMPtoolkit figure
% OUTPUT: none
%
% PROGRAM OUTLINE:
% 1 - BEGIN INITIALIZATION CODE - DO NOT EDIT (GUIDE)
% 2 - EXECUTES JUST BEFORE CALLBACK_PREF IS MADE VISIBLE (GUIDE)
% 3 - OUTPUTS FROM THIS FUNCTION ARE RETURNED TO THE COMMAND LINE (GUIDE)
%
% NOTES: 
% - Sections 1-3 where created by GUIDE and should not be eddited, with the
%   exception of Section 2.1:   
% - The following callbacks where set using the Property Inspector of GUIDE
%     Save: callback_savepref('callback_savepref',gcbo,[],guihandles(gcbo))
%     Open: callback_openpref('callback_openpref',gcbo,[],guihandles(gcbo))
%     Apply: callback_pref('callback_apply',gcbo,[],guihandles(gcbo))
%     Done:  close(gcf)
%     Temp.: winopen('tempconstants.txt')
%__________________________________________________________________________

% 1 - BEGIN INITIALIZATION CODE - DO NOT EDIT (GUIDE)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @callback_pref_OpeningFcn, ...
                       'gui_OutputFcn',  @callback_pref_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT

% 2 - EXECUTES JUST BEFORE CALLBACK_PREF IS MADE VISIBLE (GUIDE)
function callback_pref_OpeningFcn(hObject, eventdata, handles, varargin)
        handles.output = hObject;
        guidata(hObject, handles);
        
        % 2.1 - Custom portion of Section 2
        set(hObject,'UserData',varargin{1});  % Handle of calling function
        pref(guidata(varargin{1}),hObject);   % Apply current settings
            
% 3 - OUTPUTS FROM THIS FUNCTION ARE RETURNED TO THE COMMAND LINE (GUIDE)
function varargout = callback_pref_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
   
%-------------------------------------------------------------------------- 
% 4 - CALLBACK_APPLY:
function callback_apply(hObject,eventdata,handles)
    gui = get(handles.figure1,'UserData');      % Handle of SMPtoolkit GUI
    GUI = guidata(gui);                         % Data structure
    GUI = pref(hObject,GUI);                    % Apply settings
    guidata(gui,GUI);                           % Set the values to GUI

%--------------------------------------------------------------------------
% 5 - CALLBACK_SAVEPREF:
function callback_savepref(hObject,eventdata,handles)
    gui = get(handles.figure1,'UserData');      % Handle of SMPtoolkit GUI
    GUI = guidata(gui);                         % Data structure

    fspec = {'*.sprf','SMPtoolkit Preferences (*.sprf)'};
    [FileName,PathName] = uiputfile(fspec,'Savet file as...',GUI.location);

    GUI = pref(GUI,hObject,[PathName,FileName]);% Save preferences
    guidata(gui,GUI);                           % Set the values to GUI

%--------------------------------------------------------------------------
% 6 - CALLBACK_OPENPREF:
function callback_openpref(hObject,eventdata,handles)
    gui = get(handles.figure1,'UserData');      % Handle of SMPtoolkit GUI
    GUI = guidata(gui);                         % Data structure

    fspec = {'*.sprf','SMPtoolkit Preferences (*.sprf)'};
    [FileName,PathName] = uigetfile(fspec,'Select file...',GUI.location);

    GUI = pref(GUI,[PathName,FileName]);        % Open the file
    guidata(gui,GUI);                           % Set the values to GUI
    










                
        
        
