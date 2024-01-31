function I = I(i,K_i,z,f)

    I=0;

    L = 128;
    delta_z = 0.3;
    x_l = [zeros(L,2)];
    c_0=1.5;

    k= 2*pi*f/c_0;

    for k=1:L
        x_l(k,2)=(k-L/2)*delta_z;
    end

    for j =1:L     

        I =I+ conj(K_i(j))*G(k,x_l(j,:),z)*G(k,x_l(i,:),z);

    end
   
end 