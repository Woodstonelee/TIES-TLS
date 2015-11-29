function varargout = GUI_SP_StemBottom2Top(varargin)
% GUI_SP_STEMBOTTOM2TOP M-file for GUI_SP_StemBottom2Top.fig
%      GUI_SP_STEMBOTTOM2TOP, by itself, creates a new GUI_SP_STEMBOTTOM2TOP or raises the existing
%      singleton*.
%
%      H = GUI_SP_STEMBOTTOM2TOP returns the handle to a new GUI_SP_STEMBOTTOM2TOP or the handle to
%      the existing singleton*.
%
%      GUI_SP_STEMBOTTOM2TOP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SP_STEMBOTTOM2TOP.M with the given input arguments.
%
%      GUI_SP_STEMBOTTOM2TOP('Property','Value',...) creates a new GUI_SP_STEMBOTTOM2TOP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SP_StemBottom2Top_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SP_StemBottom2Top_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SP_StemBottom2Top

% Last Modified by GUIDE v2.5 14-Jul-2011 09:29:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SP_StemBottom2Top_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SP_StemBottom2Top_OutputFcn, ...
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


% --- Executes just before GUI_SP_StemBottom2Top is made visible.
function GUI_SP_StemBottom2Top_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SP_StemBottom2Top (see VARARGIN)

% Choose default command line output for GUI_SP_StemBottom2Top
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SP_StemBottom2Top wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.edit_cellsize, 'String', '0.01');
set(handles.edit_slicethick, 'String', '0.1');
set(handles.edit_maxR, 'String', '50');
set(handles.edit_minnumfit, 'String', '9');
set(handles.edit_sigmacoef, 'String', '1');
set(handles.edit_epsion, 'String', '0.001');
set(handles.edit_maxIter, 'String', '100');

set(handles.edit_DeltaTheta, 'String', '0.1');
set(handles.edit1_DeltaPhi, 'String', '0.1');
set(handles.edit_Ratio, 'String', '0.4');
set(handles.edit_EpsionRMS, 'String', '0.05');
set(handles.edit_MinNumP, 'String', '6');

set(handles.radiobutton_SingleScanData, 'Value', get(handles.radiobutton_SingleScanData, 'Min'));
set(handles.radiobutton_CompleteScanData, 'Value', get(handles.radiobutton_CompleteScanData, 'Max'));
set(handles.uitable_ScanPos, 'Enable', 'off');
set(handles.pushbutton_Default, 'Enable', 'off');


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SP_StemBottom2Top_OutputFcn(hObject, eventdata, handles) 
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
initialpath = get(handles.edit_OutputDirectory, 'String');
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



function edit_DeltaTheta_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DeltaTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DeltaTheta as text
%        str2double(get(hObject,'String')) returns contents of edit_DeltaTheta as a double
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
function edit_DeltaTheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DeltaTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_DeltaPhi_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_DeltaPhi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_DeltaPhi as text
%        str2double(get(hObject,'String')) returns contents of edit1_DeltaPhi as a double
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
function edit1_DeltaPhi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_DeltaPhi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_EpsionRMS_Callback(hObject, eventdata, handles)
% hObject    handle to edit_EpsionRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_EpsionRMS as text
%        str2double(get(hObject,'String')) returns contents of edit_EpsionRMS as a double
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
function edit_EpsionRMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_EpsionRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Ratio_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ratio as text
%        str2double(get(hObject,'String')) returns contents of edit_Ratio as a double
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
function edit_Ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MinNumP_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MinNumP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MinNumP as text
%        str2double(get(hObject,'String')) returns contents of edit_MinNumP as a double
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
function edit_MinNumP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MinNumP (see GCBO)
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

SavePathName = get(handles.edit_OutputDirectory, 'String');
if exist(SavePathName, 'dir')~=7
    errordlg('No output files!', 'Bad Output Files', 'modal');
    return;
end

tempstr = get(handles.edit_cellsize, 'String');
cellsize = str2double(tempstr);
if isnan(cellsize)
    errordlg('Cell size used in Hough transform: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_slicethick, 'String');
slicethick = str2double(tempstr);
if isnan(slicethick)
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

tempstr = get(handles.edit_DeltaTheta, 'String');
DeltaTheta = str2double(tempstr);
if isnan(DeltaTheta)
    errordlg('Angle resolution of theta (rotate about Z axis): invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit1_DeltaPhi, 'String');
DeltaPhi = str2double(tempstr);
if isnan(DeltaPhi)
    errordlg('Angle resolution of phi (rotate about X axis): invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_Ratio, 'String');
Ratio = str2double(tempstr);
if isnan(Ratio)
    errordlg('Ratio of minimum number to theoretical number of points in a stem arc: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_EpsionRMS, 'String');
EpsionRMS = str2double(tempstr);
if isnan(EpsionRMS)
    errordlg('Maximum distance between stem centers to fitted line: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_MinNumP, 'String');
MinNumP = str2double(tempstr);
if isnan(MinNumP)
    errordlg('Minimum number of points to give a line of stem: invalid input!', 'Bad Input', 'modal');
    return;
end

ReturnMsgStr = Fcn_StemProfileBottom2Top(DataPathName, DataPtsFileName, ...
    SingleScanFlag, ...
    cellsize, slicethick, maxR, minnumfit, sigmacoef, epsion, maxIter, ...
    initialTranslateVector_Data, ...
    DeltaTheta, DeltaPhi, Ratio, EpsionRMS, MinNumP, ...
    SavePathName);
msgbox(ReturnMsgStr, 'modal');


% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_cellsize, 'String', '0.01');
set(handles.edit_slicethick, 'String', '0.1');
set(handles.edit_maxR, 'String', '50');
set(handles.edit_minnumfit, 'String', '9');
set(handles.edit_sigmacoef, 'String', '1');
set(handles.edit_epsion, 'String', '0.001');
set(handles.edit_maxIter, 'String', '100');

set(handles.edit_DeltaTheta, 'String', '0.1');
set(handles.edit1_DeltaPhi, 'String', '0.1');
set(handles.edit_Ratio, 'String', '0.4');
set(handles.edit_EpsionRMS, 'String', '0.05');
set(handles.edit_MinNumP, 'String', '6');

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
