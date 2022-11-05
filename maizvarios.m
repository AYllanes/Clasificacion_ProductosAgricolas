function varargout = maizvarios(varargin)
% MAIZVARIOS MATLAB code for maizvarios.fig
%      MAIZVARIOS, by itself, creates a new MAIZVARIOS or raises the existing
%      singleton*.
%
%      H = MAIZVARIOS returns the handle to a new MAIZVARIOS or the handle to
%      the existing singleton*.
%
%      MAIZVARIOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIZVARIOS.M with the given input arguments.
%
%      MAIZVARIOS('Property','Value',...) creates a new MAIZVARIOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before maizvarios_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to maizvarios_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help maizvarios

% Last Modified by GUIDE v2.5 08-Jul-2022 01:08:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @maizvarios_OpeningFcn, ...
                   'gui_OutputFcn',  @maizvarios_OutputFcn, ...
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


% --- Executes just before maizvarios is made visible.
function maizvarios_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to maizvarios (see VARARGIN)

global t, global yt
% se llena la lista
lista_maiz = {};
for i = 1:length(yt)
    lista_maiz{i} = strcat( "Objeto ", int2str(i) );
end
set( handles.listbox1, 'String', lista_maiz )

% seleccionado en primer valor
axes(handles.axes1);
imshow(cell2mat(t(1)));
title(handles.axes1, yt(1))
impixelinfo;  

% gráfica 
% for i=1:K
%     figure()
%     imshow(cell2mat(t(i)));
%     title(yt(i))
%     impixelinfo;
% end

% Choose default command line output for maizvarios
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes maizvarios wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = maizvarios_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

global t, global yt
valor = get(handles.listbox1, 'Value');

% gráfica
axes(handles.axes1);
imshow(cell2mat(t(valor)));
title(handles.axes1, yt(valor))
impixelinfo; 

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
