function varargout = GUI_SP_DBHandTH(varargin)
% GUI_SP_DBHANDTH M-file for GUI_SP_DBHandTH.fig
%      GUI_SP_DBHANDTH, by itself, creates a new GUI_SP_DBHANDTH or raises the existing
%      singleton*.
%
%      H = GUI_SP_DBHANDTH returns the handle to a new GUI_SP_DBHANDTH or the handle to
%      the existing singleton*.
%
%      GUI_SP_DBHANDTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SP_DBHANDTH.M with the given input arguments.
%
%      GUI_SP_DBHANDTH('Property','Value',...) creates a new GUI_SP_DBHANDTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SP_DBHandTH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SP_DBHandTH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SP_DBHandTH

% Last Modified by GUIDE v2.5 21-Jul-2011 17:03:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SP_DBHandTH_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SP_DBHandTH_OutputFcn, ...
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


% --- Executes just before GUI_SP_DBHandTH is made visible.
function GUI_SP_DBHandTH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SP_DBHandTH (see VARARGIN)

% Choose default command line output for GUI_SP_DBHandTH
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SP_DBHandTH wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.edit_BreastHeight, 'String', '1.3');
set(handles.edit_ExtentRadius, 'String', '0.5');

set(handles.edit_cellsize, 'String', '0.01');
set(handles.edit_slicethick, 'String', '0.1');
set(handles.edit_maxR, 'String', '50');
set(handles.edit_minnumfit, 'String', '9');
set(handles.edit_sigmacoef, 'String', '1');
set(handles.edit_epsion, 'String', '0.001');
set(handles.edit_maxIter, 'String', '100');

set(handles.radiobutton_SingleScanData, 'Value', get(handles.radiobutton_SingleScanData, 'Min'));
set(handles.radiobutton_CompleteScanData, 'Value', get(handles.radiobutton_CompleteScanData, 'Max'));
set(handles.uitable_ScanPos, 'Enable', 'off');
set(handles.pushbutton_Default, 'Enable', 'off');


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SP_DBHandTH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_PtsFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PtsFile as text
%        str2double(get(hObject,'String')) returns contents of edit_PtsFile as a double


% --- Executes during object creation, after setting all properties.
function edit_PtsFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_PtsFile.
function pushbutton_PtsFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_PtsFile, 'String');
[FileName,PathName] = uigetfile({'*.txt', '*.txt Files (*.txt)'},'Select ascii file of original point clouds:', initialpath);
if ~FileName
    return;
end
set(handles.edit_PtsFile, 'UserData', PathName);
set(handles.edit_PtsFile, 'String', fullfile(PathName, FileName));



function edit_DBHTHFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DBHTHFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DBHTHFile as text
%        str2double(get(hObject,'String')) returns contents of edit_DBHTHFile as a double


% --- Executes during object creation, after setting all properties.
function edit_DBHTHFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DBHTHFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_DBHTHFile.
function pushbutton_DBHTHFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DBHTHFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_DBHTHFile, 'String');
[FileName,PathName] = uiputfile({'*.txt', 'DBH&TH_*.txt Files (*.txt)'},'Select ascii file for outputting DBH and Tree Height:', [initialpath, '\DBH&TH_.txt']);
if ~FileName
    return;
end
set(handles.edit_DBHTHFile, 'UserData', PathName);
set(handles.edit_DBHTHFile, 'String', fullfile(PathName, FileName));



function edit_maxR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxR as text
%        str2double(get(hObject,'String')) returns contents of edit_maxR as a double
if isempty(get(hObject, 'string'))
    return;
end

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
	return
end


% --- Executes during object creation, after setting all properties.
function edit_maxR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cellsize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cellsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cellsize as text
%        str2double(get(hObject,'String')) returns contents of edit_cellsize as a double
if isempty(get(hObject, 'string'))
    return;
end

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
	return
end


% --- Executes during object creation, after setting all properties.
function edit_cellsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cellsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_slicethick_Callback(hObject, eventdata, handles)
% hObject    handle to edit_slicethick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_slicethick as text
%        str2double(get(hObject,'String')) returns contents of edit_slicethick as a double
if isempty(get(hObject, 'string'))
    return;
end

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
	return
end


