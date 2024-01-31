function G = G(k,x,y)


    G = (1/4i)*besselh(0,k*norm(x-y));
end