clear all 
close all 

f_echantillonnage=50;  % fr�quence d'�chantillonage des signaux en MHz


w_0=4.4;

c_0=1.5;

N = 10;
Nx=100;
Ny=300;

nbemis=128;       % utilise dans la lecture des fichiers
pemis=1;

nbrecus=128;  % utilis� dans le calcul
precus=1;

ppt=760; % premier point du signal trait�
dpt=888; % dernier point du signal trait�

   
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

K=K(:,:,ppt:dpt);

nbpt=dpt-ppt;

f = f_echantillonnage*(0:nbpt/2)/nbpt;

K_tmp = fft(K,nbpt,3);

K_freq = K_tmp(:,:,1:floor(nbpt/2+1));

% plot(f,reshape(K_freq(28,49,:),[1,floor(nbpt/2+1)]))
% figure 

[m, I_fmax] = max(abs(reshape(K_freq(28,49,:),[1,floor(nbpt/2+1)])));

L = 128;
delta_z = 0.3;
x_l = [zeros(L,2)];

for i=0:L
    x_l(i+1,2)=(i-L/2)*delta_z;
end

xmin=10;
xmax=30;
ymin=-30;
ymax=30;

dx = (xmax-xmin)/Nx;
dy = (ymax-ymin)/Ny;

img = zeros(Ny,Nx);

% for f_i=1:length(f)
%     
%     [U,S,V]=svd(K(:,:,f_i));
%     scatter(f(f_i),diag(S),"filled","blue")
%     grid on 
%     hold on
%     
% end
% xlabel("Fr�quence (MHz)")
% ylabel("Valeurs singuli�res")
% figure

[U,S,V]=svd(K(:,:,I_fmax));

for i=1:Nx
    for j=1:Ny

        z = [xmin+dx*i;ymin+dy*j];

%         n=32;
% 
%         img(j,i) = img(j,i)+I(n,K_freq(n,:,I_fmax),z,f(I_fmax));

        img(j,i) = retro(V(:,2),z,f(I_fmax));

    end 
end



image(abs(img),'CDataMapping','scaled')
colorbar 
