function varargout = finalito(varargin)
% FINALITO MATLAB code for finalito.fig
%      FINALITO, by itself, creates a new FINALITO or raises the existing
%      singleton*.
%
%      H = FINALITO returns the handle to a new FINALITO or the handle to
%      the existing singleton*.
%
%      FINALITO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALITO.M with the given input arguments.
%
%      FINALITO('Property','Value',...) creates a new FINALITO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before finalito_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to finalito_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help finalito

% Last Modified by GUIDE v2.5 08-Jul-2022 01:28:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @finalito_OpeningFcn, ...
                   'gui_OutputFcn',  @finalito_OutputFcn, ...
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


% --- Executes just before finalito is made visible.
function finalito_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to finalito (see VARARGIN)
cla(handles.capturado,'reset')
set(handles.choclo, 'String', 0);
set(handles.cancha, 'String', 0);
set(handles.popcorn, 'String', 0);
set(handles.morado, 'String', 0);
set(handles.total, 'String', 0);

fondo = imread( 'hola.jpg' );
axes( handles.camara );
imshow( fondo );

% Choose default command line output for finalito
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes finalito wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = finalito_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SUBIR.
function SUBIR_Callback(hObject, eventdata, handles)
% hObject    handle to SUBIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.CAPTURADOR,'Enable','off');
set(handles.PROCESAR,'Enable','on');
set(handles.GUARDAR,'Enable','on');
global capture
filter = {'*.jpg','*png'};
file_image=uigetfile(filter);
img=imread(file_image);
capture = img;
guidata(hObject,handles);
imshow(img,'parent',handles.capturado);
guidata(hObject,handles);

% --- Executes on button press in APAGAR.
function APAGAR_Callback(hObject, eventdata, handles)
% hObject    handle to APAGAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.CAPTURADOR,'enable','off');
set(handles.PROCESAR,'enable','off');set(handles.camara,'visible','off');
closepreview;
set(handles.camara,'visible','on');
fondo=imread('hola.jpg');
axes(handles.camara);
imshow(fondo);

% --- Executes on button press in CAPTURADOR.
function CAPTURADOR_Callback(hObject, eventdata, handles)
% hObject    handle to CAPTURADOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.PROCESAR,'Enable','on');
global capture
global vid
capture=getsnapshot(vid);
axes(handles.capturado);
imshow(uint8(capture)); %Visualiza la imagen en la figura 1.
impixelinfo;

% --- Executes on button press in GUARDAR.
function GUARDAR_Callback(hObject, eventdata, handles)
% hObject    handle to GUARDAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gris = getimage(handles.capturado);
if isempty(gris), return, end
% Guardar archivo
formatos = {'*.jpg','JPEG (*.jpg)';'*.tif','TIFF (*.tif)'};
[nomb,ruta] = uiputfile(formatos,'GUARDAR IMAGEN');
if nomb==0, return, end
fName = fullfile(ruta,nomb);
imwrite(gris,fName);

% --- Executes on button press in PROCESAR.
function PROCESAR_Callback(hObject, eventdata, handles)
% hObject    handle to PROCESAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% clear all;
% close all;
% clc;
global capture, global A, global I,global Z,global Bw,global Bw2,global A1,global t,global yt 
global trainedClassifier
A=capture;
% figure()
% imshow(uint8(A));
% impixelinfo;

se= [ 0 0 0 0 1 0 0 0 0
      0 0 0 1 1 1 0 0 0;
      0 0 1 1 1 1 1 0 0;
      0 1 1 1 1 1 1 1 0; 
      1 1 1 1 1 1 1 1 1;
      0 1 1 1 1 1 1 1 0;
      0 0 1 1 1 1 1 0 0;
      0 0 0 1 1 1 0 0 0;
      0 0 0 0 1 0 0 0 0];

I=rgb2lab(A);  
[M,N,P]=size(I);

Z=zeros(M,N);

G = find([ I(:,:,2)>0] );

Z(G)=255;


Bw=imopen(Z,se);

