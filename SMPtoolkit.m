function gui = SMPtoolkit
% SMPTOOLKIT is a GUI application for reading, viewing, analyzing, and
% exporting data from the SnowMicroPen.
%__________________________________________________________________________
% SYNTAX: SMPtoolkit
% INPUT: none
% OUTPUT: 
%   gui = handle from the GUI interface.  The handles for this gui
%           are stored in the guidata and the 'UserData' option
%           includes the data structure as given below.
%
%          S = guidata(gui);
%          S.HPM     = data structure as defined by H.P. Marshall
%          S.figures = array of opened plot figures
%          S.temp    = array of temperature calibration numbers
%          S.settings
%               .clearfig = 1 or 0 indicating if new figures are deleted
%               .type     = 'Force', 'Pressure', or 'Temperature'
%
%
% PROGRAM INFORMATION:
%   This program was developed by Andrew E. Slaughter at Montana State
%   University and is intended for research purposes only, commercial use
%   is prohibited.  Please direct comments, suggestions, and errors to:
%
%       Andrew E. Slaughter
%       slaughter@montana.edu
%       (406) 582 - 8429
%
%   Portions of this code where adapted from code written by Hans-Peter
%   Marshall, specifically (readSMP.m) and the associated data structure.  
%   This software wouldn't function without it, Thanks!
%
%   Copyright - Andrew E. Slaughter, 2008
%   Last Updated: 4/27/2008
%
% PROGRAM OUTLINE:
% 1 - INITILIZE THE GUI DATA STRUCTURE
% 2 - OPEN THE GUI AND SET CALLBACKS
% SUBFUNCTION: gettempconstants
% CALLBACK: callback_exit
% CALLBACK: callback_about
% CALLBACK: callback_help
% CALLBACK: callback_plotter
%__________________________________________________________________________

% 1 - INITILIZE THE GUI DATA STRUCTURE
    % 1.1 - Build the basic structure using dumby arguments
        GUI.temp    = [];          % Device dependant calibration constants
        GUI.figures = [];          % Array of plot handles
      
    % 1.2 - Set the program default preferences and set save locations
        GUI = pref('default.sprf',GUI); 
        GUI.location = [cd,'\'];
        GUI.list = {};
               
    % 1.3 - Read the temperature calibration file
        GUI.temp = gettempconstants;

% 2 - OPEN THE GUI AND INITILIZE MENUS
    % 2.1 - Open GUI and set guidata to include the handles
        gui = SMPgui;               % SMPgui.m->SMPgui.fig (Built w/ GUIDE)
        set(gui,'Tag','SMPtoolkit');% Sets tag of SMPtoolkit window
        h = guihandles(gui);        % Data structure of GUI handles
        guidata(gui,GUI);           % Sets guidata to include the handles
              
    % 2.2 - Establish file selection menu items
        set(h.currentfile,'Callback',{'callback_insertdata'});
        set(h.filemenu,'Callback',{'callback_openrecent','build',gui});

    % 2.3 - Build contextmenu for file list
        cmenu = uicontextmenu('Parent',gui);
        set(h.currentfile,'UIContextMenu',cmenu);
        uimenu(cmenu,'Label','Remove Selected','Callback',...
                {'callback_edit','remove'});
        uimenu(cmenu,'Label','Change name(s)','Callback',...
                {'callback_edit','change'});

% 3 - ESTABLISH MENU CALLBACKS
    % 3.1 - File Menu
        set(h.openfile,'Callback',{'callback_read'});
        set(h.saveworkspace,'Callback',{@callback_saveworkspace});
        set(h.exportdata,'Callback',{'callback_export'});
        set(h.pref,'Callback',{'callback_pref'});
        set(h.exit,'Callback',{@callback_exit});
        
    % 3.2 - Export Menu
        set(h.mmcreadR,'Callback',{'callback_mmcread','R'});
        set(h.mmcreadA,'Callback',{'callback_mmcread','A'});

    % 3.3 - Analysis Menu
    	set(h.plotsmp,'Callback',{'callback_plotter'});
    	set(h.plotsmpair,'Callback',{'callback_plotter','air'});
        set(h.movingavg,'Callback',{'callback_smooth','moving'});
        set(h.mean,'Callback',{'callback_mean'});
        set(h.airdistribution,'Callback',{'callback_hist'});
        set(h.diff,'Callback',{'callback_diff'});
        
    % 3.4 - Help Menu
        set(h.help,'Callback',{@callback_help});
        set(h.about,'Callback',{@callback_about});
        
%--------------------------------------------------------------------------     
% SUBFUNCTION: gettempconstants - opens the file (tempconstants.txt), which
% contains the calibration constants.  If this file does not exist the
% values supplied by H.P. Marshall are utilized.
function tc = gettempconstants

    try
        tc = dlmread('tempconstants.txt');
    catch
        mes = ['The temperature constants file: tempconstants.txt ',...
            'does not exist.  The SMPtoolkit is using assumed ',...
            'values, which may cause erronous results.',...
            'If you would like to create a file see the program ',...
            'preferences option in the file menu.'];
        warndlg(mes,'!!! Warning !!!');
        tc = [-0.018205007,0.0078710989,-0.00098275584,4.2608056e-5];
    end
    
%--------------------------------------------------------------------------
% CALLBACK: callback_exit - Quits the SMPtoolkit
function callback_exit(hObject,eventdata)
    close('all');

%--------------------------------------------------------------------------    
% CALLBACK: callback_help - Opens the program documentation   
function callback_help(hObject,eventdata)
    winopen('help.pdf');
    
%--------------------------------------------------------------------------    
% CALLBACK: callback_about - Opens a message regarding the SMPtoolkit        
function callback_about(hObject,eventdata)
    m{3} = ['SMPtoolkit was created by Andrew E. Slaughter and ',...
       'may only be used for academic research.  ',...
       'Commercial use is prohibitted.'];
    m{1} = 'Copyright 2008, Andrew E. Slaughter';
    m{5} = ['The m-file readSMP.m was adapted from code provided by ',...
       'Hans-Peter Marshall'];
    msgbox(m,'About SMPtoolkit');   

%--------------------------------------------------------------------------
% CALLBACK: callback_saveworkspace - saves the guidata structure
function callback_saveworkspace(hObject,eventdata)

% Detemine the filename for saving data
    [file,loc] = uiputfile('*.smp','Save file as...');
    if file == 0; return; end;
    filename = [loc,file];

% Save the data structure to file
    GUI = guidata(hObject);
    save(filename,'GUI');
    
    