% --- Executes during object creation, after setting all properties.
function edit_slicethick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_slicethick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_minnumfit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minnumfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minnumfit as text
%        str2double(get(hObject,'String')) returns contents of edit_minnumfit as a double
if isempty(get(hObject, 'string'))
    return;
end

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
	return
end


% --- Executes during object creation, after setting all properties.
function edit_minnumfit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minnumfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_epsion_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epsion as text
%        str2double(get(hObject,'String')) returns contents of edit_epsion as a double
if isempty(get(hObject, 'string'))
    return;
end

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
	return
end


% --- Executes during object creation, after setting all properties.
function edit_epsion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sigmacoef_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigmacoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigmacoef as text
%        str2double(get(hObject,'String')) returns contents of edit_sigmacoef as a double
if isempty(get(hObject, 'string'))
    return;
end

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
	return
end


% --- Executes during object creation, after setting all properties.
function edit_sigmacoef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigmacoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxIter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxIter as text
%        str2double(get(hObject,'String')) returns contents of edit_maxIter as a double
if isempty(get(hObject, 'string'))
    return;
end

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
	return
end


% --- Executes during object creation, after setting all properties.
function edit_maxIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Run.
function pushbutton_Run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tempstr = get(handles.edit_PtsFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files of original point clouds!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
PtsPathName = pathstr;
PtsFileName = [name, ext];

tempstr = get(handles.edit_StemBaseFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files of stem bases!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
StemBasePathName = pathstr;
StemBaseFileName = [name, ext];

tempstr = get(handles.edit_DBHTHFile, 'String');
[pathstr, name, ext] = fileparts(tempstr);
DBHTreeHPathName = pathstr;
DBHTreeHFileName = [name, ext];
if exist(DBHTreeHPathName, 'dir')~=7
    errordlg('No output directories!', 'Bad Output Directory', 'modal');
    return;
end

tempstr = get(handles.edit_BreastHeight, 'String');
BreastHeight = str2double(tempstr);
if isnan(BreastHeight)
    errordlg('The Breast Height: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_ExtentRadius, 'String');
ExtentRadius = str2double(tempstr);
if isnan(ExtentRadius)
    errordlg('The Radius of Cylinder: invalid input!', 'Bad Input', 'modal');
    return;
end

tempstr = get(handles.edit_cellsize, 'String');
cellsize = str2double(tempstr);
if isnan(cellsize)
    errordlg('Cell size used in Hough transform: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_slicethick, 'String');
SliceThick = str2double(tempstr);
if isnan(SliceThick)
    errordlg('Slice thickness along Z axis: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_maxR, 'String');
maxR = str2double(tempstr);
if isnan(maxR)
    errordlg('Maximum possible radius: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_minnumfit, 'String');
minnumfit = str2double(tempstr);
if isnan(minnumfit)
    errordlg('Minimum number of points to give a circle: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_sigmacoef, 'String');
sigmacoef = str2double(tempstr);
if isnan(sigmacoef)
    errordlg('Coefficient of standard deviation of radius to define ROI: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_epsion, 'String');
epsion = str2double(tempstr);
if isnan(epsion)
    errordlg('Minimum change of center position and radius: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_maxIter, 'String');
maxIter = str2double(tempstr);
if isnan(maxIter)
    errordlg('Maximum count of iterations: invalid input!');
    return;
end

if get(handles.radiobutton_SingleScanData, 'Value') == get(handles.radiobutton_SingleScanData, 'Max')
    SingleScanFlag = true;
    tempdata = get(handles.uitable_ScanPos, 'Data');
    if iscell(tempdata)
        initialTranslateVector_Data = cell2mat(tempdata);
    else
        initialTranslateVector_Data = tempdata;
    end
    if length(initialTranslateVector_Data)~=3
        errordlg('The position of scanner contains empty value!', 'Bad Input', 'modal');
        return;
    end
    if any(isnan(initialTranslateVector_Data))
        errordlg('The position of scanner contains invalid value!', 'Bad Input', 'modal');
        return;
    end
end
if get(handles.radiobutton_CompleteScanData, 'Value') == get(handles.radiobutton_CompleteScanData, 'Max')
    SingleScanFlag = false;
    initialTranslateVector_Data = zeros(1, 3);
end

[ReturnMsgStr, WarnMsgStr] = Fcn_EstDBHTreeHeight(PtsPathName, PtsFileName, ...
    StemBasePathName, StemBaseFileName, ...
    BreastHeight, ExtentRadius, ...
    SliceThick, cellsize, maxR, minnumfit, sigmacoef, epsion, maxIter, ...
    SingleScanFlag, initialTranslateVector_Data, ...
    DBHTreeHPathName, DBHTreeHFileName);
if isempty(WarnMsgStr)
    msgbox(ReturnMsgStr, 'modal');
else
    warndlg(WarnMsgStr, 'Estimate DBH and Tree Height', 'modal');
end



% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_BreastHeight, 'String', '1.3');
set(handles.edit_ExtentRadius, 'String', '0.5');

set(handles.edit_cellsize, 'String', '0.01');
set(handles.edit_slicethick, 'String', '0.1');
set(handles.edit_maxR, 'String', '50');
set(handles.edit_minnumfit, 'String', '9');
set(handles.edit_sigmacoef, 'String', '1');
set(handles.edit_epsion, 'String', '0.001');
set(handles.edit_maxIter, 'String', '100');

set(handles.radiobutton_SingleScanData, 'Value', get(handles.radiobutton_SingleScanData, 'Min'));
set(handles.radiobutton_CompleteScanData, 'Value', get(handles.radiobutton_CompleteScanData, 'Max'));
set(handles.uitable_ScanPos, 'Enable', 'off');
set(handles.pushbutton_Default, 'Enable', 'off');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton_SingleScanData.
function radiobutton_SingleScanData_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_SingleScanData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_SingleScanData


% --- Executes on button press in radiobutton_CompleteScanData.
function radiobutton_CompleteScanData_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_CompleteScanData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_CompleteScanData


% --- Executes on button press in pushbutton_Default.
function pushbutton_Default_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MyData = zeros(1, 3);
MyData = num2cell(MyData);
set(handles.uitable_ScanPos, 'Data', MyData);


% --- Executes when selected object is changed in uipanel5.
function uipanel5_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel5 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton_SingleScanData, 'Value')==get(handles.radiobutton_SingleScanData, 'Max')
    set(handles.uitable_ScanPos, 'Enable', 'on');
    set(handles.pushbutton_Default, 'Enable', 'on');
else
    set(handles.uitable_ScanPos, 'Enable', 'off');
    set(handles.pushbutton_Default, 'Enable', 'off');
end


% --- Executes when entered data in editable cell(s) in uitable_ScanPos.
function uitable_ScanPos_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_ScanPos (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.EditData)
    OldData = get(handles.uitable_ScanPos, 'Data');
    OldData = num2cell(OldData);
    OldData(eventdata.Indices(1), eventdata.Indices(2)) = {[]};
    set(hObject, 'Data', OldData);
    return;
end

user_entry = str2double(eventdata.EditData);
if isnan(user_entry)
    errordlg('You must enter a numeric value for the position of the scanner in the table','Bad Input','modal');
	return
end



function edit_StemBaseFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_StemBaseFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_StemBaseFile as text
%        str2double(get(hObject,'String')) returns contents of edit_StemBaseFile as a double


% --- Executes during object creation, after setting all properties.
function edit_StemBaseFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_StemBaseFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_StemBaseFile.
function pushbutton_StemBaseFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_StemBaseFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_StemBaseFile, 'String');
[FileName,PathName] = uigetfile({'*.txt', '*.txt Files (*.txt)'},'Select ascii file of stem bases:', initialpath);
if ~FileName
    return;
end
set(handles.edit_StemBaseFile, 'UserData', PathName);
set(handles.edit_StemBaseFile, 'String', fullfile(PathName, FileName));



function edit_BreastHeight_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BreastHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BreastHeight as text
%        str2double(get(hObject,'String')) returns contents of edit_BreastHeight as a double
if isempty(get(hObject, 'string'))
    return;
end

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
	return
end


% --- Executes during object creation, after setting all properties.
function edit_BreastHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BreastHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ExtentRadius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ExtentRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ExtentRadius as text
%        str2double(get(hObject,'String')) returns contents of edit_ExtentRadius as a double
if isempty(get(hObject, 'string'))
    return;
end

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
	return
end


% --- Executes during object creation, after setting all properties.
function edit_ExtentRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ExtentRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
