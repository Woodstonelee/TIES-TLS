function varargout = GUI_SP_EstStemSection(varargin)
% GUI_SP_ESTSTEMSECTION M-file for GUI_SP_EstStemSection.fig
%      GUI_SP_ESTSTEMSECTION, by itself, creates a new GUI_SP_ESTSTEMSECTION or raises the existing
%      singleton*.
%
%      H = GUI_SP_ESTSTEMSECTION returns the handle to a new GUI_SP_ESTSTEMSECTION or the handle to
%      the existing singleton*.
%
%      GUI_SP_ESTSTEMSECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SP_ESTSTEMSECTION.M with the given input arguments.
%
%      GUI_SP_ESTSTEMSECTION('Property','Value',...) creates a new GUI_SP_ESTSTEMSECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SP_EstStemSection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SP_EstStemSection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SP_EstStemSection

% Last Modified by GUIDE v2.5 14-Jul-2011 16:10:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SP_EstStemSection_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SP_EstStemSection_OutputFcn, ...
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


% --- Executes just before GUI_SP_EstStemSection is made visible.
function GUI_SP_EstStemSection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SP_EstStemSection (see VARARGIN)

% Choose default command line output for GUI_SP_EstStemSection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SP_EstStemSection wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.edit_PtsTreeIDFile, 'String', '');

set(handles.edit_cellsize, 'String', '0.01');
set(handles.edit_maxR, 'String', '50');
set(handles.edit_minnumfit, 'String', '9');
set(handles.edit_sigmacoef, 'String', '1');
set(handles.edit_epsion, 'String', '0.001');
set(handles.edit_maxIter, 'String', '100');

set(handles.radiobutton_SingleScanData, 'Value', get(handles.radiobutton_SingleScanData, 'Min'));
set(handles.radiobutton_CompleteScanData, 'Value', get(handles.radiobutton_CompleteScanData, 'Max'));
set(handles.uitable_ScanPos, 'Enable', 'off');
set(handles.pushbutton_Default, 'Enable', 'off');

set(handles.uitable_EstCircle, 'Data', cell(1,4));
set(handles.uitable_ArcAngle, 'Data', cell(1,3));
set(handles.uitable_HTCircle, 'Data', cell(1,4));
set(handles.uitable_IterInfo, 'Data', cell(1,4));
set(handles.text_Remark, 'String', 'Remark for the Estimation Result: ');

set(handles.edit_InitialPtsNum, 'Enable', 'inactive');


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SP_EstStemSection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_PtsTreeIDFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PtsTreeIDFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PtsTreeIDFile as text
%        str2double(get(hObject,'String')) returns contents of edit_PtsTreeIDFile as a double


% --- Executes during object creation, after setting all properties.
function edit_PtsTreeIDFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PtsTreeIDFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_PtsTreeIDFile.
function pushbutton_PtsTreeIDFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PtsTreeIDFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_PtsTreeIDFile, 'String');
[FileName,PathName] = uigetfile({'*.txt', 'arrTree_*.txt Files (*.txt)'},'Select ascii file of point clouds of stems with tree ID:', initialpath);
if ~FileName
    return;
end
set(handles.edit_PtsTreeIDFile, 'UserData', PathName);
set(handles.edit_PtsTreeIDFile, 'String', fullfile(PathName, FileName));



function edit_OutputDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to edit_OutputDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_OutputDirectory as text
%        str2double(get(hObject,'String')) returns contents of edit_OutputDirectory as a double


% --- Executes during object creation, after setting all properties.
function edit_OutputDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_OutputDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_OutputDirectory.
function pushbutton_OutputDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OutputDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_OutputDirectory, 'UserData');
SavePathName= uigetdir(initialpath, 'Select output directory:');
if ~SavePathName
    return;
