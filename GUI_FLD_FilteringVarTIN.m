function varargout = GUI_FLD_FilteringVarTIN(varargin)
% GUI_FLD_FILTERINGVARTIN M-file for GUI_FLD_FilteringVarTIN.fig
%      GUI_FLD_FILTERINGVARTIN, by itself, creates a new GUI_FLD_FILTERINGVARTIN or raises the existing
%      singleton*.
%
%      H = GUI_FLD_FILTERINGVARTIN returns the handle to a new GUI_FLD_FILTERINGVARTIN or the handle to
%      the existing singleton*.
%
%      GUI_FLD_FILTERINGVARTIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FLD_FILTERINGVARTIN.M with the given input arguments.
%
%      GUI_FLD_FILTERINGVARTIN('Property','Value',...) creates a new GUI_FLD_FILTERINGVARTIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_FLD_FilteringVarTIN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_FLD_FilteringVarTIN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_FLD_FilteringVarTIN

% Last Modified by GUIDE v2.5 14-Jul-2011 08:54:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_FLD_FilteringVarTIN_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_FLD_FilteringVarTIN_OutputFcn, ...
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


% --- Executes just before GUI_FLD_FilteringVarTIN is made visible.
function GUI_FLD_FilteringVarTIN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_FLD_FilteringVarTIN (see VARARGIN)

