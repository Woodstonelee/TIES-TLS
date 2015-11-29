function varargout = TIES_TLS(varargin)
% TIES_TLS M-file for TIES_TLS.fig
%      TIES_TLS, by itself, creates a new TIES_TLS or raises the existing
%      singleton*.
%
%      H = TIES_TLS returns the handle to a new TIES_TLS or the handle to
%      the existing singleton*.
%
%      TIES_TLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIES_TLS.M with the given input arguments.
%
%      TIES_TLS('Property','Value',...) creates a new TIES_TLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TIES_TLS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TIES_TLS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TIES_TLS

% Last Modified by GUIDE v2.5 21-Jul-2011 19:55:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TIES_TLS_OpeningFcn, ...
                   'gui_OutputFcn',  @TIES_TLS_OutputFcn, ...
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


% --- Executes just before TIES_TLS is made visible.
function TIES_TLS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TIES_TLS (see VARARGIN)

% Choose default command line output for TIES_TLS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TIES_TLS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TIES_TLS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function TreeClassifier_Callback(hObject, eventdata, handles)
% hObject    handle to TreeClassifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function StemProfiler_Callback(hObject, eventdata, handles)
% hObject    handle to StemProfiler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Registration_Callback(hObject, eventdata, handles)
% hObject    handle to Registration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function R_EMP_Callback(hObject, eventdata, handles)
% hObject    handle to R_EMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_R_ExplicitlyMatchedPoints;


% % --------------------------------------------------------------------
% function SP_SingleScanData_Callback(hObject, eventdata, handles)
% % hObject    handle to SP_SingleScanData (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% GUI_SP_SingleScanData;


% % --------------------------------------------------------------------
% function SP_MultiScanData_Callback(hObject, eventdata, handles)
% % hObject    handle to SP_MultiScanData (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TC_RasterizePointClouds_Callback(hObject, eventdata, handles)
% hObject    handle to TC_RasterizePointClouds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_TC_RasterizePointClouds;

% --------------------------------------------------------------------
function TC_DetectClassifyStems_Callback(hObject, eventdata, handles)
% hObject    handle to TC_DetectClassifyStems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_TC_DetectClassifyStems;


% --------------------------------------------------------------------
function SP_StemBases_Callback(hObject, eventdata, handles)
% hObject    handle to SP_StemBases (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_SP_StemBases;


% --------------------------------------------------------------------
function R_MFP_Callback(hObject, eventdata, handles)
% hObject    handle to R_MFP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_R_MatchFeaturePoints;


% --------------------------------------------------------------------
function FilterLiDARData_Callback(hObject, eventdata, handles)
% hObject    handle to FilterLiDARData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FLD_FilteringVarTIN_Callback(hObject, eventdata, handles)
% hObject    handle to FLD_FilteringVarTIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_FLD_FilteringVarTIN;


% --------------------------------------------------------------------
function FLD_CreateDEM_Callback(hObject, eventdata, handles)
% hObject    handle to FLD_CreateDEM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_FLD_CreateDEM;


% --------------------------------------------------------------------
function SP_StemB2T_Callback(hObject, eventdata, handles)
% hObject    handle to SP_StemB2T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_SP_StemBottom2Top;


% --------------------------------------------------------------------
function SP_StemSection_Callback(hObject, eventdata, handles)
% hObject    handle to SP_StemSection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_SP_EstStemSection;


% --------------------------------------------------------------------
function SP_MergeCloseStems_Callback(hObject, eventdata, handles)
% hObject    handle to SP_MergeCloseStems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_SP_MergeCloseStems;


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function UserManual_Callback(hObject, eventdata, handles)
% hObject    handle to UserManual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen('TIES-TLS User Manual.pdf');


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_About;


% --------------------------------------------------------------------
function SP_DBHandTH_Callback(hObject, eventdata, handles)
% hObject    handle to SP_DBHandTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_SP_DBHandTH;
