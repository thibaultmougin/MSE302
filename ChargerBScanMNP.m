% fonction écrite par Laurent Sandrin pour lire les bscan acquis sur sa baie.

function BScan = ChargerBScanMNP(MNPInfo,numero,Log2LinTab)

   NbLignes = MNPInfo.NbX;
   Longueur = MNPInfo.NbZ;
   BScan = zeros(NbLignes,Longueur);
   numb = MNPInfo.Handle;
   
   switch(MNPInfo.TypeNum)
      
   case 0,
	      Octet = 1;
			fseek(numb,2880+Octet*(numero-1)*NbLignes*Longueur,-1);
   	   for i=1:NbLignes
				BScan(i,:) = fread(numb,Longueur,'unsigned char')';
			end
         	   
         for i=1:NbLignes
           for j=1:Longueur
               BScan(i,j)=Log2LinTab(2*BScan(i,j)+1);
         	end
         end
        
    case 1,     
	      Octet = 2;
			fseek(numb,2880+Octet*(numero-1)*NbLignes*Longueur,-1);
   	   for i=1:NbLignes
				BScan(i,:) = fread(numb,Longueur,'ushort')';
         end
        
         for i=1:NbLignes
            for j=1:Longueur
               BScan(i,j)=Log2LinTab(BScan(i,j)+1);
         	end
         end
      
    case 2,
	      Octet = 2;
			fseek(numb,2880+Octet*(numero-1)*NbLignes*Longueur,-1);
     	 	for i=1:NbLignes
				BScan(i,:) = fread(numb,Longueur,'short')';
			end
                 
     end
