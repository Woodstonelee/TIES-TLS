function varargout = GUI_SP_MergeCloseStems(varargin)
% GUI_SP_MERGECLOSESTEMS M-file for GUI_SP_MergeCloseStems.fig
%      GUI_SP_MERGECLOSESTEMS, by itself, creates a new GUI_SP_MERGECLOSESTEMS or raises the existing
%      singleton*.
%
%      H = GUI_SP_MERGECLOSESTEMS returns the handle to a new GUI_SP_MERGECLOSESTEMS or the handle to
%      the existing singleton*.
%
%      GUI_SP_MERGECLOSESTEMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SP_MERGECLOSESTEMS.M with the given input arguments.
%
%      GUI_SP_MERGECLOSESTEMS('Property','Value',...) creates a new GUI_SP_MERGECLOSESTEMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SP_MergeCloseStems_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SP_MergeCloseStems_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SP_MergeCloseStems

% Last Modified by GUIDE v2.5 14-Jul-2011 17:09:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SP_MergeCloseStems_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SP_MergeCloseStems_OutputFcn, ...
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


% --- Executes just before GUI_SP_MergeCloseStems is made visible.
function GUI_SP_MergeCloseStems_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SP_MergeCloseStems (see VARARGIN)

% Choose default command line output for GUI_SP_MergeCloseStems
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SP_MergeCloseStems wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.edit_StemBasesFile, 'String', '');
set(handles.edit_ReliableStemCenterFile, 'String', '');

set(handles.edit_MinStemBaseDist, 'String', '1.0');
set(handles.edit_EpsionRMS, 'String', '0.05');
set(handles.edit_MinNumP, 'String', '6');

set(handles.edit_OutputDirectory, 'String', '');


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SP_MergeCloseStems_OutputFcn(hObject, eventdata, handles) 
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
tempstr = get(handles.edit_StemBasesFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
StemBasePathName = pathstr;
StemBaseFileName = [name, ext];

tempstr = get(handles.edit_ReliableStemCenterFile, 'String');
if exist(tempstr, 'file')~=2
    errordlg('No input files!', 'Bad Input Files', 'modal');
    return;
end
[pathstr, name, ext] = fileparts(tempstr);
ReliableStemCenterPathName = pathstr;
ReliableStemCenterFileName = [name, ext];

tempstr = get(handles.edit_MinStemBaseDist, 'String');
MinStemBaseDist = str2double(tempstr);
if isnan(MinStemBaseDist)
    errordlg('The minimum distance between two seperate stems: invalid input!', 'Bad Input', 'modal');
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

SavePathName = get(handles.edit_OutputDirectory, 'String');
if exist(SavePathName, 'dir')~=7
    errordlg('Invailid output directory!', 'Bad Output Files', 'modal');
    return;
end

MergeTablePathName = SavePathName;
MergeTableFileName = ['MergeTable_', StemBaseFileName];
NewStemCenterPathName = SavePathName;
NewStemCenterFileName = ['New', ReliableStemCenterFileName];
NewStemLinePathName = SavePathName;
NewStemLineFileName = ['NewFittedStemLine_', StemBaseFileName];

err = Fcn_MergeCloseStems(StemBasePathName, StemBaseFileName, ...
    MinStemBaseDist, EpsionRMS, MinNumP, ...
    ReliableStemCenterPathName, ReliableStemCenterFileName, ...
    MergeTablePathName, MergeTableFileName, ...
    NewStemCenterPathName, NewStemCenterFileName, ...
    NewStemLinePathName, NewStemLineFileName);

if ~err
    msgbox('Finished: Refine the stem profiles by merging very close stem bases!', 'modal');
end


% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_StemBasesFile, 'String', '');
set(handles.edit_ReliableStemCenterFile, 'String', '');

set(handles.edit_MinStemBaseDist, 'String', '1.0');
set(handles.edit_EpsionRMS, 'String', '0.05');
set(handles.edit_MinNumP, 'String', '6');

set(handles.edit_OutputDirectory, 'String', '');



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



function edit_StemBasesFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_StemBasesFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_StemBasesFile as text
%        str2double(get(hObject,'String')) returns contents of edit_StemBasesFile as a double


% --- Executes during object creation, after setting all properties.
function edit_StemBasesFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_StemBasesFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_StemBasesFile.
function pushbutton_StemBasesFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_StemBasesFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_StemBasesFile, 'String');
[FileName,PathName] = uigetfile({'*.txt', 'StemBases_*.txt Files (*.txt)'},'Select ascii file of stem bases:', initialpath);
if ~FileName
    return;
end
set(handles.edit_StemBasesFile, 'UserData', PathName);
set(handles.edit_StemBasesFile, 'String', fullfile(PathName, FileName));



function edit_ReliableStemCenterFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ReliableStemCenterFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ReliableStemCenterFile as text
%        str2double(get(hObject,'String')) returns contents of edit_ReliableStemCenterFile as a double


% --- Executes during object creation, after setting all properties.
function edit_ReliableStemCenterFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ReliableStemCenterFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ReliableStemCenterFile.
function pushbutton_ReliableStemCenterFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ReliableStemCenterFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialpath = get(handles.edit_ReliableStemCenterFile, 'String');
[FileName,PathName] = uigetfile({'*.txt', 'ReliableStemCenterByPtsNum&FitLine_*.txt Files (*.txt)'},'Select ascii file of reliable stem centers:', initialpath);
if ~FileName
    return;
end
set(handles.edit_ReliableStemCenterFile, 'UserData', PathName);
set(handles.edit_ReliableStemCenterFile, 'String', fullfile(PathName, FileName));



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



function edit_MinStemBaseDist_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MinStemBaseDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MinStemBaseDist as text
%        str2double(get(hObject,'String')) returns contents of edit_MinStemBaseDist as a double
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
function edit_MinStemBaseDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MinStemBaseDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
