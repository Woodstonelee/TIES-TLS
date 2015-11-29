function varargout = GUI_TC_DetectClassifyStems(varargin)
% GUI_TC_DETECTCLASSIFYSTEMS M-file for GUI_TC_DetectClassifyStems.fig
%      GUI_TC_DETECTCLASSIFYSTEMS, by itself, creates a new GUI_TC_DETECTCLASSIFYSTEMS or raises the existing
%      singleton*.
%
%      H = GUI_TC_DETECTCLASSIFYSTEMS returns the handle to a new GUI_TC_DETECTCLASSIFYSTEMS or the handle to
%      the existing singleton*.
%
%      GUI_TC_DETECTCLASSIFYSTEMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TC_DETECTCLASSIFYSTEMS.M with the given input arguments.
%
%      GUI_TC_DETECTCLASSIFYSTEMS('Property','Value',...) creates a new GUI_TC_DETECTCLASSIFYSTEMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_TC_DetectClassifyStems_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_TC_DetectClassifyStems_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_TC_DetectClassifyStems

% Last Modified by GUIDE v2.5 25-Jul-2010 21:05:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_TC_DetectClassifyStems_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_TC_DetectClassifyStems_OutputFcn, ...
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


% --- Executes just before GUI_TC_DetectClassifyStems is made visible.
function GUI_TC_DetectClassifyStems_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_TC_DetectClassifyStems (see VARARGIN)

% Choose default command line output for GUI_TC_DetectClassifyStems
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_TC_DetectClassifyStems wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_TC_DetectClassifyStems_OutputFcn(hObject, eventdata, handles) 
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
[PtsFileName,PathName] = uigetfile('*.txt','Select ascii file of original point clouds:', initialpath);
if ~PtsFileName
    return;
end
set(handles.edit_PtsFile, 'UserData', PathName);
set(handles.edit_PtsFile, 'String', fullfile(PathName, PtsFileName));


function edit_VoxelFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VoxelFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VoxelFile as text
%        str2double(get(hObject,'String')) returns contents of edit_VoxelFile as a double


% --- Executes during object creation, after setting all properties.
function edit_VoxelFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VoxelFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_VoxelFile.
function pushbutton_VoxelFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_VoxelFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialvoxelpath = get(handles.edit_VoxelFile, 'String');
tempstr = get(handles.edit_PtsFile, 'String');
if exist(tempstr, 'file')~=2
    initialpath = [];
else
    [~, name, ext] = fileparts(tempstr);
    PtsFileName = [name, ext];
    [initialvoxelpath, ~, ~] = fileparts(initialvoxelpath);
    initialpath=fullfile(initialvoxelpath, ['Voxels_', PtsFileName]);
end
[FileName,PathName] = uigetfile({'*.txt', 'Voxels_*.txt Files (*.txt)'},'Select ascii file of voxels:', initialpath);
if ~FileName
    return;
end
set(handles.edit_VoxelFile, 'UserData', PathName);
set(handles.edit_VoxelFile, 'String', fullfile(PathName, FileName));



function edit_DEMFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DEMFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DEMFile as text
%        str2double(get(hObject,'String')) returns contents of edit_DEMFile as a double


% --- Executes during object creation, after setting all properties.
function edit_DEMFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DEMFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_DEMFile.
function pushbutton_DEMFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DEMFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialdempath = get(handles.edit_DEMFile, 'String');
tempstr = get(handles.edit_PtsFile, 'String');
if exist(tempstr, 'file')~=2
    initialpath = [];
else
    [~, name, ext] = fileparts(tempstr);
    PtsFileName = [name, ext];
    [initialdempath, ~, ~] = fileparts(initialdempath);
    initialpath=fullfile(initialdempath, ['DEM_', PtsFileName]);
end
[FileName,PathName] = uigetfile({'*.txt', 'DEM_*.txt Files (*.txt)'},'Select ascii file of DEM:', initialpath);
if ~FileName
    return;
end
set(handles.edit_DEMFile, 'UserData', PathName);
set(handles.edit_DEMFile, 'String', fullfile(PathName, FileName));