% Choose default command line output for GUI_FLD_FilteringVarTIN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initialize the status of all the radio buttons and its relevent UIs.
set(handles.radiobutton_SpecifyCH, 'Value', get(handles.radiobutton_SpecifyCH, 'Min'));
set(handles.edit_GivenCH, 'Enable', 'off');
set(handles.edit_GivenCH, 'string', []);
set(handles.radiobutton_CalculateCH, 'Value', get(handles.radiobutton_CalculateCH, 'Max'));
set(handles.edit_CHCellZ, 'Enable', 'on');
set(handles.edit_CHCoef, 'Enable', 'on');
set(handles.edit_CHCellZ, 'string', '0.2');
set(handles.edit_CHCoef, 'string', '4');
set(handles.edit_CalculatedCH, 'Enable', 'inactive');
set(handles.radiobutton_FullExtent, 'Value', get(handles.radiobutton_FullExtent, 'Max'));
set(handles.radiobutton_SpecifyExtent, 'Value', get(handles.radiobutton_SpecifyExtent, 'Min'));
set(handles.edit_MaxX, 'Enable', 'off');
set(handles.edit_MinX, 'Enable', 'off');
set(handles.edit_MaxY, 'Enable', 'off');
set(handles.edit_MinY, 'Enable', 'off');
set(handles.edit_MaxX, 'string', []);
set(handles.edit_MinX, 'string', []);
set(handles.edit_MaxY, 'string', []);
set(handles.edit_MinY, 'string', []);
set(handles.checkbox_OuputNonGroundPts, 'Value', get(handles.checkbox_OuputNonGroundPts, 'Min'));
set(handles.edit_OuputNonGroundPtsFile, 'Enable', 'off');
set(handles.edit_OuputNonGroundPtsFile, 'string', []);
set(handles.edit_InputPtsFile, 'string', []);
set(handles.edit_OuputGroundPtsFile, 'string', []);
set(handles.pushbutton_OuputNonGroundPtsFile, 'Enable', 'off');
set(handles.edit_ScaleNum, 'string', '4');
VarTINData = cell(4, 3);
VarTINData(1:4,1) = num2cell( (1:4)' );
VarTINData(1:4,2) = num2cell( ([4, 2, 1, 0.5])' );
VarTINData(1:4,3) = num2cell( ([3, 1.5, 0.5, 0.2])' );
set(handles.uitable_VarTIN, 'Data', VarTINData);
set(handles.checkbox_OutputEachScale, 'Value', get(handles.checkbox_OutputEachScale, 'Min'));
set(handles.edit_OutputEachScalePtsDir, 'Enable', 'off');
set(handles.edit_OutputEachScalePtsDir, 'string', []);
set(handles.pushbutton_OutputEachScale, 'Enable', 'off');

% UIWAIT makes GUI_FLD_FilteringVarTIN wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_FLD_FilteringVarTIN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_InputPtsFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_InputPtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_InputPtsFile as text
%        str2double(get(hObject,'String')) returns contents of edit_InputPtsFile as a double


% --- Executes during object creation, after setting all properties.
function edit_InputPtsFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_InputPtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_InputPts.
function pushbutton_InputPts_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_InputPts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_InputPtsFile, 'String');
[FileName,PathName] = uigetfile({'*.txt', '*.txt Files (*.txt)'},'Select ASCII file of point clouds:', initialpath);
if ~FileName
    return;
end
set(handles.edit_InputPtsFile, 'UserData', PathName);
set(handles.edit_InputPtsFile, 'String', fullfile(PathName, FileName));


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ScaleNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ScaleNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ScaleNum as text
%        str2double(get(hObject,'String')) returns contents of edit_ScaleNum as a double
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
function edit_ScaleNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ScaleNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MaxY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MaxY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MaxY as text
%        str2double(get(hObject,'String')) returns contents of edit_MaxY as a double
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
function edit_MaxY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MaxY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MinX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MinX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MinX as text
%        str2double(get(hObject,'String')) returns contents of edit_MinX as a double
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
function edit_MinX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MinX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MaxX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MaxX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MaxX as text
%        str2double(get(hObject,'String')) returns contents of edit_MaxX as a double
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
function edit_MaxX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MaxX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MinY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MinY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MinY as text
%        str2double(get(hObject,'String')) returns contents of edit_MinY as a double
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
function edit_MinY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MinY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_GivenCH_Callback(hObject, eventdata, handles)
% hObject    handle to edit_GivenCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_GivenCH as text
%        str2double(get(hObject,'String')) returns contents of edit_GivenCH as a double

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
function edit_GivenCH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_GivenCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_CHCellZ_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CHCellZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CHCellZ as text
%        str2double(get(hObject,'String')) returns contents of edit_CHCellZ as a double
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
function edit_CHCellZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CHCellZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_CHCoef_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CHCoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CHCoef as text
%        str2double(get(hObject,'String')) returns contents of edit_CHCoef as a double
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
function edit_CHCoef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CHCoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_CalculatedCH_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CalculatedCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CalculatedCH as text
%        str2double(get(hObject,'String')) returns contents of edit_CalculatedCH as a double


% --- Executes during object creation, after setting all properties.
function edit_CalculatedCH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CalculatedCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_OuputGroundPtsFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_OuputGroundPtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_OuputGroundPtsFile as text
%        str2double(get(hObject,'String')) returns contents of edit_OuputGroundPtsFile as a double


% --- Executes during object creation, after setting all properties.
function edit_OuputGroundPtsFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_OuputGroundPtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_OuputGroundPtsFile.
function pushbutton_OuputGroundPtsFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OuputGroundPtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_OuputGroundPtsFile, 'String');
[FileName,PathName] = uiputfile({'*.txt', '*.txt Files (*.txt)'},'Output ground points to the ASCII file:', initialpath);
if ~FileName
    return;
end
set(handles.edit_OuputGroundPtsFile, 'UserData', PathName);
set(handles.edit_OuputGroundPtsFile, 'String', fullfile(PathName, FileName));


% --- Executes on button press in checkbox_OuputNonGroundPts.
function checkbox_OuputNonGroundPts_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_OuputNonGroundPts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_OuputNonGroundPts
if (get(hObject, 'Value') == get(hObject, 'Max'))
    set(handles.edit_OuputNonGroundPtsFile, 'Enable', 'on');
    set(handles.pushbutton_OuputNonGroundPtsFile, 'Enable', 'on');
else
    set(handles.edit_OuputNonGroundPtsFile, 'Enable', 'off');
    set(handles.pushbutton_OuputNonGroundPtsFile, 'Enable', 'off');
%     set(handles.edit_OuputNonGroundPtsFile, 'String', []);
end



function edit_OuputNonGroundPtsFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_OuputNonGroundPtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_OuputNonGroundPtsFile as text
%        str2double(get(hObject,'String')) returns contents of edit_OuputNonGroundPtsFile as a double


% --- Executes during object creation, after setting all properties.
function edit_OuputNonGroundPtsFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_OuputNonGroundPtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_OuputNonGroundPtsFile.
function pushbutton_OuputNonGroundPtsFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OuputNonGroundPtsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_OuputNonGroundPtsFile, 'String');
if isempty(initialpath)
    initialpath = get(handles.edit_OuputGroundPtsFile, 'String');