%rellenamos los huecos dentro de las semillas
Bw2 = imfill(Bw,'holes');

%%

Agray = rgb2gray(A);

RR=A(:,:,1); %extrae la matriz componente R
GG=A(:,:,2); %extrae la matriz componente G
BB=A(:,:,3); %extrae la matriz componente B

Buscarceros = find(Bw2(:,:)==0);
RR(Buscarceros)=0;
GG(Buscarceros)=0;
BB(Buscarceros)=0;
FONDON(:,:,1)=RR;
FONDON(:,:,2)=GG;
FONDON(:,:,3)=BB;
A1=FONDON;

axes(handles.figura);
imshow(uint8(FONDON));
impixelinfo;  
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% MORFOLOGIA GEOMETRICAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%para hallar su morfologia geometrica
[V,K]=bwlabel(Bw2,8);
etiqueta=bwlabel(Bw2);
propiedades = regionprops(etiqueta,'Area');
propiedades1 = regionprops(etiqueta,'EquivDiameter');
propiedades2 = regionprops(etiqueta,'Perimeter');

%para guardar el AREA
L=length(propiedades)
for i=1:L
    area(i)=propiedades(i).Area
end
AR=area.'

%para guardar el DIAMETRO
L=length(propiedades1)
for i=1:L
    diametro(i)=propiedades1(i).EquivDiameter
end
DIA=diametro.'

%para guardar el PERIMETRO
L=length(propiedades2)
for i=1:L
    perimetro(i)=propiedades2(i).Perimeter
end
PER=perimetro.'

%tdatos1 = table(AREA,DIAMETRO,PERIMETRO)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% MORFOLOGIA FOTOMETRICA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
medL=[];
medA=[];
medB=[];

VarL = [];
VarA = [];
VarB = [];
for i=1:K
    ip=find(V==i);
    Ap=length(ip);
    F=zeros(M,N);
    F(ip)=255;
%     figure()
%     imshow(uint8(F));
%     impixelinfo;
    [x,y]=find(F==255);
    
    %Segmentacion en Lab 
    S=uint8(I(min(x):max(x),min(y):max(y),1:3)); 
       
    [x1,y1,p1]=size(S);
    
    CIL = (S(:,:,1));
    CIA = (S(:,:,2));
    CIB = (S(:,:,3));
    
    Tl=[];
    Ta=[];
    Tb=[];

        for i=1:x1
            for j=1:y1
                Tl=[Tl CIL(i,j)];
                Ta=[Ta CIA(i,j)];
                Tb=[Tb CIB(i,j)];
            end
        end
            
    medL = [medL; sum(Tl)/(x1*y1)];
    medA = [medA; sum(Ta)/(x1*y1)];
    medB = [medB; sum(Tb)/(x1*y1)];
    
    VarL = [VarL; std(double(Tl))];
    VarA = [VarA; std(double(Ta))];
    VarB = [VarB; std(double(Tb))];
end; 
%'area', 'diametro', 'perimetro', 'MEDL', 'MEDA', 'MEDB', 'VARL','VARA', 'VARB'
MEDL=medL,
MEDA=medA;
MEDB=medB;
VARL=VarL;
VARA=VarA;
VARB=VarB,
area=AR;
diametro=DIA;
perimetro=PER;
tdatos1=table(area,diametro,perimetro,MEDL,MEDA,MEDB,VARL,VARA,VARB)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% COMPARACION CON EL ENTRENAMIENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global siono
% if siono==0
%     load trained.mat
% end
% if siono==1
%     load trained2.mat
% end
switch siono
    case 0
        load trainedsin.mat
    case 1
        load trainedcon.mat
end
[a,b]=size(tdatos1);
yfit=[];
for i=1:a
    T=tdatos1(i,1:end); 
    ysal=predict(trainedClassifier, T{:,trainedClassifier.PredictorNames}); 
    yfit = [yfit; ysal];
end
res=[tdatos1(:,end),yfit];

