clear all;
close all;
clc;
%%
% A=imread('2.jpg','jpg');
% I=rgb2lab(A);
% figure(1)
% imshow(uint8(I));
% impixelinfo;

%%
%Iniciamos la camara
vid=videoinput('winvideo',2);
preview(vid)
%
%Tomamos un frame y cerramos la camara
A = getsnapshot(vid);
closepreview;
figure(1)
%guardar en la variable I
image(A);
impixelinfo;
I=rgb2lab(A);
% figure(1)
% imshow(uint8(I));
% impixelinfo;

%%
se= [ 0 0 0 0 1 0 0 0 0
      0 0 0 1 1 1 0 0 0;
      0 0 1 1 1 1 1 0 0;
      0 1 1 1 1 1 1 1 0; 
      1 1 1 1 1 1 1 1 1;
      0 1 1 1 1 1 1 1 0;
      0 0 1 1 1 1 1 0 0;
      0 0 0 1 1 1 0 0 0;
      0 0 0 0 1 0 0 0 0];

  
[M,N,P]=size(I);
Z=zeros(M,N);

G = find([ I(:,:,2)>0] );

Z(G)=255;

figure(2)
imshow(uint8(Z));
impixelinfo;


Bw=imopen(Z,se);
% figure(3)
% imshow(uint8(Bw));
% impixelinfo;
%rellenamos los huecos dentro de las semillas
Bw2 = imfill(Bw,'holes');
figure()
imshow(Bw2);
impixelinfo;
%%
Agray=rgb2gray(A);
% % % figure()
% % % imshow(Agray);
% % % impixelinfo;
RR=A(:,:,1); %extrae la matriz componente R
GG=A(:,:,2); %extrae la matriz componente G
BB=A(:,:,3); %extrae la matriz componente B

Buscarceros = find(Bw2(:,:)==0);
RR(Buscarceros)=0;
GG(Buscarceros)=0;
BB(Buscarceros)=0;
A1(:,:,1)=RR;
A1(:,:,2)=GG;
A1(:,:,3)=BB;
figure()
imshow(uint8(A1));
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
%tdatos1=table(AREA,DIAMETRO,PERIMETRO)
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
    
%     figure()
%     imshow(uint8(S));
%     impixelinfo;
    
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
load trained.mat
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

%Grafico la matriz de confusión
%plotConfMat_corregido(cm,{'cancha' 'choclo' 'morado' 'popcorn' 'rosado'})
%%

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
     S=A1(min(x):max(x),min(y):max(y),1:3); 
     t(i)={S};
    %Segmentacion en RGB
%     S=F(min(x):max(x),min(y):max(y)); 
    
%     figure()
%     imshow(uint8(S));
%     impixelinfo;
end; 

for i=1:K
    figure()
    imshow(cell2mat(t(i)));
    title(yt(i))
    impixelinfo;
end
%%

