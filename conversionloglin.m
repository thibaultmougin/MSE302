 function Log2LinTab = ConversionLogLin(MNPInfo)

if(MNPInfo.TypeNum ~= 2 )
   Log2LinTab = zeros(1,512);
	disp('Constuction de la table de conversion log vers lin')
	Temp = MNPInfo.Dynamique / (2^8 *20);
	for Point=1:512
		XLog = (Point - 256);
		if(XLog > 0)    
			Log2LinTab(Point) = round(10.0^(Temp*XLog));
		else
			if(XLog < 0)
				Log2LinTab(Point) = - round(10.0^(Temp*abs(XLog)));
			else
	         Log2LinTab(Point) = 0; 
	      end
	   end
	end
end

   