function callback_plotter(hObject,eventdata,varargin)
% CALLBACK_PLOTTER - plots the SMP data
%__________________________________________________________________________
%
%
%
%
%__________________________________________________________________________

% 1 - EXTRACTS THE DATA FROM THE GUI
    h = guihandles(hObject);            % Handles of current figure
    GUI = guidata(hObject);             % Stored data structure
    type = GUI.settings.type;           % Type of plot
    
    % Return if no data exists, providing a warning
    if ~isfield(GUI,'HPM');     
        warndlg('No file open.','Warning'); return; 
    end
    
% 2 - CLEAR THE OPEN FIGURES IF DESIRED
    clr = GUI.settings.clearfig;    % clearfig settings
    fig = GUI.figures;              % open figures
  
    % Check all figure handles and close if open
    if clr == 1; 
        hfig = findobj('Type','Figure','-not','Tag','SMPtoolkit'); 
        close(hfig); fig  = [];
    end
  
% 3 - ESTABLISH X-Y DATA EQUATIONS
switch type
    case 'Force';       xlab = 'Force (N)';
        X = 'd.force';
        Y = '0:d.dzF:(d.fsamp-1)*d.dzF';        
    case 'Pressure';    xlab = 'Pressure (MPa)';
        X = '(d.force ./ d.cF) .* d.cP';
        Y = '0:d.dzF:(d.fsamp-1)*d.dzF';     
    case 'Temperature'; xlab = 'Temperature (C)';
        X = 'd.temp';
        Y = '0:d.dzT:(d.tsamp-1)*d.dzT';
    otherwise
        mes = ['Error with plot type input: ',type,' is not a ',...
            'valid input.  Use Force, Pressure, or Temperature.',...
            '(callback_plotter.m)'];
        errordlg(mes,'ERROR'); return;       
end 

% 4 - EXTRACT DATA FROM STRUCTURE FOR PLOTTING
    % 4.1 - Seperate selected data
        idx = get(h.currentfile,'Value'); 
        leg = get(h.currentfile,'String');
        D = GUI.HPM(idx); L = leg(idx);
        C = {};

    % 4.2 - Seperate X-Y data
    for i = 1:length(D)
        % 4.2.1 - Seperate current data
            d = D(i); x = eval(X); y = eval(Y)';

        % 4.2.2 - Adjust for "air" if desired
            if GUI.settings.removeair == 1 || ~isempty(varargin);
                n   = length(x);                    % Total size
                idx = x > GUI.settings.removevalue; % Items outside of range
                ind = find(idx,1);                  % First item

        % 4.2.3 - Adjust for type of plot "air" or normal 
                if isempty(varargin)
                    x = x(ind:n); y = y(ind:n) - y(ind); % Cropped data
                elseif strcmpi(varargin{1},'air');
                    x = x(1:ind); y = y(1:ind);          % Cropped data
                end
            end

        % 4.2.4 - Check that data still exists
            if isempty(x)
                mes = [leg{i},' contains no data after "air" removed!'];
                warndlg(mes,'WARNING');
             end

        % 4.2.4 - Build array containing data to plot
            C = [C,x,y];       
    end

% 5 - PLOT THE DATA
    % 5.1 - Check that data exists
        if isempty(C);
           mes = 'No data exists after "air" removed!'; return;
        end

    % 5.2 - Plot the data 
    [newfig] = XYscatter(C,'xlabel',xlab,'ylabel','Depth (mm)',...
        'Yzoom','on','Ylimit','on','legend',L,'Ydir','reverse',...
        'Xlimit','on','Location','Best');
 
% 6 - RETURN THE FIGURE TO GUIDATA
    fig = [fig,newfig]; 
    GUI.figures = fig;
    guidata(hObject,GUI);