end
[FileName,PathName] = uiputfile({'*.txt', '*.txt Files (*.txt)'},'Output non-ground points to the ASCII file:', initialpath);
if ~FileName
    return;
end
set(handles.edit_OuputNonGroundPtsFile, 'UserData', PathName);
set(handles.edit_OuputNonGroundPtsFile, 'String', fullfile(PathName, FileName));


% --- Executes on button press in pushbutton_Run.
function pushbutton_Run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tempstr = get(handles.edit_InputPtsFile, 'string');
if exist(tempstr, 'file')~=2
    errordlg('No input files or file name error!','Bad Input Files','modal')
%     msgbox('No input files or file name error!');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
InPtsPathName = pathstr;
InPtsFileName = [name, ext];

VarTINData = get(handles.uitable_VarTIN, 'Data');
scale = cell2mat(VarTINData(1:end, 2));
door = cell2mat(VarTINData(1:end, 3));
ScaleNum = size(VarTINData, 1);
if length(scale)~= ScaleNum
    errordlg('The cell sizes contain empty value!', 'Var-TIN Parameters Error', 'modal');
    return;
end
if any(isnan(scale))
    errordlg('The cell sizes contain invalid value!', 'Var-TIN Parameters Error', 'modal');
    return;
end
if length(door)~= ScaleNum
    errordlg('The distance thresholds contain empty value!', 'Var-TIN Parameters Error', 'modal');
    return;
end
if any(isnan(door))
    errordlg('The distance thresholds contain invalid value!', 'Var-TIN Parameters Error', 'modal');
    return;
end
if ~issorted(flipud(scale))
    % the scale is not in the descending order. It is wrong!
    errordlg('The cell size must be in the descending order!', 'Var-TIN Parameters Error', 'modal');
    return;
end
if ~issorted(flipud(door))
    % the door is not in the descending order. It is wrong!
    errordlg('The distance threshold must be in the descending order!', 'Var-TIN Parameters Error', 'modal');
    return;
end

if get(handles.radiobutton_SpecifyCH, 'Value') == get(handles.radiobutton_SpecifyCH, 'Max')
    CutH = str2double( get(handles.edit_GivenCH, 'string') );
    if isnan(CutH)
        errordlg('You must enter a numeric value for the given cut height!', 'Cut Height Error', 'modal');
        return;
    end
else
    CutH = NaN;
end
if get(handles.radiobutton_CalculateCH, 'Value') == get(handles.radiobutton_CalculateCH, 'Max')
    CalCutH = zeros(1,2);
    CalCutH(1) = str2double( get(handles.edit_CHCellZ, 'string') );
    CalCutH(2) = str2double( get(handles.edit_CHCoef, 'string') );
    if isnan(CalCutH(1))
        errordlg('You must enter a numeric value for the slice thickness!', 'Cut Height Error', 'modal');
        return;
    end
    if isnan(CalCutH(2))
        errordlg('You must enter a numeric value for the coefficient!', 'Cut Height Error', 'modal');
        return;
    end
else
    CalCutH = NaN(1,2);
end