end
set(handles.edit_OutputDirectory, 'UserData', SavePathName);
set(handles.edit_OutputDirectory, 'String', SavePathName);



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
tempstr = get(handles.edit_PtsTreeIDFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
DataPathName = pathstr;
DataPtsFileName = [name, ext];

tempstr = get(handles.edit_cellsize, 'String');
cellsize = str2double(tempstr);
if isnan(cellsize)
    errordlg('Cell size used in Hough transform: invalid input!', 'Bad Input', 'modal');
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

% read points from input ascii file
tempdata = importdata(fullfile(DataPathName, DataPtsFileName));
if iscell(tempdata)
    tempdata = cell2mat(tempdata);
end
if size(tempdata, 2)<2
    errordlg('At least two columns are required in the input file for the x and y of points! Please check the file content!', 'Input File Content Error', 'modal');
    return;
end
x = tempdata(:, 1);
y = tempdata(:, 2);
if size(tempdata, 2)>2
    z = tempdata(:, 3);
    zc = (max(z)+min(z))/2;
else
    zc = NaN;
end
set(handles.edit_InitialPtsNum, 'String', num2str(length(x)));
if SingleScanFlag
    [detectedcircle, mapfinalHTcircle, iterationdata, ArcInfo, ~, ~, ~, ~, DebugInfo] = ...
        mexDetEstCircle_Half(x, y, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit, initialTranslateVector_Data);
else
    [detectedcircle, mapfinalHTcircle, iterationdata, ArcInfo, ~, ~, DebugInfo] = ...
        mexDetEstCircle_Complete(x, y, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit);
end
clear functions;

MyData = cell(1, 4);
if isempty(detectedcircle)
    MyData = num2cell(NaN(1, 4));
else
    MyData(1) = {detectedcircle(2)};
    MyData(2) = {detectedcircle(1)};
    MyData(3) = {zc};
    MyData(4) = {detectedcircle(3)};
end
set(handles.uitable_EstCircle, 'Data', MyData);

MyData = cell(1, 3);
if isempty(ArcInfo)
    MyData = num2cell(NaN(1, 3));
else
    MyData(1) = {ArcInfo(1)};
    MyData(2) = {ArcInfo(2)};
    MyData(3) = {ArcInfo(3)};
end
set(handles.uitable_ArcAngle, 'Data', MyData);

MyData = cell(1, 4);
if isempty(mapfinalHTcircle)
    MyData = num2cell(NaN(1, 4));
else
    MyData(1) = {mapfinalHTcircle(2)};
    MyData(2) = {mapfinalHTcircle(1)};
    MyData(3) = {mapfinalHTcircle(3)};
    if isempty(DebugInfo)
        DebugInfo = NaN;
    end
    MyData(4) = {DebugInfo(1)};
end
set(handles.uitable_HTCircle, 'Data', MyData);

MyData = cell(1, 4);
if isempty(iterationdata)
    MyData = num2cell(NaN(1, 4));
else
    MyData(1) = {iterationdata(1)};
    MyData(2) = {iterationdata(2)};
    MyData(3) = {iterationdata(3)};
    MyData(4) = {iterationdata(4)};
end
set(handles.uitable_IterInfo, 'Data', MyData);

if isempty(detectedcircle) && isempty(mapfinalHTcircle)
    if iterationdata(1)==0 && isnan(iterationdata(2)) && isnan(iterationdata(3))
        remarkstr = ['Remark for the Estimation Result: ', 'This stem section contains no enough points(less than minnumfit) or circle fitting at the first time failed before starting iteration.'];
    elseif iterationdata(1)==0 && isinf(iterationdata(2)) && isinf(iterationdata(3))
        remarkstr = ['Remark for the Estimation Result: ', 'In the first iteration, Hough Transform failed or no enough points were picked out by the Region of Interest or circle fitting failed.'];
    else
        remarkstr = ['Remark for the Estimation Result: ', 'After running iteratively for a few times, Hough Transform failed or no enough points were picked out by the Region of Interest or circle fitting failed or the estimate circle is invalid (point density in neighborhood of estimate center is greater than 1 which means points shape a solid circle but not a circumference, or iteration count reached the maximum but change of center or radius did not reach the given threshold).'];
    end
else
    if iterationdata(1)==0 && isnan(iterationdata(2)) && isnan(iterationdata(3))
        remarkstr = ['Remark for the Estimation Result: ', 'The circle center derived by Hough Transform locates outside the image rasterized from the input points.'];
    else
        remarkstr = ['Remark for the Estimation Result: ', 'Estimation successfully.'];
        
    end
end
set(handles.text_Remark, 'String', remarkstr);


% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_PtsTreeIDFile, 'String', '');

set(handles.edit_cellsize, 'String', '0.01');
set(handles.edit_maxR, 'String', '50');
set(handles.edit_minnumfit, 'String', '9');
set(handles.edit_sigmacoef, 'String', '1');
set(handles.edit_epsion, 'String', '0.001');
set(handles.edit_maxIter, 'String', '100');

set(handles.radiobutton_SingleScanData, 'Value', get(handles.radiobutton_SingleScanData, 'Min'));
set(handles.radiobutton_CompleteScanData, 'Value', get(handles.radiobutton_CompleteScanData, 'Max'));
set(handles.uitable_ScanPos, 'Enable', 'off');
set(handles.pushbutton_Default, 'Enable', 'off');

set(handles.uitable_EstCircle, 'Data', cell(1,4));
set(handles.uitable_ArcAngle, 'Data', cell(1,3));
set(handles.uitable_HTCircle, 'Data', cell(1,4));
set(handles.uitable_IterInfo, 'Data', cell(1,4));
set(handles.text_Remark, 'String', 'Remark for the Estimation Result: ');

set(handles.edit_InitialPtsNum, 'String', '');

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


% --- Executes when selected cell(s) is changed in uitable_ScanPos.
function uitable_ScanPos_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_ScanPos (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_ClearAll.
function pushbutton_ClearAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ClearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.uitable_EstCircle, 'Data', cell(1,4));
set(handles.uitable_ArcAngle, 'Data', cell(1,3));
set(handles.uitable_HTCircle, 'Data', cell(1,4));
set(handles.uitable_IterInfo, 'Data', cell(1,4));
set(handles.text_Remark, 'String', 'Remark for the Estimation Result: ');
set(handles.edit_InitialPtsNum, 'String', '')



function edit_InitialPtsNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_InitialPtsNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_InitialPtsNum as text
%        str2double(get(hObject,'String')) returns contents of edit_InitialPtsNum as a double


% --- Executes during object creation, after setting all properties.
function edit_InitialPtsNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_InitialPtsNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
