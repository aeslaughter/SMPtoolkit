function callback_export(hObject,eventdata)
% CALLBACK_EXPORT saves the file to a text file with *.smp extension
%__________________________________________________________________________
% USAGE: callback_export(hObject,eventdata)
% INPUT: 
%   hObject     - handle of calling object
%   eventdata   - not used, MATLAB required
%       
% OUTPUT: none
%
% PROGRAM OUTLINE:
% 1 - EXTRACT THE DATA FROM THE GUI
% 2 - DETERMINE FILENAME FOR SAVING DATA
% 3 - WRITE THE DATA
%__________________________________________________________________________


disp('Not complete...');

% % 1 - EXTRACT THE DATA FROM THE GUI
%     h = guihandles(hObject);    % gui handles
%     GUI = guidata(hObject);     % gui data structure
%     d = GUI.HPM;                % SMP data
%     if isempty(d); return; end
% 
% % 2 - DETERMINE FILENAME FOR SAVING DATA
%     [file,loc] = uiputfile('*.smp','Save file as...');
%     filename = [loc,file];
% 
% % 3 - WRITE THE DATA
%     % 3.1 - Establsh labels and assoicated structure variables and formats
%     label = {'Force Step size (mm)','Temperature Step Size (mm)',...
%     'Version','Force Conversion (N/V)','Pressure Conversion (MPa/V)',...
%     'Zero Offest','Year','Month','Day','Hour','Minute','Second',...
%     'x-coordinate','y-coordinate','z-coordinate','Battery Voltage',...
%     'Average Speed (mm/s)','Force Sample Size','Temp. Sample Size'};
% 
%     flds = {'dzF','dzT','vers','cF','cP','zero_off','year','month','day',...
%     'hr','min','sec','xcoor','ycoor','zcoor','batt_V','vel','fsamp',...
%     'tsamp'};
% 
%     form = {'%f','%f','%i','%f','%f','%f','%i','%i','%i','%i','%i','%i',...
%     '%f','%f','%f','%f','%i','%i','%i'};
% 
%     % 3.2 - Write the header with SMP profile information
%     fid = fopen(filename,'w');
%     fprintf(fid,'%s\n',get(h.currentfile,'String'));
%     fprintf(fid,'%s\n','########################################');
%     for i = 1:length(label)
%         fprintf(fid,['%28s ',form{i},'\n'],[label{i},':'],d.(flds{i})); 
%     end
%     fprintf(fid,'%s\n','########################################');
%     
%     % 3.3 - Write the force data
%     fprintf(fid,'%s\n','#Force Data');
%     for i = 1:length(d.force)
%         fprintf(fid,'%f\n',d.force(i));
%     end
%     
%     % 3.4 - Write the temperature data
%     fprintf(fid,'%s\n','##Temperature Data');
%     for i = 1:length(d.temp)
%         fprintf(fid,'%f\n',d.temp(i));
%     end
% 
%     % 3.5 - Close the file
%     fclose(fid);