%test=categorical(tdatos1.tipos);
yt=categorical(yfit);
%[cm,order]=confusionmat(test,yt);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% GRÁFICA DE MATRIZ DE CONFUSIÓN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%para graficar cada objeto
t={};
for i=1:K
    ip=find(V==i);
    Ap=length(ip);
    F=zeros(M,N);
    F(ip)=255;
%     figure()
%     imshow(uint8(F));
%     impixelinfo;
    [x,y]=find(F==255);

    %Segmentacion en Lab
%     S=I(min(x):max(x),min(y):max(y),1:3); 
    
    %Segmentacion en RGB
     S=FONDON(min(x):max(x),min(y):max(y),1:3); 
     t(i)={S};
    %Segmentacion en RGB
%     S=F(min(x):max(x),min(y):max(y)); 
    
%     figure()
%     imshow(uint8(S));
%     impixelinfo;
end; 

% for i=1:K
%     figure()
%     imshow(cell2mat(t(i)));
%     title(yt(i))
%     impixelinfo;
% end

Choclo = length(find(yt=="choclo"));
Cancha = length(find(yt=="cancha"));
Popcorn =length(find(yt=="popcorn"));
Morado =length(find(yt=="morado"));
Total=length(yt);
switch siono
    case 0
        set(handles.rosado, 'String', '');
        set(handles.rosado1, 'String', '');
    case 1
        Rosado =length(find(yt=="rosado"));
        set(handles.rosado, 'String', 'ROSADO:');
        set(handles.rosado1, 'String', Rosado);
end
set(handles.choclo, 'String', Choclo);
set(handles.cancha, 'String', Cancha);
set(handles.popcorn, 'String', Popcorn);
set(handles.morado, 'String', Morado);
set(handles.total, 'String', Total);

msgbox( 'Procesamiento concluído' )


% --- Executes on button press in ENCENDERCAMARA.
function ENCENDERCAMARA_Callback(hObject, eventdata, handles)
% hObject    handle to ENCENDERCAMARA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.CAPTURADOR,'enable','on');
set(handles.APAGAR,'enable','on');
global capture
global vid
set(handles.camara,'visible','on');
axes(handles.camara);
vid = videoinput('winvideo',1);
vid.ReturnedColorSpace = 'rgb';
vidRes = get (vid,'videoResolution');
nBands = get (vid,'NumberOfBands');
hImagen = image(zeros(vidRes(2),vidRes(1),nBands));
preview(vid,hImagen);
capture = getsnapshot(vid);


% --- Executes on button press in PROCESO.
function PROCESO_Callback(hObject, eventdata, handles)
% hObject    handle to PROCESO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
procesos


% --- Executes on button press in LIMPIAR.
function LIMPIAR_Callback(hObject, eventdata, handles)
% hObject    handle to LIMPIAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.PROCESAR,'enable','off');
cla(handles.capturado,'reset')
cla(handles.figura,'reset')
set(handles.choclo, 'String', 0);
set(handles.cancha, 'String', 0);
set(handles.popcorn, 'String', 0);
set(handles.morado, 'String', 0);
set(handles.total, 'String', 0);
set(finalito, 'HandleVisibility', 'off');
close all;
clear all;
set(finalito, 'HandleVisibility', 'on');

% --- Executes on button press in VERMAIZ.
function VERMAIZ_Callback(hObject, eventdata, handles)
% hObject    handle to VERMAIZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
maizvarios


% --- Executes on button press in AGREGADO.
function AGREGADO_Callback(hObject, eventdata, handles)
% hObject    handle to AGREGADO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when selected object is changed in boton.
function boton_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in boton 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 


% --- Executes when selected object is changed in uibuttongroup5.
function uibuttongroup5_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup5 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global siono
    if  hObject==handles.sin
        siono=0
        set(handles.rosado, 'String','');
        set(handles.rosado1, 'String','');
        msgbox( 'sin valor agregado' )
    elseif hObject==handles.con
        siono=1
        set(handles.rosado,'String','ROSADO:');
        set(handles.rosado1,'String','0');
        msgbox( 'con valor agregado' )
    end
