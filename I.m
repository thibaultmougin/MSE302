function I = I(i,K_i,z)

    I=0;

    L = 128;
    delta_z = 3.e-4;
    x_l = [zeros(128,2)];
    

    for k=1:L
        x_l(k,2)=(k-L/2)*delta_z;
    end

    for j =1:L 
        I =I+ conj(K_i(j))*G(x_l(j),z)*G(x_l(i),z);
    end
   
end 