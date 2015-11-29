function varargout = GUI_R_MatchFeaturePoints(varargin)
% GUI_R_MATCHFEATUREPOINTS M-file for GUI_R_MatchFeaturePoints.fig
%      GUI_R_MATCHFEATUREPOINTS, by itself, creates a new GUI_R_MATCHFEATUREPOINTS or raises the existing
%      singleton*.
%
%      H = GUI_R_MATCHFEATUREPOINTS returns the handle to a new GUI_R_MATCHFEATUREPOINTS or the handle to
%      the existing singleton*.
%
%      GUI_R_MATCHFEATUREPOINTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_R_MATCHFEATUREPOINTS.M with the given input arguments.
%
%      GUI_R_MATCHFEATUREPOINTS('Property','Value',...) creates a new GUI_R_MATCHFEATUREPOINTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_R_MatchFeaturePoints_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_R_MatchFeaturePoints_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_R_MatchFeaturePoints

% Last Modified by GUIDE v2.5 27-Jul-2010 10:52:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_R_MatchFeaturePoints_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_R_MatchFeaturePoints_OutputFcn, ...
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


% --- Executes just before GUI_R_MatchFeaturePoints is made visible.
function GUI_R_MatchFeaturePoints_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_R_MatchFeaturePoints (see VARARGIN)

% Choose default command line output for GUI_R_MatchFeaturePoints
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_R_MatchFeaturePoints wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_R_MatchFeaturePoints_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_DataFPFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DataFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DataFPFile as text
%        str2double(get(hObject,'String')) returns contents of edit_DataFPFile as a double


% --- Executes during object creation, after setting all properties.
function edit_DataFPFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DataFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_DataFPFile.
function pushbutton_DataFPFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DataFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_DataFPFile, 'String');
[PtsFileName,PathName] = uigetfile('*.txt','Select ASCII file of feature points for DATA:', initialpath);
if ~PtsFileName
    return;
end
set(handles.edit_DataFPFile, 'UserData', PathName);
set(handles.edit_DataFPFile, 'String', fullfile(PathName, PtsFileName));


function edit_ModelFPFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ModelFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ModelFPFile as text
%        str2double(get(hObject,'String')) returns contents of edit_ModelFPFile as a double


% --- Executes during object creation, after setting all properties.
function edit_ModelFPFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ModelFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ModelFPFile.
function pushbutton_ModelFPFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ModelFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_ModelFPFile, 'String');
[PtsFileName,PathName] = uigetfile('*.txt','Select ASCII file of feature points for MODEL:', initialpath);
if ~PtsFileName
    return;
end
set(handles.edit_ModelFPFile, 'UserData', PathName);
set(handles.edit_ModelFPFile, 'String', fullfile(PathName, PtsFileName));



function edit_DisThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DisThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DisThreshold as text
%        str2double(get(hObject,'String')) returns contents of edit_DisThreshold as a double
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
function edit_DisThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DisThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MaxLoopCount_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MaxLoopCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MaxLoopCount as text
%        str2double(get(hObject,'String')) returns contents of edit_MaxLoopCount as a double
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
function edit_MaxLoopCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MaxLoopCount (see GCBO)
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
tempstr = get(handles.edit_DataFPFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
DataStemBasePathName = pathstr;
DataStemBaseFileName = [name, ext];

tempstr = get(handles.edit_ModelFPFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
ModelStemBasePathName = pathstr;
ModelStemBaseFileName = [name, ext];

tempstr = get(handles.edit_TieFPFile, 'String');
[pathstr, name, ext] = fileparts(tempstr);
TieStemBasePathName = pathstr;
TieStemBaseFileName = [name, ext];
if exist(TieStemBasePathName, 'dir')~=7
    errordlg('No output directories!', 'Bad Output Directory', 'modal');
    return;
end

tempstr = get(handles.edit_DisThreshold, 'String');
DisThreshold = str2double(tempstr);
if isnan(DisThreshold)
    errordlg('You must input a valid numeric for the threshold of distance difference to determine whether two distances are matched!', 'Bad Input', 'modal');
    return;
end
tempstr = get(handles.edit_MaxLoopCount, 'String');
MaxLoopCount = str2double(tempstr);
if isnan(MaxLoopCount)
    errordlg('You must input a valid numeric for the Maximum count of iterations!', 'Bad Input', 'modal');
    return;
end

Result = Fcn_MatchFeaturePoints(DataStemBasePathName, DataStemBaseFileName, ...
    ModelStemBasePathName, ModelStemBaseFileName, ...
    DisThreshold, MaxLoopCount, ...
    TieStemBasePathName, TieStemBaseFileName);

if ~isempty(Result)
    tempstr = sprintf('Finished: Registration, Match Feature Points.\n %d point pairs.', size(Result, 1));
    msgbox(tempstr, 'modal');
end


% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_DisThreshold, 'String', '0.2');
set(handles.edit_MaxLoopCount, 'String', '10');



function edit_TieFPFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TieFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TieFPFile as text
%        str2double(get(hObject,'String')) returns contents of edit_TieFPFile as a double


% --- Executes during object creation, after setting all properties.
function edit_TieFPFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TieFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_TieFPFile.
function pushbutton_TieFPFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TieFPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_TieFPFile, 'String');
[PtsFileName,PathName] = uiputfile('*.txt','Select ascii file for outputting Matched Feature Points:', initialpath);
if ~PtsFileName
    return;
end
set(handles.edit_TieFPFile, 'UserData', PathName);
set(handles.edit_TieFPFile, 'String', fullfile(PathName, PtsFileName));
