function varargout = GUI_TC_RasterizePointClouds(varargin)
% GUI_TC_RASTERIZEPOINTCLOUDS M-file for GUI_TC_RasterizePointClouds.fig
%      GUI_TC_RASTERIZEPOINTCLOUDS, by itself, creates a new GUI_TC_RASTERIZEPOINTCLOUDS or raises the existing
%      singleton*.
%
%      H = GUI_TC_RASTERIZEPOINTCLOUDS returns the handle to a new GUI_TC_RASTERIZEPOINTCLOUDS or the handle to
%      the existing singleton*.
%
%      GUI_TC_RASTERIZEPOINTCLOUDS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TC_RASTERIZEPOINTCLOUDS.M with the given input arguments.
%
%      GUI_TC_RASTERIZEPOINTCLOUDS('Property','Value',...) creates a new GUI_TC_RASTERIZEPOINTCLOUDS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_TC_RasterizePointClouds_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_TC_RasterizePointClouds_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_TC_RasterizePointClouds

% Last Modified by GUIDE v2.5 25-Jul-2010 21:22:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_TC_RasterizePointClouds_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_TC_RasterizePointClouds_OutputFcn, ...
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


% --- Executes just before GUI_TC_RasterizePointClouds is made visible.
function GUI_TC_RasterizePointClouds_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_TC_RasterizePointClouds (see VARARGIN)

% Choose default command line output for GUI_TC_RasterizePointClouds
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_TC_RasterizePointClouds wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_TC_RasterizePointClouds_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_InputFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_InputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_InputFile as text
%        str2double(get(hObject,'String')) returns contents of edit_InputFile as a double
tempstr = get(hObject, 'String');
[pathstr, ~, ~] = fileparts(tempstr);
PathName = pathstr;
set(hObject, 'UserData', PathName);


% --- Executes during object creation, after setting all properties.
function edit_InputFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_InputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_InputFile.
function pushbutton_InputFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_InputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_InputFile, 'String');
[PtsFileName,PathName] = uigetfile('*.txt','Select the original forest point clouds file:', initialpath);
if ~PtsFileName
    return;
end
set(handles.edit_InputFile, 'UserData', PathName);
set(handles.edit_InputFile, 'String', fullfile(PathName, PtsFileName));



function edit_VoxelSizeX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VoxelSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VoxelSizeX as text
%        str2double(get(hObject,'String')) returns contents of edit_VoxelSizeX as a double
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
function edit_VoxelSizeX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VoxelSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_VoxelSizeY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VoxelSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VoxelSizeY as text
%        str2double(get(hObject,'String')) returns contents of edit_VoxelSizeY as a double
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
function edit_VoxelSizeY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VoxelSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_VoxelSizeZ_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VoxelSizeZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VoxelSizeZ as text
%        str2double(get(hObject,'String')) returns contents of edit_VoxelSizeZ as a double
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
function edit_VoxelSizeZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VoxelSizeZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_CellSizeGround_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CellSizeGround (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CellSizeGround as text
%        str2double(get(hObject,'String')) returns contents of edit_CellSizeGround as a double
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
function edit_CellSizeGround_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CellSizeGround (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in pushbutton_Run.
function pushbutton_Run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tempstr = get(handles.edit_InputFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
PathName = pathstr;
PtsFileName = [name, ext];

SavePathName = get(handles.edit_OutputDirectory, 'String');
if exist(SavePathName, 'dir')~=7
    errordlg('No output files!', 'Bad Output Files', 'modal');
    return;
end
cellsize = ones(1, 3);
tempstr = get(handles.edit_VoxelSizeX, 'String');
cellsize(1) = str2double(tempstr);
if isnan(cellsize(1))
    errordlg('Voxel Size along X: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_VoxelSizeY, 'String');
cellsize(2) = str2double(tempstr);
if isnan(cellsize(2))
    errordlg('Voxel Size along Y: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_VoxelSizeZ, 'String');
cellsize(3) = str2double(tempstr);
if isnan(cellsize(3))
    errordlg('Voxel Size along Z: invalid input!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_CellSizeGround, 'String');
filtercellsize = str2double(tempstr);
if isnan(filtercellsize)
    errordlg('Cell Size used to find ground points: invalid input!', 'Bad Input', 'modal');
    return;
end

Fcn_RasterizePointClouds(PathName, PtsFileName, cellsize, filtercellsize, SavePathName);

msgbox('Finished: Tree Classifier, Rasterize Point Clouds!', 'modal');


% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_VoxelSizeX, 'String', '0.2');
set(handles.edit_VoxelSizeY, 'String', '0.2');
set(handles.edit_VoxelSizeZ, 'String', '0.2');
set(handles.edit_CellSizeGround, 'String', '10');
