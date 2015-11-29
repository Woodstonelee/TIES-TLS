function varargout = GUI_R_ExplicitlyMatchedPoints(varargin)
% GUI_R_EXPLICITLYMATCHEDPOINTS M-file for GUI_R_ExplicitlyMatchedPoints.fig
%      GUI_R_EXPLICITLYMATCHEDPOINTS, by itself, creates a new GUI_R_EXPLICITLYMATCHEDPOINTS or raises the existing
%      singleton*.
%
%      H = GUI_R_EXPLICITLYMATCHEDPOINTS returns the handle to a new GUI_R_EXPLICITLYMATCHEDPOINTS or the handle to
%      the existing singleton*.
%
%      GUI_R_EXPLICITLYMATCHEDPOINTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_R_EXPLICITLYMATCHEDPOINTS.M with the given input arguments.
%
%      GUI_R_EXPLICITLYMATCHEDPOINTS('Property','Value',...) creates a new GUI_R_EXPLICITLYMATCHEDPOINTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_R_ExplicitlyMatchedPoints_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_R_ExplicitlyMatchedPoints_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_R_ExplicitlyMatchedPoints

% Last Modified by GUIDE v2.5 27-Feb-2012 23:19:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_R_ExplicitlyMatchedPoints_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_R_ExplicitlyMatchedPoints_OutputFcn, ...
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


% --- Executes just before GUI_R_ExplicitlyMatchedPoints is made visible.
function GUI_R_ExplicitlyMatchedPoints_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_R_ExplicitlyMatchedPoints (see VARARGIN)

% Choose default command line output for GUI_R_ExplicitlyMatchedPoints
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_R_ExplicitlyMatchedPoints wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_R_ExplicitlyMatchedPoints_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_Run.
function pushbutton_Run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tempstr = get(handles.edit_MFPFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
TieStemBasePathName = pathstr;
TieStemBaseFileName = [name, ext];

tempstr = get(handles.edit_TMFile, 'String');
[pathstr, name, ext] = fileparts(tempstr);
TMPathName = pathstr;
TMFileName = [name, ext];
if exist(TMPathName, 'dir')~=7
    errordlg('No output directories!', 'Bad Output Directory', 'modal');
    return;
end

[~, coarseT3D, EA3D, distrms3D]=Fcn_RegExplicitlyMatchedPoints( ...
    TieStemBasePathName, TieStemBaseFileName, ...
    TMPathName, TMFileName);

if isempty(EA3D)
    set(handles.edit_roll, 'String', 'NaN');
    set(handles.edit_pitch, 'String', 'NaN');
    set(handles.edit_yaw, 'String', 'NaN');
else
    set(handles.edit_roll, 'String', num2str(EA3D(1), '%.3f') );
    set(handles.edit_pitch, 'String', num2str(EA3D(2), '%.3f') );
    set(handles.edit_yaw, 'String', num2str(EA3D(3), '%.3f') );
end
if isempty(distrms3D)
    set(handles.edit_distrms, 'String', 'NaN');
else
    set(handles.edit_distrms, 'String', num2str(distrms3D, '%.3f') );
end
if isempty(coarseT3D)
    set(handles.edit_OffsetX, 'String', 'NaN');
    set(handles.edit_OffsetY, 'String', 'NaN');
    set(handles.edit_OffsetZ, 'String', 'NaN');
else
    set(handles.edit_OffsetX, 'String', num2str(coarseT3D(1), '%.3f') );
    set(handles.edit_OffsetY, 'String', num2str(coarseT3D(2), '%.3f') );
    set(handles.edit_OffsetZ, 'String', num2str(coarseT3D(3), '%.3f') );
end

if ~isempty(EA3D) && ~isempty(distrms3D)
    msgbox('Finished: Registration, for Explicitly Matched Feature Points.', 'modal');
end



function edit_TMFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TMFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TMFile as text
%        str2double(get(hObject,'String')) returns contents of edit_TMFile as a double


% --- Executes during object creation, after setting all properties.
function edit_TMFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TMFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_TMFile.
function pushbutton_TMFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TMFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_TMFile, 'String');
[PtsFileName,PathName] = uiputfile({'*.txt', 'ASCII file (*.txt)'; '*.dat', 'File for Riegl (*.dat)'},'Select ascii file for outputting transformation:', initialpath);
if ~PtsFileName
    return;
end
set(handles.edit_TMFile, 'UserData', PathName);
set(handles.edit_TMFile, 'String', fullfile(PathName, PtsFileName));



function edit_MFPFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MFPFile as text
%        str2double(get(hObject,'String')) returns contents of edit_MFPFile as a double


% --- Executes during object creation, after setting all properties.
function edit_MFPFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_MFPFile.
function pushbutton_MFPFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_MFPFile, 'String');
[PtsFileName,PathName] = uigetfile('*.txt','Select ascii file of matched feature points:', initialpath);
if ~PtsFileName
    return;
end
set(handles.edit_MFPFile, 'UserData', PathName);
set(handles.edit_MFPFile, 'String', fullfile(PathName, PtsFileName));



function edit_roll_Callback(hObject, eventdata, handles)
% hObject    handle to edit_roll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_roll as text
%        str2double(get(hObject,'String')) returns contents of edit_roll as a double


% --- Executes during object creation, after setting all properties.
function edit_roll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_roll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pitch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pitch as text
%        str2double(get(hObject,'String')) returns contents of edit_pitch as a double



% --- Executes during object creation, after setting all properties.
function edit_pitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_yaw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_yaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_yaw as text
%        str2double(get(hObject,'String')) returns contents of edit_yaw as a double



% --- Executes during object creation, after setting all properties.
function edit_yaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_yaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_distrms_Callback(hObject, eventdata, handles)
% hObject    handle to edit_distrms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_distrms as text
%        str2double(get(hObject,'String')) returns contents of edit_distrms as a double


% --- Executes during object creation, after setting all properties.
function edit_distrms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_distrms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Clear.
function pushbutton_Clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_roll, 'String', []);
set(handles.edit_pitch, 'String', []);
set(handles.edit_yaw, 'String', []);
set(handles.edit_distrms, 'String', []);
set(handles.edit_OffsetX, 'String', []);
set(handles.edit_OffsetY, 'String', []);
set(handles.edit_OffsetZ, 'String', []);



function edit_OffsetX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_OffsetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_OffsetX as text
%        str2double(get(hObject,'String')) returns contents of edit_OffsetX as a double


% --- Executes during object creation, after setting all properties.
function edit_OffsetX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_OffsetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_OffsetY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_OffsetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_OffsetY as text
%        str2double(get(hObject,'String')) returns contents of edit_OffsetY as a double


% --- Executes during object creation, after setting all properties.
function edit_OffsetY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_OffsetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_OffsetZ_Callback(hObject, eventdata, handles)
% hObject    handle to edit_OffsetZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_OffsetZ as text
%        str2double(get(hObject,'String')) returns contents of edit_OffsetZ as a double


% --- Executes during object creation, after setting all properties.
function edit_OffsetZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_OffsetZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
