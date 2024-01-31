function G = G(x,y)

    w_0=4.4e+6;
    c_0=1.5e+3;
    k = w_0/c_0;

    G = (1/4i)*besselh(0,k*norm(x-y));
end