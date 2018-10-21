function yk = OverlapAdd(y, L)
    totalRows = length(y);
    yk = y;
    quotient = zeros(L,1);
    for k = 1:totalRows
        yn = y{k,1};   
        Lx = L - (length(yn) - L);
        yk{k,1} = yn(1:L) + quotient;  
        quotient = [yn(L+1:end);zeros(Lx,1)];
    end
end