function edit_RasterInfoFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_RasterInfoFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_RasterInfoFile as text
%        str2double(get(hObject,'String')) returns contents of edit_RasterInfoFile as a double


% --- Executes during object creation, after setting all properties.
function edit_RasterInfoFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_RasterInfoFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_RasterInfoFile.
function pushbutton_RasterInfoFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RasterInfoFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialrasterinfopath = get(handles.edit_RasterInfoFile, 'String');
tempstr = get(handles.edit_PtsFile, 'String');
if exist(tempstr, 'file')~=2
    initialpath = [];
else
    [~, name, ext] = fileparts(tempstr);
    PtsFileName = [name, ext];
    [initialrasterinfopath, ~, ~] = fileparts(initialrasterinfopath);
    initialpath=fullfile(initialrasterinfopath, ['RasterInfo_', PtsFileName]);
end
[FileName,PathName] = uigetfile({'*.txt', 'RasterInfo_*.txt Files (*.txt)'},'Select ascii file of rasterizing information:', initialpath);
if ~FileName
    return;
end
set(handles.edit_RasterInfoFile, 'UserData', PathName);
set(handles.edit_RasterInfoFile, 'String', fullfile(PathName, FileName));



function edit_zflag_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zflag as text
%        str2double(get(hObject,'String')) returns contents of edit_zflag as a double
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
function edit_zflag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxstemlength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxstemlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxstemlength as text
%        str2double(get(hObject,'String')) returns contents of edit_maxstemlength as a double
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
function edit_maxstemlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxstemlength (see GCBO)
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



function edit_cutoffdis_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cutoffdis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cutoffdis as text
%        str2double(get(hObject,'String')) returns contents of edit_cutoffdis as a double
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
function edit_cutoffdis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cutoffdis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_minpoints_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minpoints as text
%        str2double(get(hObject,'String')) returns contents of edit_minpoints as a double
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
function edit_minpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minpoints (see GCBO)
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
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
PathName = pathstr;
PtsFileName = [name, ext];

tempstr = get(handles.edit_VoxelFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
VoxelPathName = pathstr;
VoxelFileName = [name, ext];

tempstr = get(handles.edit_RasterInfoFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
RasterInfoPathName = pathstr;
RasterInfoFileName = [name, ext];

tempstr = get(handles.edit_DEMFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
DEMPathName = pathstr;
DEMFileName = [name, ext];

tempstr = get(handles.edit_zflag, 'String');
zflag = str2double(tempstr);
if isnan(zflag)
    errordlg('Minimum number of continuous voxels along Z axis: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_maxstemlength, 'String');
maxstemlength = str2double(tempstr);
if isnan(maxstemlength)
    errordlg('Maximum stem length: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_cellsize, 'String');
cellsize = str2double(tempstr);
if isnan(cellsize)
    errordlg('Cell size used in clustering on XY plane: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_cutoffdis, 'String');
CutoffDis = str2double(tempstr);
if isnan(CutoffDis)
    errordlg('Minimum distance between two stems (clusters): invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_minpoints, 'String');
minpoints = str2double(tempstr);
if isnan(minpoints)
    errordlg('Minimum number of points to form a stem: invalid input!', 'Bad Input', 'modal');
    return;
end

SavePathName = get(handles.edit_OutputDirectory, 'String');
if exist(SavePathName, 'dir')~=7
    errordlg('No output files!', 'Bad Output Files', 'modal');
    return;
end

Fcn_DetectClassifyStems(PathName, PtsFileName, ...
    VoxelPathName, VoxelFileName, ...
    RasterInfoPathName, RasterInfoFileName, ...
    DEMPathName, DEMFileName, ...
    zflag, maxstemlength, cellsize, CutoffDis, minpoints, ...
    SavePathName);
msgbox('Finished: Tree Classifier, Detect and Classify Stems.', 'modal');



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


% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_zflag, 'String', '5');
set(handles.edit_maxstemlength, 'String', 'Inf');
set(handles.edit_cellsize, 'String', '0.1');
set(handles.edit_cutoffdis, 'String', '1');
set(handles.edit_minpoints, 'String', '0');