xlim = zeros(1, 2);
ylim = zeros(1, 2);
if get(handles.radiobutton_SpecifyExtent, 'Value') == get(handles.radiobutton_SpecifyExtent, 'Max')
    xlim(1) = str2double( get(handles.edit_MinX, 'string') );
    xlim(2) = str2double( get(handles.edit_MaxX, 'string') );
    ylim(1) = str2double( get(handles.edit_MinY, 'string') );
    ylim(2) = str2double( get(handles.edit_MaxY, 'string') );
    if isnan(xlim(1)) || isnan(xlim(2)) || isnan(ylim(1)) || isnan(ylim(2))
        errordlg('You must enter a numeric value for the data extent!', 'Extent Error', 'modal');
        return;
    end
end

tempstr = get(handles.edit_OuputGroundPtsFile, 'string');
[pathstr, name, ext] = fileparts(tempstr);
GroundPtsPathName = pathstr;
GroundPtsFileName = [name, ext];
if exist(GroundPtsPathName, 'dir') ~= 7
    errordlg('The directory of the output ground points files does not exist!','Bad Output Files','modal')
    return;
end

if (get(handles.checkbox_OuputNonGroundPts, 'Value') == get(handles.checkbox_OuputNonGroundPts, 'Max'))
    tempstr = get(handles.edit_OuputNonGroundPtsFile, 'string');
    [pathstr, name, ext] = fileparts(tempstr);
    NonGroundPtsPathName = pathstr;
    NonGroundPtsFileName = [name, ext];
    if exist(NonGroundPtsPathName, 'dir') ~= 7
        errordlg('The directory of the output non-ground points files does not exist!','Bad Output Files','modal')
        return;
    end
else
    NonGroundPtsPathName = [];
    NonGroundPtsFileName = [];
end

if get(handles.checkbox_OutputEachScale, 'Value') == get(handles.checkbox_OutputEachScale, 'Max')
    EachScalePathName = get(handles.edit_OutputEachScalePtsDir, 'string');
    if exist(EachScalePathName, 'dir') ~= 7
        errordlg('The directory of the remaining points files in all the iterations does not exist!','Bad Output Directory for All The Iterations','modal')
        return;
    end
else
    EachScalePathName = [];
end

if get(handles.radiobutton_FullExtent, 'Value') == get(handles.radiobutton_FullExtent, 'Max')
    fid = fopen(fullfile(InPtsPathName, InPtsFileName), 'r');
    tempdata = textscan(fid, '%f %f %f');
    fclose(fid);
    tempdata = cell2mat(tempdata);
    xlim(1) = min(tempdata(:, 1));
    xlim(2) = max(tempdata(:, 1));
    ylim(1) = min(tempdata(:, 2));
    ylim(2) = max(tempdata(:, 2));
    clear tempdata;
    set(handles.edit_MinX, 'string', num2str(xlim(1)));
    set(handles.edit_MaxX, 'string', num2str(xlim(2)));
    set(handles.edit_MinY, 'string', num2str(ylim(1)));
    set(handles.edit_MaxY, 'string', num2str(ylim(2)));
end

NewCutH = mexFilterVarScaleTIN(InPtsPathName, InPtsFileName, ...
                  GroundPtsPathName, GroundPtsFileName, ...
                  scale, door, ...
                  xlim, ylim, ...
                  CutH, CalCutH, ...
                  NonGroundPtsPathName, NonGroundPtsFileName, ...
                  EachScalePathName); 

if get(handles.radiobutton_CalculateCH, 'Value') == get(handles.radiobutton_CalculateCH, 'Max')
    set(handles.edit_CalculatedCH, 'string', num2str(NewCutH));
end

clear functions;

