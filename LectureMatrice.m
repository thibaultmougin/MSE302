close all
clear all



f_echantillonnage=50;  % fréquence d'échantillonage des signaux en MHz


nbemis=128;       % utilise dans la lecture des fichiers
pemis=1;

nbrecus=128;  % utilisé dans le calcul
precus=1;

ppt=760; % premier point du signal traité
dpt=888; % dernier point du signal traité

   
mnp = OuvertureMNP('dort1.mnp');
if mnp.TypeNum~=2
   Log2LinTab = conversionloglin(mnp);
end;
nbpoints=mnp.NbZ; % dpt=nbpoints;
nbvoies=mnp.NbT; % nombre de bscan stockes
K=zeros(nbemis,nbrecus,nbpoints);
premiere_fois=1;
for voie = pemis:pemis+nbemis-1 %nbelts  % boucle sur l'emission
   K(voie-pemis+1,:,:)= ChargerBScanMNP(mnp,voie,Log2LinTab);
end; 

L = 128;
delta_z = 3.e-4;
x_l = [zeros(128,2)];
for i=0:L
    x_l(i+1,2)=(i-L/2)*delta_z;
end

w_0=4.4e+6;
c_0=1.5e+3;

N = 10;
Nx=100;
Ny=300;

xmin=10;
xmax=30;
ymin=-30;
ymax=30;

dx = (xmax-xmin)/Nx;
dy = (ymax-ymin)/Ny;

for i=1:Nx
    for j=1:Ny
        omega(i,j,:)=[xmin+dx*i;ymin+dy*j];
    end 
end


for i=1:Nx
    for j=1:Ny
        n = 1;
        img(i,j) = I(n,K(n,:,1),[xmin+dx*i;ymin+dy*j]);
    end 
end
image(abs(img))
colorbar 
