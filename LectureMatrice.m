clear all;
close all;

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

Kload = load("Kfreq.mat");

K_freq = Kload.K_freq;
f = Kload.f;

% plot(f,reshape(K_freq(28,49,:),[1,floor(nbpt/2+1)]))

% [m, I_fmax] = max(abs(reshape(K_freq(28,49,:),[1,floor(nbpt/2+1)])));
I_fmax =13;
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
img2 = zeros(Ny,Nx);
img3 = zeros(Ny,Nx);
img4 = zeros(Ny,Nx);
img5 = zeros(Ny,Nx);
img6 = zeros(Ny,Nx);

% 
% for f_i=1:length(f)
%     
% %     [U,S,V]=svd(K(:,:,f_i));
%      S(f_i,:) = svd(K_freq(:,:,f_i));
% 
% %      scatter(f(f_i),S,"filled","blue")
% %     hold on 
% %     grid on
%     
% end
% 
% for i=1:length(S(1,:))
%     plot(f,S(:,i))
%     hold on
%     grid on
% end
% 
% 
% xlabel("Fr�quence (MHz)")
% ylabel("Valeurs singuli�res")


[U,S,V]=svd(K_freq(:,:,12));

for i=1:Nx
    for j=1:Ny

        z = [xmin+dx*i;ymin+dy*j];

        n=64;
% 
%         img(j,i) = img(j,i)+I(n,K_freq(n,:,I_fmax),z,f(I_fmax));
% 
%         img(j,i) = retro(V(:,1),z,f(12))+retro(V(:,2),z,f(12))+retro(V(:,3),z,f(12))+retro(V(:,4),z,f(12))+retro(V(:,5),z,f(12));
            img1(j,i)=retro(V(:,1),z,f(12));
            img2(j,i)=retro(V(:,2),z,f(12));
            img3(j,i)=retro(V(:,3),z,f(12));
            img4(j,i)=retro(V(:,4),z,f(12));
            img5(j,i)=retro(V(:,5),z,f(12));
            img6(j,i)=retro(V(:,6),z,f(12));


    end 
end

subplot(1,6,1), image(abs(img1),'CDataMapping','scaled')
subplot(1,6,2), image(abs(img2),'CDataMapping','scaled')
subplot(1,6,3), image(abs(img3),'CDataMapping','scaled')
subplot(1,6,4), image(abs(img4),'CDataMapping','scaled')
subplot(1,6,5), image(abs(img5),'CDataMapping','scaled')
subplot(1,6,6), image(abs(img6),'CDataMapping','scaled')

colorbar
% 
% image(abs(img),'CDataMapping','scaled')
% colorbar 