% add a procedure to remove some false ground points in the area far from
% the scan position.
gpfid=fopen(fullfile(GroundPtsPathName, GroundPtsFileName), 'r');
rawdata=textscan(gpfid,'%f %f %f');
fclose(gpfid);
datax=rawdata{1};
datay=rawdata{2};
dataz=rawdata{3};
clear rawdata;
% reshape x, y, z to column vector.
ndata=length(datax);
datax=reshape(datax, ndata,1);
datay=reshape(datay, ndata,1);
dataz=reshape(dataz, ndata,1);
MaxRange = 10;
deltaz = 0.25;
[newx, newy, newz] = Fcn_RefineGroundPoints(datax, datay, dataz, MaxRange, deltaz);

newgpfid=fopen(fullfile(GroundPtsPathName, GroundPtsFileName), 'w');
% fprintf(newgpfid, 'x,y,z\r\n');
fprintf(newgpfid, '%.3f %.3f %.3f\r\n', ([newx, newy, newz])');
fclose(newgpfid);
% end of this refinement of ground points

msgbox('Finished: Filter Lidar Data with Var-TIN!', 'modal');


% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initialize the status of all the radio buttons and its relevent UIs.
set(handles.radiobutton_SpecifyCH, 'Value', get(handles.radiobutton_SpecifyCH, 'Min'));
set(handles.edit_GivenCH, 'Enable', 'off');
set(handles.edit_GivenCH, 'string', []);
set(handles.radiobutton_CalculateCH, 'Value', get(handles.radiobutton_CalculateCH, 'Max'));
set(handles.edit_CHCellZ, 'Enable', 'on');
set(handles.edit_CHCoef, 'Enable', 'on');
set(handles.edit_CHCellZ, 'string', '0.2');
set(handles.edit_CHCoef, 'string', '4');
set(handles.edit_CalculatedCH, 'Enable', 'inactive');
set(handles.radiobutton_FullExtent, 'Value', get(handles.radiobutton_FullExtent, 'Max'));
set(handles.radiobutton_SpecifyExtent, 'Value', get(handles.radiobutton_SpecifyExtent, 'Min'));
set(handles.edit_MaxX, 'Enable', 'off');
set(handles.edit_MinX, 'Enable', 'off');
set(handles.edit_MaxY, 'Enable', 'off');
set(handles.edit_MinY, 'Enable', 'off');
set(handles.edit_MaxX, 'string', []);
set(handles.edit_MinX, 'string', []);
set(handles.edit_MaxY, 'string', []);
set(handles.edit_MinY, 'string', []);
set(handles.checkbox_OuputNonGroundPts, 'Value', get(handles.checkbox_OuputNonGroundPts, 'Min'));
set(handles.edit_OuputNonGroundPtsFile, 'Enable', 'off');
set(handles.edit_OuputNonGroundPtsFile, 'string', []);
set(handles.edit_InputPtsFile, 'string', []);
set(handles.edit_OuputGroundPtsFile, 'string', []);
set(handles.pushbutton_OuputNonGroundPtsFile, 'Enable', 'off');
set(handles.edit_ScaleNum, 'string', '4');
VarTINData = cell(4, 3);
VarTINData(1:4,1) = num2cell( (1:4)' );
VarTINData(1:4,2) = num2cell( ([4, 2, 1, 0.5])' );
VarTINData(1:4,3) = num2cell( ([3, 1.5, 0.5, 0.2])' );
set(handles.uitable_VarTIN, 'Data', VarTINData);
set(handles.checkbox_OutputEachScale, 'Value', get(handles.checkbox_OutputEachScale, 'Min'));
set(handles.edit_OutputEachScalePtsDir, 'Enable', 'off');
set(handles.edit_OutputEachScalePtsDir, 'string', []);
set(handles.pushbutton_OutputEachScale, 'Enable', 'off');


% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue,'Tag')
    case 'radiobutton_SpecifyCH'
        set(handles.edit_GivenCH, 'Enable', 'on');
        set(handles.edit_CHCellZ, 'Enable', 'off');
        set(handles.edit_CHCoef, 'Enable', 'off');
        set(handles.edit_CalculatedCH, 'Enable', 'off');
%         set(handles.edit_CalculatedCH, 'String', []);
    case 'radiobutton_CalculateCH'
        set(handles.edit_GivenCH, 'Enable', 'off');
        set(handles.edit_CHCellZ, 'Enable', 'on');
        set(handles.edit_CHCoef, 'Enable', 'on');
        set(handles.edit_CalculatedCH, 'Enable', 'inactive');
%         set(handles.edit_CalculatedCH, 'String', []);
end


% --- Executes when selected object is changed in uipanel3.
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel3 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue, 'Tag')
    case 'radiobutton_FullExtent'
        set(handles.edit_MaxX, 'Enable', 'off');
        set(handles.edit_MinX, 'Enable', 'off');
        set(handles.edit_MaxY, 'Enable', 'off');
        set(handles.edit_MinY, 'Enable', 'off');
    case 'radiobutton_SpecifyExtent'
        set(handles.edit_MaxX, 'Enable', 'on');
        set(handles.edit_MinX, 'Enable', 'on');
        set(handles.edit_MaxY, 'Enable', 'on');
        set(handles.edit_MinY, 'Enable', 'on');
end


% --- Executes on button press in pushbutton_RefreshTable.
function pushbutton_RefreshTable_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RefreshTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ScaleNum = str2double(get(handles.edit_ScaleNum,'string'));
if isnan(ScaleNum)
    errordlg('You must enter a numeric value for the number of scales','Bad Input','modal')
    uicontrol(handles.edit_ScaleNum)
	return
end
OldData = get(handles.uitable_VarTIN, 'Data');
OldScaleNum = size(OldData, 1);
MyData = cell(ScaleNum, 3);
MyData(1:end, 1) = num2cell((1:ScaleNum)');
if OldScaleNum < ScaleNum
    MyData(1:OldScaleNum, 1:end) = OldData;
else
    MyData = OldData(1:ScaleNum, 1:end);
end
set(handles.uitable_VarTIN, 'Data', MyData);


% --- Executes when entered data in editable cell(s) in uitable_VarTIN.
function uitable_VarTIN_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_VarTIN (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

if isempty(eventdata.EditData)
    OldData = get(handles.uitable_VarTIN, 'Data');
    OldData(eventdata.Indices(1), eventdata.Indices(2)) = {[]};
    set(hObject, 'Data', OldData);
    return;
end

user_entry = str2double(eventdata.EditData);
if isnan(user_entry)
    errordlg('You must enter a numeric value for the cell size and distance threshold in the table','Bad Input','modal');
	return
end


% --- Executes on button press in checkbox_OutputEachScale.
function checkbox_OutputEachScale_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_OutputEachScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_OutputEachScale
if get(hObject, 'Value')==get(hObject, 'Max')
    set(handles.edit_OutputEachScalePtsDir, 'Enable', 'on');
    set(handles.pushbutton_OutputEachScale, 'Enable', 'on');
else
    set(handles.edit_OutputEachScalePtsDir, 'Enable', 'off');
    set(handles.pushbutton_OutputEachScale, 'Enable', 'off');
end



function edit_OutputEachScalePtsDir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_OutputEachScalePtsDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_OutputEachScalePtsDir as text
%        str2double(get(hObject,'String')) returns contents of edit_OutputEachScalePtsDir as a double


% --- Executes during object creation, after setting all properties.
function edit_OutputEachScalePtsDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_OutputEachScalePtsDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_OutputEachScale.
function pushbutton_OutputEachScale_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OutputEachScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_OutputEachScalePtsDir, 'String');
if isempty(initialpath)
    initialpath = get(handles.edit_OuputGroundPtsFile, 'String');
end
SavePathName= uigetdir(initialpath, 'Select Output Directory for Each Iteration:');
if ~SavePathName
    return;
end
set(handles.edit_OutputEachScalePtsDir, 'UserData', SavePathName);
set(handles.edit_OutputEachScalePtsDir, 'String', SavePathName);


% --- Executes during object creation, after setting all properties.
function uipanel4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
