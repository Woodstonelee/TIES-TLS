function varargout = GUI_SP_StemBases(varargin)
% GUI_SP_STEMBASES M-file for GUI_SP_StemBases.fig
%      GUI_SP_STEMBASES, by itself, creates a new GUI_SP_STEMBASES or raises the existing
%      singleton*.
%
%      H = GUI_SP_STEMBASES returns the handle to a new GUI_SP_STEMBASES or the handle to
%      the existing singleton*.
%
%      GUI_SP_STEMBASES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SP_STEMBASES.M with the given input arguments.
%
%      GUI_SP_STEMBASES('Property','Value',...) creates a new GUI_SP_STEMBASES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SP_StemBases_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SP_StemBases_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SP_StemBases

% Last Modified by GUIDE v2.5 26-Jul-2010 16:44:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SP_StemBases_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SP_StemBases_OutputFcn, ...
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


% --- Executes just before GUI_SP_StemBases is made visible.
function GUI_SP_StemBases_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SP_StemBases (see VARARGIN)

% Choose default command line output for GUI_SP_StemBases
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SP_StemBases wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SP_StemBases_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_StemLineFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_StemLineFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_StemLineFile as text
%        str2double(get(hObject,'String')) returns contents of edit_StemLineFile as a double


% --- Executes during object creation, after setting all properties.
function edit_StemLineFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_StemLineFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_StemLineFile.
function pushbutton_StemLineFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_StemLineFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_StemLineFile, 'String');
[PtsFileName,PathName] = uigetfile({'FittedStemLine_arrTree_*.txt', 'FittedStemLine_arrTree_*.txt Files (*.txt)'},'Select ascii file of fitted lines of stems:', initialpath);
if ~PtsFileName
    return;
end
set(handles.edit_StemLineFile, 'UserData', PathName);
set(handles.edit_StemLineFile, 'String', fullfile(PathName, PtsFileName));



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
initialpath = get(handles.edit_DEMFile, 'String');
[PtsFileName,PathName] = uigetfile({'DEM_*.txt', 'DEM_*.txt Files (*.txt)'},'Select ascii file of DEM:', initialpath);
if ~PtsFileName
    return;
end
set(handles.edit_DEMFile, 'UserData', PathName);
set(handles.edit_DEMFile, 'String', fullfile(PathName, PtsFileName));



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_outputfile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputfile as text
%        str2double(get(hObject,'String')) returns contents of edit_outputfile as a double


% --- Executes during object creation, after setting all properties.
function edit_outputfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_outputfile.
function pushbutton_outputfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_outputfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_outputfile, 'String');
initialpath = fileparts(initialpath);
[PtsFileName,PathName] = uiputfile({'*.txt', 'StemBases_arrTree_*.txt Files (*.txt)'},'Select ascii file for outputting stem bases:', fullfile(initialpath, 'StemBases_arrTree_.txt'));
if ~PtsFileName
    return;
end
set(handles.edit_outputfile, 'UserData', PathName);
set(handles.edit_outputfile, 'String', fullfile(PathName, PtsFileName));


% --- Executes on button press in pushbutton_Run.
function pushbutton_Run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tempstr = get(handles.edit_StemLineFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
StemLinePathName = pathstr;
StemLineFileName = [name, ext];

tempstr = get(handles.edit_DEMFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
DEMPathName = pathstr;
DEMFileName = [name, ext];

tempstr = get(handles.edit_outputfile, 'String');
[pathstr, name, ext] = fileparts(tempstr);
StemBasePathName = pathstr;
StemBaseFileName = [name, ext];
if exist(StemBasePathName, 'dir')~=7
    errordlg('No output directories!', 'Bad Output Directory', 'modal');
    return;
end

Fcn_StemBases(StemLinePathName, StemLineFileName, ...
    DEMPathName, DEMFileName, ...
    StemBasePathName, StemBaseFileName);
msgbox('Finished: Stem Profiler, Extract Stem Bases.', 'modal');
