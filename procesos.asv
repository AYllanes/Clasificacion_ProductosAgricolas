function varargout = procesos(varargin)
% PROCESOS MATLAB code for procesos.fig
%      PROCESOS, by itself, creates a new PROCESOS or raises the existing
%      singleton*.
%
%      H = PROCESOS returns the handle to a new PROCESOS or the handle to
%      the existing singleton*.
%
%      PROCESOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROCESOS.M with the given input arguments.
%
%      PROCESOS('Property','Value',...) creates a new PROCESOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before procesos_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to procesos_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help procesos

% Last Modified by GUIDE v2.5 07-Jul-2022 22:32:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @procesos_OpeningFcn, ...
                   'gui_OutputFcn',  @procesos_OutputFcn, ...
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


% --- Executes just before procesos is made visible.
function procesos_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to procesos (see VARARGIN)
global A, global I,global Z,global Bw,global Bw2,global A1
axes(handles.ORIGINAL);
imshow(uint8(A)); %Visualiza la imagen en la figura 1.
impixelinfo;

axes(handles.CIELAB);
imshow(uint8(I));
impixelinfo;

axes(handles.BINARIZAR);
imshow(uint8(Z));
impixelinfo;

axes(handles.APERTURA);
imshow(uint8(Bw));
impixelinfo;

axes(handles.RELLENO);
imshow(Bw2);
impixelinfo;

axes(handles.OBJETOS);
imshow(uint8(A1));
impixelinfo;  
% Choose default command line output for procesos
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes procesos wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = procesos_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
