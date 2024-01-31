function MNP = OuvertureMNP(NomFichierMNP)

if isempty(NomFichierMNP)
   NomFichierMNP = 'f:\Démonstration\bicouche.MNP';
end

NB_VOIES = 64;

fMNP=fopen(NomFichierMNP,'rb');

if  (fMNP == -1)
	disp('Impossible d ouvrir ce fichier');
	chaine = '????????';
   nom2=[chaine , '.MNP'];
   MNP = -1;
else
	fseek(fMNP,103,-1);
	NbLignes = 	fscanf(fMNP,'%d',1);
	fseek(fMNP,343,-1);
	NbZ = 	fscanf(fMNP,'%d',1);
	fseek(fMNP,423,-1);
	Freq_ech = 	fscanf(fMNP,'%f',1);
	fseek(fMNP,663,-1);
	Retard = 	fscanf(fMNP,'%f',1);
	fseek(fMNP,823,-1);
   Freq_emise = 	fscanf(fMNP,'%f',1);
	fseek(fMNP,2170,-1);
   LongueurEmission = 	fscanf(fMNP,'%d',1);
	fseek(fMNP,2190,-1);
   LongueurRetardIntermediaire = 	fscanf(fMNP,'%d',1);
	fseek(fMNP,2290,-1);
   Courbure = 	fscanf(fMNP,'%f',1);
	fseek(fMNP,2663,-1);
   FrequenceBF = 	fscanf(fMNP,'%f',1);
	fseek(fMNP,2680,-1);
   TypeEmissionBF = 	fscanf(fMNP,'%40c',1);
	fseek(fMNP,2743,-1);
   NbPointsMvtVibreur = 	fscanf(fMNP,'%d',1);
   if(isempty(NbPointsMvtVibreur)~=1)&(NbPointsMvtVibreur~=0)
		fseek(fMNP,2783,-1);
      fPositionMvtVibreur = 	fscanf(fMNP,'%f',1);
   else
      NbPointsMvtVibreur = 0;
   end
	fseek(fMNP,2800,-1);
   Comment = 	fscanf(fMNP,'%80c',1);
   
	fseek(fMNP,2310,-1);
   Vitesse = 	fscanf(fMNP,'%f',1);
   if(isempty(Vitesse))
      Vitesse = 1.5;
   end
   
   
	fseek(fMNP,2370,-1);
   ZDebut = 	fscanf(fMNP,'%f',1);
	fseek(fMNP,2390,-1);
   ZFin = 	fscanf(fMNP,'%f',1);
	fseek(fMNP,2270,-1);
   dPas = 	fscanf(fMNP,'%f',1);
   
	fseek(fMNP,263,-1);
   Numerisation 	= 	fscanf(fMNP,'%c',5);
   
   if(strcmp(Numerisation,'LOG 8')==1)
      TypeNum = 0;
   else
   	if(strcmp(Numerisation,'LOG 9')==1)
      	TypeNum = 1;
      else
     		if(strcmp(Numerisation,'LIN 1')==1)
            TypeNum = 2;
         else
            TypeNum = 1;  
         end
      end
   end
   
   if(TypeNum ~= 2)
   	fseek(fMNP,283,-1);
      Dynamique = 	fscanf(fMNP,'%f',1);
      if((Dynamique == 0) | (isempty(Dynamique)))
         Dynamique = 90;
      end
   else
      Dynamique = 0;
   end
     
   % les coordonnées spatiaux-temporelles
	fseek(fMNP,1143,-1);
	l1Debut 	= 	fscanf(fMNP,'%d',1);
	fseek(fMNP,1223,-1);
	l1Fin  	= 	fscanf(fMNP,'%d',1);
	fseek(fMNP,1302,-1);
	l1Pas  	= 	fscanf(fMNP,'%d',1);
	fseek(fMNP,1383,-1);
	l2Debut 	= 	fscanf(fMNP,'%d',1);
	fseek(fMNP,1463,-1);
	l2Fin  	= 	fscanf(fMNP,'%d',1);
	fseek(fMNP,183,-1); %anciennement 1542
	l2Pas  	= 	fscanf(fMNP,'%d',1);
	fseek(fMNP,1623,-1);
	l3Debut  = 	fscanf(fMNP,'%d',1);
	fseek(fMNP,1703,-1);
	l3Fin  	= 	fscanf(fMNP,'%d',1);
	fseek(fMNP,1782,-1);
	l3Pas  	= 	fscanf(fMNP,'%d',1);

	dX 		= round(l1Pas / 1e3 * 1e3) /1e3;
	dT 		= round(l2Pas / 1e3 * 1e3) /1e3; 
	
	XDebut 	= round(l1Debut / 1e3 * 1e3) /1e3;
	TDebut 	= round(l2Debut / 1e3 * 1e3) /1e3; 
	
	XFin 		= round(l1Fin / 1e3 * 1e3) /1e3;
	TFin 		= round(l2Fin / 1e3 * 1e3) /1e3;	

	clear l1Pas l2Pas l3Pas l1Debut l2Debut l3Debut l1Fin l2Fin l3Fin;
   
   if(dX~=0)
      NbX = (XFin-XDebut) / dX +1;
   else
      NbX = 1;
      XFin = 0;
      XDebut = 0;
   end
   
   if(dT~=0)
      NbT = round((TFin-TDebut) / dT +1);
		if(NbT == 1)
   	   NbT = NbLignes;
      	TDebut = 0;
	      TFin = dT*(NbLignes-1);
	   end
   else
      NbT = 1;
      TFin = 0;
      TDebut = 0;
   end
   
   %ZDebut = 0;
   dZ = 1 / Freq_ech;
   %ZFin = ZDebut + (NbZ-1) * dZ;
   
	%disp(sprintf('%d profondeurs, %d voies et %d images\n',NbZ ,NbX ,NbT ))
 %'LongueurRetardIntermediaire (Nbr de pts)',LongueurRetardIntermediaire,...
   
   MNP = struct(...
		'Filename',NomFichierMNP,...
   	'Handle',fMNP,...
      'TypeNum',TypeNum,...
      'Dynamique',Dynamique,...
      'Vitesse',Vitesse,...
      'FreqEch',Freq_ech,...
      'FreqEmise',Freq_emise,...
   	'LongueurEmission',LongueurEmission,...
   	   'LongueurRetardIntermediaire',LongueurRetardIntermediaire,...
   	'Retard',Retard,...
      'PasInterElement',dPas,...
      'Courbure',Courbure,...
 		'NbX',NbX,...
   	'NbT',NbT,...
   	'NbZ',NbZ,...
   	'dX',dX,...
   	'dT',dT,...
   	'dZ',dZ,...
   	'XDebut',XDebut,...
   	'TDebut',TDebut,...
   	'ZDebut',ZDebut, ...
  		'XFin',XFin,...
   	'TFin',TFin,...
      'ZFin',ZFin,...
      'FrequenceBF',FrequenceBF,...
      'TypeEmissionBF',TypeEmissionBF,...
      'Commentaires',Comment);
   
   if(NbPointsMvtVibreur~=0)
      MNP = setfield(MNP,'NbPointsMvtVibreur',NbPointsMvtVibreur);
      MNP = setfield(MNP,'PositionMvtVibreur',PositionMvtVibreur);
   end
end